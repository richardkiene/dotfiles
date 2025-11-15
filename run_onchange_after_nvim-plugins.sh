#!/bin/bash
# run_onchange_after_nvim-plugins.sh
# This script runs whenever Neovim config changes to install/update plugins

set -e

echo "📝 Installing/updating Neovim plugins..."

if command -v nvim &> /dev/null; then
    nvim --headless "+Lazy! sync" +qa
    echo "✅ Neovim plugins synced!"
else
    echo "⚠️  Neovim not found, skipping plugin installation"
fi
