#!/bin/bash

# Script to sync fork with upstream Open WebUI repository
# This script fetches updates from the upstream repository including tags

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository!"
    exit 1
fi

print_status "Starting upstream sync process..."

# Check if upstream remote exists
if git remote | grep -q "^upstream$"; then
    print_status "Upstream remote already exists"
else
    print_status "Adding upstream remote..."
    git remote add upstream git@github.com:open-webui/open-webui.git
    print_success "Added upstream remote"
fi

# Verify upstream remote URL
UPSTREAM_URL=$(git remote get-url upstream 2>/dev/null || echo "")
if [[ "$UPSTREAM_URL" != "git@github.com:open-webui/open-webui.git" ]]; then
    print_warning "Upstream URL is not correct. Updating..."
    git remote set-url upstream git@github.com:open-webui/open-webui.git
    print_success "Updated upstream remote URL"
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
print_status "Current branch: $CURRENT_BRANCH"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    print_warning "You have uncommitted changes. Please commit or stash them before continuing."
    git status --porcelain
    read -p "Do you want to continue anyway? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Aborting sync due to uncommitted changes"
        exit 1
    fi
fi

print_status "Fetching from upstream repository..."
# Fetch all branches and tags from upstream
git fetch upstream --tags --prune

print_success "Successfully fetched from upstream"

# Show available branches from upstream
print_status "Available upstream branches:"
git branch -r | grep upstream/ | head -10

# Show latest tags
print_status "Latest tags from upstream:"
git tag --sort=-version:refname | head -10

# Ask user what they want to do
echo
echo "What would you like to do?"
echo "1) Merge upstream/main into current branch ($CURRENT_BRANCH)"
echo "2) Reset current branch to match upstream/main (WARNING: This will lose local changes)"
echo "3) Create a new branch from upstream/main"
echo "4) Just show the differences between current branch and upstream/main"
echo "5) Exit without making changes"
echo

read -p "Please select an option [1-5]: " -n 1 -r
echo

case $REPLY in
    1)
        print_status "Merging upstream/main into $CURRENT_BRANCH..."
        if git merge upstream/main; then
            print_success "Successfully merged upstream/main into $CURRENT_BRANCH"
        else
            print_error "Merge conflicts detected. Please resolve them manually."
            exit 1
        fi
        ;;
    2)
        print_warning "This will reset your current branch to match upstream/main exactly."
        read -p "Are you sure? This will lose all local changes! [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git reset --hard upstream/main
            print_success "Reset $CURRENT_BRANCH to match upstream/main"
        else
            print_status "Reset cancelled"
        fi
        ;;
    3)
        read -p "Enter name for new branch: " BRANCH_NAME
        if [[ -n "$BRANCH_NAME" ]]; then
            git checkout -b "$BRANCH_NAME" upstream/main
            print_success "Created and switched to new branch: $BRANCH_NAME"
        else
            print_error "Invalid branch name"
        fi
        ;;
    4)
        print_status "Showing differences between $CURRENT_BRANCH and upstream/main:"
        git log --oneline --graph --decorate $CURRENT_BRANCH..upstream/main
        echo
        print_status "Summary of changes:"
        git diff --stat $CURRENT_BRANCH..upstream/main
        ;;
    5)
        print_status "Exiting without making changes"
        ;;
    *)
        print_error "Invalid option selected"
        exit 1
        ;;
esac

print_status "Sync process completed!"
print_status "Don't forget to push your changes if you made any modifications."
