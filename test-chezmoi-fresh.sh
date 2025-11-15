#!/bin/bash
# test-chezmoi-fresh.sh - Test chezmoi setup as if on a fresh machine

set -e

BACKUP_DIR="$HOME/.dotfiles_chezmoi_test_$(date +%Y%m%d_%H%M%S)"

echo "🧪 Testing chezmoi fresh install"
echo ""
echo "This will:"
echo "  1. Back up your current dotfiles and chezmoi state"
echo "  2. Remove current dotfiles that chezmoi will manage"
echo "  3. Test fresh chezmoi init from GitHub"
echo "  4. Provide rollback instructions if needed"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# ============================================================================
# Step 1: Create comprehensive backup
# ============================================================================

echo ""
echo "📦 Step 1: Creating backup at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup current dotfiles
echo "  Backing up current dotfiles..."
for file in \
    ~/.zshrc \
    ~/.zshenv \
    ~/.gitconfig \
    ~/.gitignore_global \
    ~/.tmux.conf \
    ~/.config/nvim \
    ~/.config/ghostty \
    ~/.config/mise \
    ~/.config/starship.toml \
    ~/.zsh_history
do
    if [ -e "$file" ]; then
        echo "    Backing up: $file"
        cp -RP "$file" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

# Backup chezmoi state
if [ -d ~/.local/share/chezmoi ]; then
    echo "  Backing up chezmoi state..."
    cp -R ~/.local/share/chezmoi "$BACKUP_DIR/chezmoi_source"
fi

if [ -d ~/.local/state/chezmoi ]; then
    cp -R ~/.local/state/chezmoi "$BACKUP_DIR/chezmoi_state"
fi

# Create inventory
echo "  Creating package inventory..."
{
    echo "=== Homebrew Packages ==="
    brew list --formula 2>/dev/null || true
    echo ""
    echo "=== mise Tools ==="
    mise list 2>/dev/null || true
} > "$BACKUP_DIR/package_inventory.txt"

echo "  ✅ Backup created: $BACKUP_DIR"

# ============================================================================
# Step 2: Remove current chezmoi state
# ============================================================================

echo ""
echo "🗑️  Step 2: Removing current chezmoi state..."

if [ -d ~/.local/share/chezmoi ]; then
    echo "  Removing ~/.local/share/chezmoi"
    rm -rf ~/.local/share/chezmoi
fi

if [ -d ~/.local/state/chezmoi ]; then
    echo "  Removing ~/.local/state/chezmoi"
    rm -rf ~/.local/state/chezmoi
fi

# ============================================================================
# Step 3: Remove managed dotfiles
# ============================================================================

echo ""
echo "🗑️  Step 3: Removing dotfiles that chezmoi will manage..."

remove_if_exists() {
    local file=$1
    if [ -e "$file" ]; then
        echo "  Removing: $file"
        rm -rf "$file"
    fi
}

remove_if_exists ~/.zshrc
remove_if_exists ~/.zshenv
remove_if_exists ~/.gitconfig
remove_if_exists ~/.gitignore_global
remove_if_exists ~/.tmux.conf
remove_if_exists ~/.config/nvim
remove_if_exists ~/.config/ghostty/config
remove_if_exists ~/.config/mise/config.toml
remove_if_exists ~/.config/starship.toml

echo "  ✅ Dotfiles removed"

# ============================================================================
# Step 4: Test fresh chezmoi init
# ============================================================================

echo ""
echo "🚀 Step 4: Testing fresh chezmoi init from GitHub..."
echo ""

# Ensure 1Password is signed in
if ! op account get &>/dev/null; then
    echo "⚠️  You're not signed in to 1Password. Sign in now:"
    op signin
fi

# Initialize chezmoi from GitHub
echo "  Running: chezmoi init --apply richardkiene"
echo ""
chezmoi init --apply richardkiene

echo ""
echo "✅ Fresh install complete!"

# ============================================================================
# Step 5: Verify installation
# ============================================================================

echo ""
echo "🔍 Step 5: Verifying installation..."
echo ""

check_file() {
    local file=$1
    local desc=$2
    if [ -e "$file" ]; then
        echo "  ✅ $desc: $file"
    else
        echo "  ❌ $desc: $file (MISSING)"
    fi
}

check_file ~/.zshrc "zsh config"
check_file ~/.gitconfig "git config"
check_file ~/.config/nvim/init.lua "neovim config"
check_file ~/.config/ghostty/config "ghostty config"
check_file ~/.config/mise/config.toml "mise config"
check_file ~/.config/starship.toml "starship config"
check_file ~/.tmux.conf "tmux config"

# Check if mise tools are installed
echo ""
echo "  mise tools:"
if command -v mise &>/dev/null; then
    mise current | while read -r line; do
        echo "    ✅ $line"
    done
else
    echo "    ⚠️  mise not found"
fi

# ============================================================================
# Summary
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Test Complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo ""
echo "1. Restart your shell to load new config:"
echo "   exec zsh"
echo ""
echo "2. Test functionality:"
echo "   - Shell startup time: time zsh -i -c exit"
echo "   - Aliases: ls, cat, cd"
echo "   - Git config: git config user.name && git config user.email"
echo "   - mise: mise current"
echo "   - Neovim: nvim (check :Lazy, :LspInfo)"
echo ""
echo "3. If everything works:"
echo "   - You can delete the backup: rm -rf $BACKUP_DIR"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 ROLLBACK INSTRUCTIONS (if something went wrong):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "# 1. Remove chezmoi installation"
echo "rm -rf ~/.local/share/chezmoi ~/.local/state/chezmoi"
echo ""
echo "# 2. Restore from backup"
echo "cp -R $BACKUP_DIR/.zshrc ~/"
echo "cp -R $BACKUP_DIR/.zshenv ~/"
echo "cp -R $BACKUP_DIR/.gitconfig ~/"
echo "cp -R $BACKUP_DIR/nvim ~/.config/"
echo "cp -R $BACKUP_DIR/ghostty ~/.config/"
echo "cp -R $BACKUP_DIR/mise ~/.config/"
echo "cp -R $BACKUP_DIR/starship.toml ~/.config/"
echo "cp -R $BACKUP_DIR/.tmux.conf ~/"
echo ""
echo "# 3. Restore chezmoi state (if you want to go back)"
echo "cp -R $BACKUP_DIR/chezmoi_source ~/.local/share/chezmoi"
echo "cp -R $BACKUP_DIR/chezmoi_state ~/.local/state/chezmoi"
echo ""
echo "# 4. Restart shell"
echo "exec zsh"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📦 Backup location: $BACKUP_DIR"
echo "   Keep until you're satisfied with the new setup!"
echo ""
