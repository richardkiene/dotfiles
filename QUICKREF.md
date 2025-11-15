# Quick Reference Cheatsheet

## Shell Shortcuts

### Zoxide (Smart cd)
```bash
z <partial-name>    # Jump to directory
zi                  # Interactive search
z -                 # Go back to previous directory
```

### Modern CLI Tools
```bash
ls          # Lists with icons (eza)
ll          # Long listing
la          # Show hidden files
cat <file>  # Syntax highlighted (bat)
cd <dir>    # Smart jump (zoxide)
```

### Docker
```bash
dc          # docker compose
dps         # docker ps
dim         # docker images
```

### Git
```bash
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gl          # git log (formatted)
```

## Neovim

### Leader Key: `Space`

### Essential Mappings
```
Space+cc    # Toggle Claude Code
Space+cs    # Claude Code status

Space+ff    # Find files (Telescope)
Space+fg    # Live grep
Space+fb    # Open buffers
Space+fh    # Help tags

Space+e     # Toggle file explorer
Space+ef    # Find current file in explorer

Space+tt    # Terminal horizontal split
Space+tv    # Terminal vertical split
```

### LSP
```
gd          # Go to definition
gr          # Find references
gI          # Go to implementation
gy          # Go to type definition
K           # Hover documentation
Space+rn    # Rename symbol
Space+ca    # Code actions
```

### Diagnostics
```
[d          # Previous diagnostic
]d          # Next diagnostic
Space+de    # Show diagnostic
Space+dt    # Toggle diagnostic lines
Space+q     # Diagnostic list
```

### Window Management
```
Ctrl+h/j/k/l    # Move between windows
Shift+Arrow     # Resize windows
Space+w=        # Equalize window sizes
```

### Terminal Mode
```
Ctrl+h/j/k/l    # Move to window (from terminal)
```

## mise (Version Manager)

### Usage
```bash
mise use node@20            # Set Node.js 20 for project
mise use python@3.12        # Set Python 3.12
mise install                # Install all from config
mise list                   # List installed tools
mise ls-remote node         # List available Node versions
mise current                # Show current versions
mise doctor                 # Check configuration
```

### Project Config
Create `.mise.toml` in project root:
```toml
[tools]
node = "18"
python = "3.11"
```

## Ghostty

### Key Bindings
```
Cmd+T               # New tab
Cmd+W               # Close tab
Cmd+Shift+[/]       # Previous/Next tab

Cmd+D               # Split right
Cmd+Shift+D         # Split down
Cmd+Arrow           # Navigate splits

Cmd+K               # Clear screen
Cmd++               # Increase font
Cmd+-               # Decrease font
Cmd+0               # Reset font size
```

## Tmux

### Prefix: `Ctrl+a`

### Essential Commands
```
Ctrl+a |        # Split vertically
Ctrl+a -        # Split horizontally
Ctrl+a c        # New window
Ctrl+a n        # Next window
Ctrl+a p        # Previous window
Ctrl+a h/j/k/l  # Navigate panes
Ctrl+a H/J/K/L  # Resize panes
Ctrl+a m        # Maximize/unmaximize pane
Ctrl+a r        # Reload config
Ctrl+a d        # Detach session
```

### Sessions
```bash
tmux                # Start new session
tmux new -s name    # Named session
tmux ls             # List sessions
tmux attach -t name # Attach to session
tmux kill-session   # Kill session
```

## Starship Prompt

### Features
- Git branch and status
- Language versions (when in project)
- Command duration (if >500ms)
- Current directory (truncated)

### Colors
- Green: Success
- Red: Error/failure
- Purple: Git branch
- Yellow: Git status/warnings
- Cyan: Directory

## Homebrew

### Common Commands
```bash
brew update             # Update Homebrew
brew upgrade            # Upgrade packages
brew list               # List installed
brew search <name>      # Search packages
brew info <name>        # Package info
brew cleanup            # Remove old versions
```

## fzf (Fuzzy Finder)

### Shell Shortcuts
```
Ctrl+T      # Paste selected file
Ctrl+R      # Paste from history
Alt+C       # cd into directory
```

## Tips & Tricks

### Find and Replace in Files
```bash
# Using ripgrep and sed
rg "old-text" -l | xargs sed -i '' 's/old-text/new-text/g'
```

### Watch Command Output
```bash
watch -n 2 'ls -lh'     # Update every 2 seconds
```

### JSON Formatting
```bash
cat file.json | jq '.'  # Pretty print
cat file.json | jq '.key'  # Extract key
```

### Quick HTTP Server
```bash
python3 -m http.server 8000
# Or with node
npx http-server
```

### Port Management
```bash
lsof -ti:8080 | xargs kill  # Kill process on port 8080
```

### Disk Usage
```bash
du -sh *                # Directory sizes
du -sh * | sort -h      # Sorted by size
```

### Process Management
```bash
ps aux | grep <name>    # Find process
kill -9 <pid>           # Force kill
pkill <name>            # Kill by name
```

## Configuration Files

All configs are in `~/dotfiles/`:

```
~/.zshrc            → ~/dotfiles/zsh/.zshrc
~/.config/nvim/     → ~/dotfiles/nvim/
~/.gitconfig        → ~/dotfiles/git/.gitconfig
~/.config/ghostty/  → ~/dotfiles/ghostty/
~/.tmux.conf        → ~/dotfiles/tmux/.tmux.conf
```

## Quick Setup on New Machine

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
exec zsh
```

## Troubleshooting

### Shell Slow?
```bash
time zsh -i -c exit     # Profile startup time
```

### LSP Not Working?
```bash
:LspInfo                # In Neovim
which gopls             # Check if installed
```

### mise Issues?
```bash
mise doctor             # Check configuration
```

### Git Identity?
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
