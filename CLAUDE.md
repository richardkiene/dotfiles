# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository optimized for macOS development environments. The philosophy emphasizes speed, minimal bloat, and cross-platform compatibility. The setup replaces oh-my-zsh with starship (200-300ms startup improvement) and consolidates multiple version managers (nvm, rbenv, pyenv) into a single tool (mise).

## Installation and Setup

### Initial Setup
```bash
# Run the main installation script
./install.sh
```

The install.sh script:
1. Installs Homebrew (if not present)
2. Installs all packages from Brewfile
3. Creates necessary directories
4. Backs up existing configs to `~/.dotfiles_backup_TIMESTAMP`
5. Symlinks all dotfiles to their proper locations
6. Sets up mise and installs configured tool versions
7. Installs Neovim plugins via lazy.nvim
8. Installs LSP servers (gopls, rust-analyzer, typescript-language-server, etc.)
9. Applies macOS defaults (optional)

### Re-applying Changes
After modifying dotfiles, simply run `./install.sh` again. It backs up existing configs before symlinking, so it's safe to run multiple times.

## Architecture

### Symlink Strategy
All configuration files are symlinked from `~/dotfiles/` to their target locations:
- `~/dotfiles/zsh/.zshrc` → `~/.zshrc`
- `~/dotfiles/zsh/.zshenv` → `~/.zshenv`
- `~/dotfiles/nvim/init.lua` → `~/.config/nvim/init.lua`
- `~/dotfiles/git/.gitconfig` → `~/.gitconfig`
- `~/dotfiles/git/.gitignore_global` → `~/.gitignore_global`
- `~/dotfiles/ghostty/config` → `~/.config/ghostty/config`
- `~/dotfiles/starship.toml` → `~/.config/starship.toml`
- `~/dotfiles/mise/config.toml` → `~/.config/mise/config.toml`

This means editing files in `~/dotfiles/` automatically updates the active configuration.

### Directory Structure
```
~/dotfiles/
├── Brewfile                 # All Homebrew packages
├── install.sh               # Main setup script
├── test-fresh-install.sh    # Test fresh install on current machine
├── verify-setup.sh          # Verify installation is correct
├── README.md                # Comprehensive documentation
├── QUICKREF.md              # Quick reference cheatsheet
├── CLAUDE.md                # This file - guidance for Claude Code
├── TESTING.md               # Testing guide for dotfiles
├── zsh/
│   ├── .zshrc               # Shell configuration
│   └── .zshenv              # Environment variables
├── nvim/
│   └── init.lua             # Neovim configuration (single file)
├── git/
│   ├── .gitconfig           # Git configuration
│   └── .gitignore_global    # Global gitignore
├── ghostty/
│   └── config               # Ghostty terminal config
├── starship.toml            # Starship prompt config
├── mise/
│   └── config.toml          # Version manager config
└── macos/
    ├── capture-defaults.sh  # Script to capture current macOS settings
    └── defaults.sh          # Generated macOS preferences (do not hand-edit)
```

## Key Components

### Shell (zsh)
- **Fast startup**: ~50ms with starship (vs 250-350ms with oh-my-zsh)
- **Minimal dependencies**: No plugin managers, direct tool integration
- **Modern CLI replacements**: eza (ls), bat (cat), zoxide (cd), ripgrep, fd, fzf
- **1Password SSH agent integration**: SSH keys managed by 1Password

Important paths added:
- `$HOME/go/bin` - Go binaries
- `$HOME/.claude/local` - Claude Code CLI
- `$HOME/.local/bin` - Local user binaries
- `$HOME/.dotnet/tools` - .NET global tools

### Version Management (mise)
Replaces nvm, rbenv, pyenv, etc. with a single Rust-based tool.

Global defaults in `mise/config.toml`:
- Node.js: `lts` (latest LTS)
- Python: `3.12`

Project-specific versions use `.mise.toml` or `.tool-versions` in project root.

```bash
mise use node@20            # Set Node.js 20 for project
mise install                # Install all from config
mise doctor                 # Check configuration
```

### Neovim (0.11+)
Single-file configuration (`nvim/init.lua`) using Neovim 0.11+ built-in features:
- **Built-in LSP**: No external plugins needed
- **Built-in completion**: `vim.lsp.completion.enable()`
- **Virtual lines for diagnostics**: New in 0.11
- **lazy.nvim**: Plugin manager

Plugins:
- `claudecode.nvim` - Claude Code WebSocket integration
- `telescope.nvim` - Fuzzy finder
- `nvim-treesitter` - Syntax highlighting
- `gitsigns.nvim` - Git integration
- `nvim-tree.lua` - File explorer
- `lualine.nvim` - Status line
- `vscode.nvim` - Color scheme
- `render-markdown.nvim` - Markdown rendering

LSP servers auto-start on FileType:
- Go: gopls
- Rust: rust-analyzer
- TypeScript/JavaScript: typescript-language-server
- C/C++: clangd
- Swift: sourcekit-lsp (macOS)
- HTML/CSS: vscode-langservers-extracted
- Lua: lua-language-server

### Terminal (Ghostty)
Fast, GPU-accelerated terminal written in Zig. Cross-platform (macOS/Linux).

Key configuration:
- Theme: VSCode_Dark
- Font: FiraCode Nerd Font (13pt with ligatures)
- Shell integration enabled
- macOS Option key as Alt

### Prompt (Starship)
Cross-platform prompt written in Rust. Shows:
- Git branch and status
- Language versions (when in project)
- Command duration (if >500ms)
- Current directory (truncated)

## Common Development Tasks

### Adding New Homebrew Packages
1. Add to `Brewfile`
2. Run `brew bundle --file=$HOME/dotfiles/Brewfile`

### Modifying Shell Configuration
1. Edit `zsh/.zshrc` or `zsh/.zshenv`
2. Run `source ~/.zshrc` or restart shell

### Modifying Neovim Configuration
1. Edit `nvim/init.lua`
2. Restart Neovim or run `:source ~/.config/nvim/init.lua`
3. For plugin changes: `:Lazy sync`

### Adding New LSP Server
1. Install the server (via npm, go install, cargo, etc.)
2. Add FileType autocmd in `nvim/init.lua` following existing patterns
3. Test by opening a file of that type

### Updating macOS Defaults

**IMPORTANT**: Unlike typical dotfiles, `macos/defaults.sh` is **generated from your actual macOS settings**, not hand-written.

**To capture current macOS settings:**
```bash
cd ~/dotfiles/macos
./capture-defaults.sh
```

This script:
- Reads your current macOS defaults using `defaults read`
- Generates a new `defaults.sh` with only the settings you have configured
- Backs up the previous `defaults.sh` with a timestamp
- Skips any defaults that don't exist or are unset

**To apply settings:**
```bash
source ~/dotfiles/macos/defaults.sh
# Some changes require logout/restart
```

**Workflow for modifying macOS defaults:**
1. Change settings in System Settings (the GUI)
2. Run `./capture-defaults.sh` to capture them
3. Review the generated `defaults.sh`
4. Commit the changes to git
5. Apply on other machines with `source defaults.sh`

**Do NOT hand-edit `defaults.sh`** - it will be overwritten next time the capture script runs. If you need custom settings, add them to the "Special Settings" section at the bottom, or modify `capture-defaults.sh` to capture additional domains/keys.

## Testing

### Testing Fresh Install

Before deploying to a new machine, test your dotfiles on the current machine:

```bash
# Test as if on a new machine (creates backup first)
./test-fresh-install.sh

# Restart shell
exec zsh

# Verify everything works
./verify-setup.sh
```

See `TESTING.md` for comprehensive testing guide.

### Testing Install Script
```bash
# Dry run (check what would be installed)
brew bundle check --file=$HOME/dotfiles/Brewfile

# Test Neovim plugin installation
nvim --headless "+Lazy! sync" +qa

# Test LSP server availability
which gopls rust-analyzer typescript-language-server
```

### Testing Shell Performance
```bash
# Profile startup time
time zsh -i -c exit

# Should be under 100ms with this config
```

### Testing Neovim Configuration
```bash
# Check for errors in init.lua
nvim --headless -c "lua print(vim.inspect(vim.api.nvim_get_runtime_file('init.lua', false)))" -c qa

# Check LSP status (in Neovim)
:LspInfo

# Check diagnostic config
:lua print(vim.inspect(vim.diagnostic.config()))
```

## Important Notes

### Git Configuration
The `.gitconfig` includes placeholder values that must be updated:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Local Overrides
Create `~/.zshrc.local` for machine-specific configuration that won't be committed:
```bash
# Example .zshrc.local
export WORK_PROJECT_DIR="/path/to/work"
alias work="cd $WORK_PROJECT_DIR"
```

### 1Password SSH Agent
The SSH_AUTH_SOCK path is hardcoded for macOS:
```bash
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
```

### Platform Differences
Most configs are cross-platform, but macOS-specific:
- `macos/defaults.sh` - Only runs on macOS
- 1Password SSH agent path
- Ghostty config uses `macos-option-as-alt`
- Homebrew install location differs (Intel vs Apple Silicon)

## Troubleshooting

### Shell startup is slow
```bash
time zsh -i -c exit  # Should be under 100ms
# If slow, check for problematic sourced files
```

### LSP not working in Neovim
```bash
# Check server installed
which gopls

# Check in Neovim
:LspInfo

# Manually start LSP for debugging
:lua vim.lsp.start({name='gopls', cmd={'gopls'}})
```

### mise not finding tools
```bash
mise doctor        # Check configuration
mise list          # List installed tools
mise install       # Install missing tools
```

### Symlinks broken
```bash
# Re-run install script
cd ~/dotfiles
./install.sh
```

### Homebrew on Apple Silicon
```bash
# Ensure Homebrew is in PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Maintenance

### Capturing and Preserving Your Preferences

This repository uses a **capture-based approach** for macOS settings instead of prescriptive defaults. This means the `macos/defaults.sh` file reflects **your actual preferences**, not someone else's opinions.

**When to capture settings:**
- After setting up a new Mac the way you like it
- After changing macOS settings in System Settings
- Before setting up a new machine (to preserve current state)
- Periodically as a backup of your preferences

**How to capture:**
```bash
cd ~/dotfiles/macos
./capture-defaults.sh
git diff defaults.sh  # Review what changed
git add defaults.sh
git commit -m "Update macOS defaults to match current preferences"
```

**The capture script handles:**
- Reading current values with `defaults read`
- Determining correct data types (bool, int, float, string)
- Escaping special characters properly
- Skipping unset or non-existent keys
- Backing up previous version automatically
- Generating clean, executable shell script

**If you need to capture additional settings:**
1. Open `macos/capture-defaults.sh`
2. Add new `capture_default` calls following existing patterns:
   ```bash
   capture_default "domain" "key" "Description"
   ```
3. Run the script to regenerate `defaults.sh`

### Updating Everything
```bash
# Update Homebrew packages
brew update && brew upgrade

# Update mise tools
mise upgrade

# Update Neovim plugins (in Neovim)
:Lazy update

# Pull dotfiles updates
cd ~/dotfiles
git pull
./install.sh
```

### Cleaning Up
```bash
# Remove old Homebrew versions
brew cleanup

# Remove old mise versions
mise prune

# Clean Neovim plugin cache
rm -rf ~/.local/share/nvim

# Clean old defaults.sh backups (if desired)
rm ~/dotfiles/macos/defaults.sh.backup.*
```
