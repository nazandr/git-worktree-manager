# Changelog

All notable changes to Git Worktree Manager will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of Git Worktree Manager
- Core worktree management functionality
- VS Code workspace integration
- Zsh autocompletion support
- Interactive cleanup system
- Comprehensive configuration options

## [1.0.0] - 2024-XX-XX

### Added
- **Core Features**
  - Create worktrees with automatic VS Code workspace generation
  - List all worktrees with status information
  - Switch between worktrees seamlessly
  - Force remove specific worktrees with confirmation
  - Interactive cleanup of merged/stale worktrees
  - Real-time status monitoring with disk usage

- **VS Code Integration**
  - Automatic workspace file creation
  - Instant VS Code opening for new worktrees
  - Configurable workspace settings
  - Extension recommendations support

- **User Experience**
  - Color-coded terminal output
  - Intuitive command structure
  - Comprehensive help system
  - Safe operation with confirmation prompts
  - Branch name sanitization for file paths

- **Zsh Autocompletion**
  - Complete command name completion
  - Dynamic worktree name completion for switch/remove
  - Branch name completion for create command
  - Flag completion for command options
  - Intelligent completion based on git repository state

- **Configuration System**
  - JSON-based configuration file
  - Customizable worktree directory location
  - Configurable VS Code settings and extensions
  - Adjustable cleanup behavior
  - Display preference options

- **Developer Tools**
  - Comprehensive installation script
  - Cross-platform compatibility (macOS, Linux, Windows WSL)
  - Robust error handling and fallback mechanisms
  - Extensive documentation and examples

### Technical Details
- Written in Bash for maximum compatibility
- Supports Git 2.5+ with worktree functionality
- Requires VS Code with `code` command in PATH
- Optional zsh for enhanced autocompletion
- MIT License for open-source flexibility

### File Structure
```
git-worktree-manager/
├── git-worktree-manager.sh    # Main script
├── _gwt                       # Zsh completion
├── install-completion.sh      # Completion installer
├── config.json               # Configuration file
├── README.md                 # Documentation
├── LICENSE                   # MIT License
└── CHANGELOG.md             # This file
```