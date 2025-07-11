# Contributing to Git Worktree Manager

Thank you for your interest in contributing to Git Worktree Manager! We welcome contributions from the community and are pleased to have you join us.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## 📜 Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful, inclusive, and constructive in all interactions.

## 🚀 Getting Started

### Prerequisites

- Git 2.5+ with worktree support
- Bash 4.0+ or compatible shell
- VS Code (for testing integration features)
- Basic familiarity with shell scripting

### Development Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/your-username/git-worktree-manager.git
   cd git-worktree-manager
   ```

2. **Make the script executable**
   ```bash
   chmod +x git-worktree-manager.sh
   ```

3. **Test the basic functionality**
   ```bash
   ./git-worktree-manager.sh help
   ```

4. **Install completion for testing** (optional)
   ```bash
   ./install-completion.sh
   ```

## 🛠️ How to Contribute

### Bug Reports

When filing a bug report, please include:

- **Environment details**: OS, shell version, Git version
- **Steps to reproduce**: Clear, numbered steps
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Error messages**: Full error output if applicable

### Feature Requests

For feature requests, please provide:

- **Use case**: Why is this feature needed?
- **Proposed solution**: How should it work?
- **Alternatives considered**: Other approaches you've thought about
- **Additional context**: Screenshots, examples, etc.

### Code Contributions

1. **Check existing issues** to avoid duplicate work
2. **Create an issue** to discuss major changes before implementation
3. **Fork the repository** and create a feature branch
4. **Make your changes** following our coding standards
5. **Test thoroughly** on your local setup
6. **Submit a pull request** with a clear description

## 🔧 Coding Standards

### Shell Script Guidelines

- **Use bash-specific features** when they improve readability
- **Follow naming conventions**:
  - Functions: `snake_case`
  - Variables: `snake_case` 
  - Constants: `UPPER_CASE`
- **Add comments** for complex logic
- **Use meaningful variable names**
- **Handle errors gracefully** with proper exit codes

### Code Style

```bash
# Good: Clear function with error handling
create_worktree() {
    local branch_name="$1"
    local worktree_type="${2:-feature}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Branch name is required"
        return 1
    fi
    
    # Implementation...
}

# Good: Clear variable names and error checking
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_error "Not in a git repository"
    exit 1
fi
```

### Documentation

- **Update README.md** for user-facing changes
- **Update help text** in the script for new commands
- **Add inline comments** for complex algorithms
- **Update CHANGELOG.md** for all changes

## 🧪 Testing

### Manual Testing

Test your changes across different scenarios:

```bash
# Test in a real git repository
cd /path/to/test-repo

# Test basic functionality
./git-worktree-manager.sh create test/branch
./git-worktree-manager.sh list
./git-worktree-manager.sh switch test-repo-test-branch
./git-worktree-manager.sh remove test-repo-test-branch

# Test edge cases
./git-worktree-manager.sh create "feature/with spaces"
./git-worktree-manager.sh create "feature/with/slashes"

# Test error conditions
./git-worktree-manager.sh create  # No branch name
./git-worktree-manager.sh switch nonexistent  # Invalid worktree
```

### Testing Checklist

- [ ] Commands work in different git repositories
- [ ] Branch names with special characters are handled
- [ ] Error messages are clear and helpful
- [ ] VS Code integration works properly
- [ ] Zsh completion functions correctly
- [ ] Configuration changes are respected

## 📤 Submitting Changes

### Pull Request Process

1. **Create a descriptive branch name**
   ```bash
   git checkout -b feature/add-remote-branch-support
   git checkout -b fix/handle-spaces-in-paths
   git checkout -b docs/improve-installation-guide
   ```

2. **Make commits with clear messages**
   ```bash
   git commit -m "feat: add support for remote branch creation"
   git commit -m "fix: handle branch names with spaces correctly"
   git commit -m "docs: add troubleshooting section to README"
   ```

3. **Push your branch and create a PR**
   ```bash
   git push origin feature/your-feature-name
   ```

### Pull Request Template

When creating a PR, please include:

- **Summary**: Brief description of changes
- **Motivation**: Why is this change needed?
- **Changes**: List of what was modified
- **Testing**: How you tested the changes
- **Screenshots**: If applicable, especially for UI changes

### Review Process

- PRs require at least one review from a maintainer
- All tests must pass (when CI is implemented)
- Documentation must be updated for user-facing changes
- Code must follow the established style guidelines

## 🏷️ Release Process

Releases follow semantic versioning:

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## 🤝 Community

- **Be respectful** of different skill levels and backgrounds
- **Ask questions** if anything is unclear
- **Help others** by reviewing PRs and answering issues
- **Share feedback** about your experience using the tool

## 📞 Getting Help

If you need help contributing:

1. **Check existing issues** for similar questions
2. **Create a new issue** with the "question" label
3. **Be specific** about what you're trying to achieve
4. **Include context** about your environment and setup

Thank you for contributing to Git Worktree Manager! 🎉