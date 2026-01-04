# Dotfiles

Personal development environment for macOS/Linux using [chezmoi](https://chezmoi.io). Optimized for speed and cross-platform compatibility.

## Quick Start

```bash
# New machine (one command setup)
chezmoi init --apply richardkiene

# Or with SSH
chezmoi init --apply git@github.com:richardkiene/dotfiles.git
```

That's it. Everything installs automatically.

## What's Included

### Core
- **Shell**: zsh + starship prompt
- **Editor**: Neovim 0.11+ with LSP + Claude Code
- **Terminal**: iTerm2 (with tmux integration)
- **Versions**: mise (replaces nvm, rbenv, pyenv, rustup, etc.)
- **Packages**: Homebrew

### Languages (via mise)
- Node.js (lts)
- Python (3.12)
- Go (latest)
- Rust (latest)
- .NET (latest)

### CLI Tools
- ripgrep, fd, fzf, eza, bat, zoxide
- Docker CLI, docker-compose
- git, gh (GitHub CLI)
- 1Password CLI

## Configuration

### Personal Info (1Password Integration)

Git name/email automatically pulled from 1Password Identity item:
1. Create Identity in 1Password named "Personal" in "Private" vault
2. Fill in first name, last name, email
3. Sign in: `op signin`

Done. No manual git config needed.

### Per-Project Tool Versions

```bash
# In any project
mise use node@18
mise use python@3.11
```

Creates `.mise.toml` in that project. Tools auto-switch on `cd`.

### Local Machine Overrides

Create `~/.zshrc.local` for machine-specific config (not committed).

## Updating

```bash
# Update everything
chezmoi update

# Or manually
cd ~/.local/share/chezmoi
git pull
chezmoi apply
```

## macOS Settings

Capture your current macOS preferences:
```bash
~/.local/share/chezmoi/macos/capture-defaults.sh
```

Apply on new machine:
```bash
source ~/.local/share/chezmoi/macos/defaults.sh
```

## Key Bindings

### Neovim (Leader: Space)
- `Space+cc` - Claude Code
- `Space+ff` - Find files
- `Space+fg` - Grep
- `Space+e` - File explorer
- `gd` - Go to definition
- `K` - Hover docs

### Tmux (Prefix: Ctrl+a)
- `Ctrl+a |` - Split vertical
- `Ctrl+a -` - Split horizontal
- `Ctrl+a h/j/k/l` - Navigate panes

## Aliases

```bash
ls    # eza with icons
cat   # bat with syntax highlighting
cd    # zoxide (smart jumping)
dc    # docker compose
```

## Remote Development

SSH to headless Mac with tmux integration. iTerm2's `-CC` mode maps tmux sessions to native tabs/splits with session persistence.

```bash
dev              # Connect to main tmux session
dev myproject    # Connect to named session
devp api-server  # Connect to session in ~/code/api-server
dev-ls           # List all remote tmux sessions
dev-kill old     # Kill a remote session
```

Requires `dev` host in SSH config. On first `chezmoi apply`, you'll be prompted for the headless Mac's hostname/IP.

## Why These Tools?

- **chezmoi**: Industry-standard dotfiles manager with 1Password integration
- **mise**: Single version manager for all languages (replaces 5+ tools)
- **starship**: Fast Rust-based prompt (~50ms startup vs 250ms+ with oh-my-zsh)
- **iTerm2**: Native tmux integration for persistent remote dev sessions

## Development

```bash
# Edit a dotfile
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Commit and push
chezmoi cd
git add .
git commit -m "Update config"
git push
```

## License

MIT
