#!/bin/bash

# Quick sync script - fetches latest from upstream without interactive prompts
# Use this for automated or quick updates

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}[INFO]${NC} Quick sync with upstream..."

# Ensure upstream remote exists
if ! git remote | grep -q "^upstream$"; then
    echo -e "${BLUE}[INFO]${NC} Adding upstream remote..."
    git remote add upstream git@github.com:open-webui/open-webui.git
fi

# Fetch from upstream
echo -e "${BLUE}[INFO]${NC} Fetching from upstream..."
git fetch upstream --tags --prune

echo -e "${GREEN}[SUCCESS]${NC} Upstream sync completed!"
echo -e "${BLUE}[INFO]${NC} Use 'git log --oneline HEAD..upstream/main' to see new changes"
echo -e "${BLUE}[INFO]${NC} Use './sync-upstream.sh' for interactive merge/reset options"
