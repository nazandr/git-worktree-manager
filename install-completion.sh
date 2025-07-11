#!/bin/bash

# Install zsh completion for Git Worktree Manager

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Git Worktree Manager - Zsh Completion Installer${NC}"
echo "================================================="
echo

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPLETION_FILE="$SCRIPT_DIR/_gwt"

if [[ ! -f "$COMPLETION_FILE" ]]; then
    echo "Error: Completion file not found at $COMPLETION_FILE"
    exit 1
fi

# Check if zsh is available
if ! command -v zsh >/dev/null 2>&1; then
    echo "Error: zsh is not installed"
    exit 1
fi

# Find appropriate completion directory
COMPLETION_DIRS=(
    "/usr/local/share/zsh/site-functions"
    "/opt/homebrew/share/zsh/site-functions"
    "$HOME/.zsh/completions"
    "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
)

CHOSEN_DIR=""
for dir in "${COMPLETION_DIRS[@]}"; do
    if [[ -d "$(dirname "$dir")" ]]; then
        if [[ ! -d "$dir" ]]; then
            echo "Creating completion directory: $dir"
            mkdir -p "$dir"
        fi
        CHOSEN_DIR="$dir"
        break
    fi
done

if [[ -z "$CHOSEN_DIR" ]]; then
    echo "Creating user completion directory..."
    CHOSEN_DIR="$HOME/.zsh/completions"
    mkdir -p "$CHOSEN_DIR"
fi

# Copy completion file
echo "Installing completion to: $CHOSEN_DIR"
cp "$COMPLETION_FILE" "$CHOSEN_DIR/"

echo -e "${GREEN}✓${NC} Completion file installed"

# Check if directory is in fpath
FPATH_CHECK=$(zsh -c "echo \$fpath" 2>/dev/null | grep -q "$CHOSEN_DIR" && echo "yes" || echo "no")

if [[ "$FPATH_CHECK" == "no" ]]; then
    echo
    echo -e "${YELLOW}⚠${NC}  The completion directory is not in your fpath."
    echo "Add this line to your ~/.zshrc:"
    echo
    echo "    fpath=($CHOSEN_DIR \$fpath)"
    echo
    echo "Then reload your shell or run: source ~/.zshrc"
fi

echo
echo -e "${GREEN}Installation complete!${NC}"
echo
echo "To test the completion:"
echo "1. Start a new shell session or run: source ~/.zshrc"
echo "2. Type: gwt <TAB>"
echo "3. Try: gwt create <TAB>"
echo "4. Try: gwt switch <TAB>"
echo
echo "Note: Completion works best when you're inside a git repository."