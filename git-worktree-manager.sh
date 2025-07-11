#!/bin/bash

# Git Worktree Manager
# A script to create, manage, and open Git worktrees in VS Code

set -e

# Configuration
WORKTREE_DIR="../worktrees"
VSCODE_WORKSPACE_DIR=".vscode/worktrees"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        exit 1
    fi
}

# Get the repository root directory
get_repo_root() {
    git rev-parse --show-toplevel
}

# Sanitize branch name for use in file paths
sanitize_branch_name() {
    echo "$1" | sed 's/\//-/g' | sed 's/[^a-zA-Z0-9._-]/-/g'
}

# Create worktree directory if it doesn't exist
ensure_worktree_dir() {
    local repo_root=$(get_repo_root)
    local worktree_path="$repo_root/$WORKTREE_DIR"
    
    if [[ ! -d "$worktree_path" ]]; then
        mkdir -p "$worktree_path"
        log_info "Created worktree directory: $worktree_path"
    fi
}

# Create VS Code workspace directory if it doesn't exist
ensure_vscode_workspace_dir() {
    local repo_root=$(get_repo_root)
    local workspace_path="$repo_root/$VSCODE_WORKSPACE_DIR"
    
    if [[ ! -d "$workspace_path" ]]; then
        mkdir -p "$workspace_path"
        log_info "Created VS Code workspace directory: $workspace_path"
    fi
}

# Create a new worktree
create_worktree() {
    local branch_name="$1"
    local worktree_type="${2:-feature}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Branch name is required"
        echo "Usage: $0 create <branch-name> [--feature|--hotfix|--experiment]"
        exit 1
    fi
    
    local repo_root=$(get_repo_root)
    local repo_name=$(basename "$repo_root")
    local sanitized_branch=$(sanitize_branch_name "$branch_name")
    local worktree_name="${repo_name}-${sanitized_branch}"
    local worktree_path="$repo_root/$WORKTREE_DIR/$worktree_name"
    
    ensure_worktree_dir
    ensure_vscode_workspace_dir
    
    # Check if worktree already exists
    if [[ -d "$worktree_path" ]]; then
        log_warning "Worktree already exists: $worktree_path"
        log_info "Opening existing worktree in VS Code..."
        open_in_vscode "$worktree_name"
        return
    fi
    
    # Check if branch exists locally
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        log_info "Creating worktree for existing branch: $branch_name"
        git worktree add "$worktree_path" "$branch_name"
    else
        # Check if branch exists on remote
        if git ls-remote --heads origin "$branch_name" | grep -q "$branch_name"; then
            log_info "Creating worktree for remote branch: $branch_name"
            git worktree add "$worktree_path" -b "$branch_name" "origin/$branch_name"
        else
            log_info "Creating worktree with new branch: $branch_name"
            git worktree add "$worktree_path" -b "$branch_name"
        fi
    fi
    
    # Create VS Code workspace file
    create_vscode_workspace "$worktree_name" "$worktree_path"
    
    log_success "Worktree created: $worktree_path"
    
    # Open in VS Code
    open_in_vscode "$worktree_name"
}

# Create VS Code workspace file
create_vscode_workspace() {
    local worktree_name="$1"
    local worktree_path="$2"
    local repo_root=$(get_repo_root)
    local workspace_file="$repo_root/$VSCODE_WORKSPACE_DIR/${worktree_name}.code-workspace"
    
    cat > "$workspace_file" << EOF
{
    "folders": [
        {
            "name": "$worktree_name",
            "path": "$worktree_path"
        }
    ],
    "settings": {
        "git.openRepositoryInParentFolders": "never"
    },
    "extensions": {
        "recommendations": []
    }
}
EOF
    
    log_info "Created VS Code workspace: $workspace_file"
}

# Open worktree in VS Code
open_in_vscode() {
    local worktree_name="$1"
    local repo_root=$(get_repo_root)
    local workspace_file="$repo_root/$VSCODE_WORKSPACE_DIR/${worktree_name}.code-workspace"
    
    if [[ -f "$workspace_file" ]]; then
        log_info "Opening $worktree_name in VS Code..."
        code "$workspace_file"
    else
        log_error "Workspace file not found: $workspace_file"
        exit 1
    fi
}

# List all worktrees
list_worktrees() {
    local repo_root=$(get_repo_root)
    local worktree_base="$repo_root/$WORKTREE_DIR"
    
    echo "Git Worktrees:"
    echo "=============="
    
    git worktree list --porcelain | while IFS= read -r line; do
        if [[ $line == worktree* ]]; then
            local path=${line#worktree }
            local name=$(basename "$path")
            
            # Skip the main repository
            if [[ "$path" == "$repo_root" ]]; then
                echo "📁 main ($(basename "$repo_root")) - $path"
            else
                echo "🌿 $name - $path"
            fi
        elif [[ $line == branch* ]]; then
            local branch=${line#branch refs/heads/}
            echo "   └── Branch: $branch"
        fi
    done
}

# Switch to a worktree (open in VS Code)
switch_worktree() {
    local worktree_name="$1"
    
    if [[ -z "$worktree_name" ]]; then
        log_error "Worktree name is required"
        echo "Usage: $0 switch <worktree-name>"
        echo ""
        echo "Available worktrees:"
        list_worktrees
        exit 1
    fi
    
    open_in_vscode "$worktree_name"
}

# Clean up merged worktrees
cleanup_worktrees() {
    local repo_root=$(get_repo_root)
    local worktree_base="$repo_root/$WORKTREE_DIR"
    
    log_info "Cleaning up merged worktrees..."
    
    # Get list of branches that have been merged into main
    # This uses a more conservative approach - only branches that have been explicitly merged
    local merged_branches=""
    
    # For now, skip automatic detection and go straight to manual selection
    # Automatic merge detection is complex and can give false positives
    
    log_info "No automatically detectable merged branches found."
    echo ""
    echo "Available worktree branches:"
    git branch | grep -v "main" | grep -v "master" | sed 's/^[* ] /  - /'
    echo ""
    read -p "Would you like to manually select branches to clean up? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Enter branch names to clean up (one per line, empty line to finish):"
        local manual_branches=""
        while true; do
            read -p "> " branch_input
            if [[ -z "$branch_input" ]]; then
                break
            fi
            
            # Validate branch exists
            if git show-ref --verify --quiet "refs/heads/$branch_input"; then
                if [[ -z "$manual_branches" ]]; then
                    manual_branches="$branch_input"
                else
                    manual_branches="$manual_branches"$'\n'"$branch_input"
                fi
            else
                log_warning "Branch '$branch_input' not found, skipping"
            fi
        done
        merged_branches="$manual_branches"
    fi
    
    if [[ -z "$merged_branches" ]]; then
        log_info "No branches selected for cleanup"
        return
    fi
    
    echo "Branches selected for cleanup:"
    echo "$merged_branches"
    echo ""
    
    read -p "Do you want to remove these worktrees? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while IFS= read -r branch; do
            if [[ -n "$branch" ]]; then
                local repo_name=$(basename "$repo_root")
                local sanitized_branch=$(sanitize_branch_name "$branch")
                local worktree_name="${repo_name}-${sanitized_branch}"
                local worktree_path="$worktree_base/$worktree_name"
                local workspace_file="$repo_root/$VSCODE_WORKSPACE_DIR/${worktree_name}.code-workspace"
                
                if [[ -d "$worktree_path" ]]; then
                    log_info "Removing worktree: $worktree_name"
                    git worktree remove "$worktree_path" --force
                    
                    # Remove workspace file
                    if [[ -f "$workspace_file" ]]; then
                        rm "$workspace_file"
                        log_info "Removed workspace file: ${worktree_name}.code-workspace"
                    fi
                    
                    log_success "Cleaned up: $worktree_name"
                fi
            fi
        done <<< "$merged_branches"
    else
        log_info "Cleanup cancelled"
    fi
}

# Force remove a specific worktree
force_remove_worktree() {
    local worktree_name="$1"
    
    if [[ -z "$worktree_name" ]]; then
        log_error "Worktree name is required"
        echo "Usage: $0 remove <worktree-name>"
        echo ""
        echo "Available worktrees:"
        list_worktrees
        exit 1
    fi
    
    local repo_root=$(get_repo_root)
    local worktree_base="$repo_root/$WORKTREE_DIR"
    local worktree_path="$worktree_base/$worktree_name"
    local workspace_file="$repo_root/$VSCODE_WORKSPACE_DIR/${worktree_name}.code-workspace"
    
    # Check if worktree exists
    if [[ ! -d "$worktree_path" ]]; then
        log_error "Worktree not found: $worktree_path"
        echo ""
        echo "Available worktrees:"
        list_worktrees
        exit 1
    fi
    
    # Extract branch name from worktree name (remove repo prefix)
    local repo_name=$(basename "$repo_root")
    local branch_name=${worktree_name#"$repo_name-"}
    # Convert sanitized name back to original (replace first dash with slash if it looks like feature-name pattern)
    if [[ "$branch_name" =~ ^(feature|hotfix|bugfix|release)-(.+)$ ]]; then
        branch_name="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
    fi
    
    log_warning "This will force remove the worktree and optionally delete the branch"
    echo "Worktree: $worktree_path"
    echo "Branch: $branch_name"
    echo ""
    
    read -p "Are you sure you want to remove this worktree? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Removal cancelled"
        return
    fi
    
    # Remove the worktree
    log_info "Removing worktree: $worktree_name"
    if git worktree remove "$worktree_path" --force; then
        log_success "Worktree removed successfully"
    else
        log_error "Failed to remove worktree, trying manual cleanup..."
        rm -rf "$worktree_path"
        git worktree prune
        log_info "Manual cleanup completed"
    fi
    
    # Remove workspace file
    if [[ -f "$workspace_file" ]]; then
        rm "$workspace_file"
        log_info "Removed workspace file: ${worktree_name}.code-workspace"
    fi
    
    # Ask about branch deletion
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo ""
        read -p "Do you want to delete the branch '$branch_name' as well? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git branch -D "$branch_name"
            log_success "Branch '$branch_name' deleted"
        fi
    fi
    
    log_success "Cleanup completed for: $worktree_name"
}

# Show status of worktrees
show_status() {
    local repo_root=$(get_repo_root)
    
    echo "Repository: $(basename "$repo_root")"
    echo "Worktree Directory: $repo_root/$WORKTREE_DIR"
    echo "VS Code Workspaces: $repo_root/$VSCODE_WORKSPACE_DIR"
    echo ""
    
    list_worktrees
    
    echo ""
    echo "Disk Usage:"
    if [[ -d "$repo_root/$WORKTREE_DIR" ]]; then
        du -sh "$repo_root/$WORKTREE_DIR" 2>/dev/null || echo "Unable to calculate disk usage"
    else
        echo "No worktrees directory found"
    fi
}

# Main command handling
main() {
    check_git_repo
    
    case "${1:-help}" in
        "create")
            shift
            local branch_name="$1"
            local worktree_type=""
            
            # Parse additional arguments
            shift || true
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --feature)
                        worktree_type="feature"
                        shift
                        ;;
                    --hotfix)
                        worktree_type="hotfix"
                        shift
                        ;;
                    --experiment)
                        worktree_type="experiment"
                        shift
                        ;;
                    *)
                        log_warning "Unknown option: $1"
                        shift
                        ;;
                esac
            done
            
            create_worktree "$branch_name" "$worktree_type"
            ;;
        "list")
            list_worktrees
            ;;
        "switch")
            switch_worktree "$2"
            ;;
        "cleanup")
            cleanup_worktrees
            ;;
        "remove"|"rm")
            force_remove_worktree "$2"
            ;;
        "status")
            show_status
            ;;
        "help"|*)
            echo "Git Worktree Manager"
            echo "==================="
            echo ""
            echo "Usage: $0 <command> [options]"
            echo ""
            echo "Commands:"
            echo "  create <branch-name> [--feature|--hotfix|--experiment]  Create a new worktree and open in VS Code"
            echo "  list                                                     List all worktrees"
            echo "  switch <worktree-name>                                   Switch to a worktree (open in VS Code)"
            echo "  remove <worktree-name>                                   Force remove a specific worktree"
            echo "  cleanup                                                  Remove merged worktrees (interactive)"
            echo "  status                                                   Show worktree status and disk usage"
            echo "  help                                                     Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 create feature/new-login"
            echo "  $0 create hotfix/critical-bug --hotfix"
            echo "  $0 list"
            echo "  $0 switch myproject-feature-new-login"
            echo "  $0 remove myproject-feature-old"
            echo "  $0 cleanup"
            echo "  $0 status"
            ;;
    esac
}

# Run the main function with all arguments
main "$@"