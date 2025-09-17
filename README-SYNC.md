# Upstream Sync Scripts

This repository contains scripts to help you keep your fork synchronized with the upstream Open WebUI repository.

## Scripts

### 1. `sync-upstream.sh` - Interactive Sync Script

The main script that provides interactive options for syncing with upstream:

```bash
./sync-upstream.sh
```

**Features:**
- Automatically adds/updates upstream remote
- Fetches all branches and tags from upstream
- Shows available branches and latest tags
- Provides interactive options:
  1. Merge upstream/main into current branch
  2. Reset current branch to match upstream/main
  3. Create new branch from upstream/main
  4. Show differences between branches
  5. Exit without changes
- Handles uncommitted changes safely
- Colored output for better readability

### 2. `quick-sync.sh` - Non-Interactive Fetch

A simple script for quick upstream fetching without user interaction:

```bash
./quick-sync.sh
```

**Features:**
- Adds upstream remote if it doesn't exist
- Fetches latest changes and tags from upstream
- No interactive prompts - safe for automation
- Shows helpful commands to check for updates

## Usage Examples

### First Time Setup
```bash
# Run the interactive script to set up upstream and sync
./sync-upstream.sh
```

### Regular Updates
```bash
# Quick fetch to see if there are updates
./quick-sync.sh

# Check for new changes
git log --oneline HEAD..upstream/main

# If you want to merge updates
./sync-upstream.sh
```

### Automation
You can add `quick-sync.sh` to your development workflow or CI/CD pipeline to regularly check for upstream updates.

## Important Notes

- Always commit or stash your local changes before running the sync scripts
- The reset option in `sync-upstream.sh` will permanently delete local changes
- Tags are automatically fetched with both scripts
- The upstream remote points to: `git@github.com:open-webui/open-webui.git`

## Troubleshooting

If you encounter SSH key issues, make sure you have proper access to GitHub or switch to HTTPS:
```bash
git remote set-url upstream https://github.com/open-webui/open-webui.git
```
