# Git Worktree Manager

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell: Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Completion: Zsh](https://img.shields.io/badge/Completion-Zsh-blue.svg)](https://www.zsh.org/)

A powerful, user-friendly script to create, manage, and work with Git worktrees, featuring seamless VS Code integration and intelligent workflow automation.

## 🚀 Features

- ✅ **Smart Worktree Creation** - Automatic VS Code workspace generation
- ✅ **Seamless Navigation** - List and switch between worktrees effortlessly  
- ✅ **Intelligent Cleanup** - Interactive removal of stale worktrees
- ✅ **Status Monitoring** - Real-time disk usage and worktree health
- ✅ **Rich Configuration** - Customizable settings via JSON
- ✅ **Beautiful UX** - Color-coded output and intuitive commands
- ✅ **Zsh Autocompletion** - Tab completion for all commands and arguments
- ✅ **Cross-Platform** - Works on macOS, Linux, and Windows (WSL)

## 📦 Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/nazandr/git-worktree-manager.git
cd git-worktree-manager

# Make executable
chmod +x git-worktree-manager.sh

# Create alias (add to your ~/.bashrc or ~/.zshrc)
alias gwt="$(pwd)/git-worktree-manager.sh"

# Install zsh completion (optional but recommended)
./install-completion.sh
```

### Manual Installation

1. **Download the script**
   ```bash
   curl -O https://raw.githubusercontent.com/nazandr/git-worktree-manager/main/git-worktree-manager.sh
   chmod +x git-worktree-manager.sh
   ```

2. **Create an alias** (optional)
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   alias gwt="/path/to/git-worktree-manager.sh"
   ```

3. **Install completion** (for zsh users)
   ```bash
   # Download completion file
   curl -O https://raw.githubusercontent.com/nazandr/git-worktree-manager/main/_gwt
   
   # Copy to completion directory
   cp _gwt /usr/local/share/zsh/site-functions/
   
   # Add to ~/.zshrc if not already present
   fpath=(/usr/local/share/zsh/site-functions $fpath)
   ```

### 🎯 Zsh Autocompletion

The completion system provides intelligent tab completion:

| Command | Completion |
|---------|------------|
| `gwt <TAB>` | All available commands |
| `gwt create <TAB>` | Branch names and common prefixes |
| `gwt switch <TAB>` | Existing worktree names |
| `gwt remove <TAB>` | Existing worktree names |
| `gwt create branch --<TAB>` | Flag options (`--feature`, `--hotfix`, `--experiment`) |

## 🛠️ Usage

### Basic Commands

```bash
# Create a new worktree and open in VS Code
gwt create feature/user-authentication

# Create with type specification  
gwt create hotfix/critical-security-fix --hotfix

# List all worktrees with status
gwt list

# Switch to an existing worktree
gwt switch myproject-feature-auth

# Force remove a specific worktree
gwt remove myproject-old-feature

# Interactive cleanup of stale worktrees
gwt cleanup

# Show comprehensive status
gwt status
```

### 🎬 Workflow Examples

<details>
<summary><strong>Feature Development Workflow</strong></summary>

```bash
# Start new feature
gwt create feature/payment-integration --feature
# ✅ Creates worktree at ../worktrees/myproject-feature-payment-integration
# ✅ Opens VS Code with dedicated workspace
# ✅ You're now working in isolated environment

# Work on your feature...
git add . && git commit -m "Add payment gateway integration"

# Switch back to main for quick hotfix
gwt switch myproject-main

# Switch back to continue feature work  
gwt switch myproject-feature-payment-integration

# When feature is complete and merged
gwt cleanup
# ✅ Interactively removes merged worktrees
```

</details>

<details>
<summary><strong>Hotfix Workflow</strong></summary>

```bash
# Urgent production fix needed
gwt create hotfix/security-patch --hotfix
# ✅ Immediately isolated environment for critical fix

# Apply fix and test
git add . && git commit -m "Fix security vulnerability"

# Deploy fix, then cleanup
gwt remove myproject-hotfix-security-patch
# ✅ Clean removal with branch deletion option
```

</details>

<details>
<summary><strong>Experimentation Workflow</strong></summary>

```bash
# Try out new approach
gwt create experiment/new-architecture --experiment

# Experiment freely...
# If experiment succeeds, merge it
# If not, simply remove it
gwt remove myproject-experiment-new-architecture
# ✅ No impact on main codebase
```

</details>

## ⚙️ Configuration

The tool comes with a flexible configuration system via `config.json`:

```json
{
  "worktree": {
    "directory": "../worktrees",
    "naming": {
      "pattern": "{repo}-{branch}",
      "sanitize": true
    }
  },
  "vscode": {
    "workspace_directory": ".vscode/worktrees",
    "auto_open": true,
    "settings": {
      "git.openRepositoryInParentFolders": "never"
    }
  },
  "cleanup": {
    "auto_remove_merged": false,
    "confirm_before_delete": true
  }
}
```

### Customization Options

| Setting | Description | Default |
|---------|-------------|---------|
| `worktree.directory` | Where to create worktrees | `../worktrees` |
| `vscode.auto_open` | Auto-open in VS Code | `true` |
| `cleanup.confirm_before_delete` | Require confirmation | `true` |

## 📁 Directory Structure

```
your-repo/
├── .vscode/
│   └── worktrees/                    # VS Code workspace files
│       ├── myrepo-feature-auth.code-workspace
│       └── myrepo-hotfix-bug.code-workspace
└── worktrees/                        # Actual worktree directories
    ├── myrepo-feature-auth/          # Feature worktree
    └── myrepo-hotfix-bug/            # Hotfix worktree
```

## 🧰 Requirements

- **Git** 2.5+ with worktree support
- **VS Code** with `code` command in PATH
- **Bash** 4.0+ or compatible shell
- **Zsh** (optional, for autocompletion)

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Start for Contributors

```bash
git clone https://github.com/nazandr/git-worktree-manager.git
cd git-worktree-manager
./git-worktree-manager.sh help
```

## 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by Git's powerful worktree functionality
- Built for developers who love VS Code integration
- Community feedback and contributions welcome