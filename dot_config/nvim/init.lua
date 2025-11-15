-- init.lua - Neovim 0.11+ Configuration
-- Minimal setup with Claude Code, LSP, and essential plugins
-- https://github.com/yourusername/nvim-claude-setup

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw (use nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ============================================================================
-- Editor Settings
-- ============================================================================

vim.opt.number = true              -- Line numbers
vim.opt.relativenumber = true      -- Relative line numbers
vim.opt.mouse = 'a'                -- Enable mouse
vim.opt.clipboard = 'unnamedplus'  -- System clipboard
vim.opt.breakindent = true         -- Wrapped lines preserve indent
vim.opt.undofile = true            -- Persistent undo
vim.opt.ignorecase = true          -- Case insensitive search
vim.opt.smartcase = true           -- Unless uppercase used
vim.opt.signcolumn = 'yes'         -- Always show sign column
vim.opt.updatetime = 250           -- Faster completion
vim.opt.timeoutlen = 300           -- Faster key sequences
vim.opt.splitright = true          -- Vertical splits go right
vim.opt.splitbelow = true          -- Horizontal splits go below
vim.opt.expandtab = true           -- Spaces instead of tabs
vim.opt.shiftwidth = 4             -- Indent = 4 spaces
vim.opt.tabstop = 4                -- Tab = 4 spaces
vim.opt.termguicolors = true       -- True color support

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ============================================================================
-- Plugin Manager (lazy.nvim)
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.fn.isdirectory(lazypath) == 0 then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugins
-- ============================================================================

require("lazy").setup({
  -- Claude Code WebSocket Integration
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.35,
        provider = "native",
        terminal_cmd = function()
          return vim.fn.expand("~/.claude/local/claude")
        end,
      },
      diff_opts = {
        open_in_new_tab = true,           -- Opens diffs in a new tab (fixes split width issues)
        hide_terminal_in_new_tab = false,  -- Hides Claude terminal in diff tab for full width
      },
    },
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>cs", "<cmd>ClaudeCodeStatus<cr>", desc = "Claude Status" },
    },
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    },
  },

  -- Treesitter (Better Syntax Highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "go", "javascript", "typescript", "rust", "c",
          "html", "css", "lua", "vim", "vimdoc", "markdown", "markdown_inline"
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
      },
    },
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,  -- Load immediately, not lazily
    config = function()
      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 35,
          side = "left",
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
      })

      -- Open nvim-tree on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          require("nvim-tree.api").tree.open()
        end,
      })

      -- Keybindings
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle File Explorer' })
      vim.keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFile<cr>', { desc = 'Find Current File' })
    end,
  },

  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  -- Color Scheme
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require('vscode').setup({
        transparent = false,
        italic_comments = true,
      })
      vim.cmd.colorscheme("vscode")

      -- Custom darker background for terminal windows
      vim.api.nvim_set_hl(0, 'TerminalNormal', { bg = '#0a0a0a', fg = '#d4d4d4' })
      vim.api.nvim_set_hl(0, 'TerminalNormalNC', { bg = '#0a0a0a', fg = '#d4d4d4' })

      -- Brighter separator for terminal windows
      vim.api.nvim_set_hl(0, 'TerminalWinSeparator', { fg = '#3a3a3a', bg = '#0a0a0a' })
    end,
  },

  -- Markdown Rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = "markdown",  -- Only load for markdown files
    opts = {
      heading = {
        enabled = true,
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        left_pad = 2,
        right_pad = 2,
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
    },
    keys = {
      { "<leader>md", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Rendering", ft = "markdown" },
    },
  },
})

-- ============================================================================
-- Terminal Styling (Darker background for Claude Code)
-- ============================================================================

-- Apply darker background and brighter borders to terminal windows
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.wo.winhighlight = 'Normal:TerminalNormal,NormalNC:TerminalNormalNC,WinSeparator:TerminalWinSeparator'
  end,
})

-- ============================================================================
-- LSP Configuration (Neovim 0.11+ Built-in)
-- ============================================================================

-- Enable built-in completion on LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Enable built-in auto-completion
    if client and client.supports_method('textDocument/completion', args.buf) then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end

    -- LSP Keybindings
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  end,
})

-- Language Server Configurations
-- Servers auto-start when you open the corresponding file type

-- Go
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    if vim.fn.executable('gopls') == 1 then
      vim.lsp.start({
        name = 'gopls',
        cmd = {'gopls'},
        root_dir = vim.fs.root(0, {'go.mod', '.git'}),
      })
    end
  end,
})

-- Rust
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    if vim.fn.executable('rust-analyzer') == 1 then
      vim.lsp.start({
        name = 'rust-analyzer',
        cmd = {'rust-analyzer'},
        root_dir = vim.fs.root(0, {'Cargo.toml', '.git'}),
      })
    end
  end,
})

-- TypeScript/JavaScript
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'typescript', 'javascript', 'typescriptreact', 'javascriptreact'},
  callback = function()
    if vim.fn.executable('typescript-language-server') == 1 then
      vim.lsp.start({
        name = 'ts_ls',
        cmd = {'typescript-language-server', '--stdio'},
        root_dir = vim.fs.root(0, {'package.json', 'tsconfig.json', '.git'}),
      })
    end
  end,
})

-- C/C++
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'c', 'cpp'},
  callback = function()
    if vim.fn.executable('clangd') == 1 then
      vim.lsp.start({
        name = 'clangd',
        cmd = {'clangd'},
        root_dir = vim.fs.root(0, {'compile_commands.json', '.git'}),
      })
    end
  end,
})

-- Swift (macOS)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'swift',
  callback = function()
    if vim.fn.executable('sourcekit-lsp') == 1 then
      vim.lsp.start({
        name = 'sourcekit',
        cmd = {'sourcekit-lsp'},
        root_dir = vim.fs.root(0, {'Package.swift', '.git'}),
      })
    end
  end,
})

-- HTML
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'html',
  callback = function()
    if vim.fn.executable('vscode-html-language-server') == 1 then
      vim.lsp.start({
        name = 'html',
        cmd = {'vscode-html-language-server', '--stdio'},
        root_dir = vim.fs.root(0, {'.git'}),
      })
    end
  end,
})

-- CSS
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'css',
  callback = function()
    if vim.fn.executable('vscode-css-language-server') == 1 then
      vim.lsp.start({
        name = 'cssls',
        cmd = {'vscode-css-language-server', '--stdio'},
        root_dir = vim.fs.root(0, {'.git'}),
      })
    end
  end,
})

-- Lua (for Neovim config editing)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    if vim.fn.executable('lua-language-server') == 1 then
      vim.lsp.start({
        name = 'lua_ls',
        cmd = {'lua-language-server'},
        root_dir = vim.fs.root(0, {'.git'}),
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = {'vim'} },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
          },
        },
      })
    end
  end,
})

-- ============================================================================
-- Diagnostics (Neovim 0.11+ has virtual_lines!)
-- ============================================================================

vim.diagnostic.config({
  virtual_text = false,     -- Disable inline text
  virtual_lines = true,     -- Enable virtual lines (new in 0.11!)
  update_in_insert = false,
})

-- Toggle virtual lines
vim.keymap.set('n', '<leader>dt', function()
  local config = vim.diagnostic.config()
  if config then
    vim.diagnostic.config({
      virtual_lines = not config.virtual_lines,
    })
  end
end, { desc = 'Toggle diagnostic lines' })

-- ============================================================================
-- Keybindings
-- ============================================================================

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move to upper window" })

-- Window resizing
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -3<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +3<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<S-Up>", "<cmd>resize +3<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<S-Down>", "<cmd>resize -3<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Make splits equal size" })

-- Terminal splits
vim.keymap.set('n', '<leader>tt', '<cmd>split | terminal<cr>', { desc = 'Terminal horizontal' })
vim.keymap.set('n', '<leader>tv', '<cmd>vsplit | terminal<cr>', { desc = 'Terminal vertical' })

-- Terminal mode navigation (easier window switching from terminal)
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Move to upper window' })

-- Diagnostic navigation
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic list' })
