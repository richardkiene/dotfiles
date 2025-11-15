#!/bin/bash
# run_once_install-lsp-servers.sh
# This script runs once to install LSP servers
# Note: Languages are managed by mise, not Homebrew

set -e

echo "🔍 Installing LSP servers..."

# Ensure mise tools are installed first
if command -v mise &> /dev/null; then
    echo "  Ensuring mise tools are installed..."
    mise install
fi

# Go
if command -v go &> /dev/null; then
    if ! command -v gopls &> /dev/null; then
        echo "  Installing gopls (Go LSP)..."
        go install golang.org/x/tools/gopls@latest
    else
        echo "  ✅ gopls already installed"
    fi
else
    echo "  ⚠️  Go not found - install via mise"
fi

# Rust
if command -v cargo &> /dev/null; then
    if ! command -v rust-analyzer &> /dev/null; then
        echo "  Installing rust-analyzer..."
        # mise installs rust-analyzer automatically with rust
        # But if needed, can install via: cargo install rust-analyzer
        mise exec -- rustup component add rust-analyzer 2>/dev/null || true
    else
        echo "  ✅ rust-analyzer already installed"
    fi
else
    echo "  ⚠️  Rust not found - install via mise"
fi

# TypeScript/JavaScript
if command -v npm &> /dev/null; then
    if ! command -v typescript-language-server &> /dev/null; then
        echo "  Installing typescript-language-server..."
        npm install -g typescript typescript-language-server
    else
        echo "  ✅ typescript-language-server already installed"
    fi

    # HTML/CSS
    if ! command -v vscode-html-language-server &> /dev/null; then
        echo "  Installing vscode-langservers-extracted (HTML/CSS)..."
        npm install -g vscode-langservers-extracted
    else
        echo "  ✅ vscode-langservers-extracted already installed"
    fi
fi

# C/C++ (clangd should come with Xcode Command Line Tools)
if command -v clangd &> /dev/null; then
    echo "  ✅ clangd already installed"
else
    echo "  ⚠️  clangd not found - install Xcode Command Line Tools: xcode-select --install"
fi

# Lua
if command -v brew &> /dev/null; then
    if ! command -v lua-language-server &> /dev/null; then
        echo "  Installing lua-language-server..."
        brew install lua-language-server
    else
        echo "  ✅ lua-language-server already installed"
    fi
fi

# Swift (sourcekit-lsp comes with Xcode)
if command -v sourcekit-lsp &> /dev/null; then
    echo "  ✅ sourcekit-lsp already installed"
fi

echo "✅ LSP servers installed!"