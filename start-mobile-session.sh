#!/bin/bash

# Check if feature branch is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <feature-branch>"
  exit 1
fi

FEATURE_BRANCH=$1
SESSION_BRANCH="session-$(date +'%Y-%m-%d_%H-%M')"

# Create a new temporary branch from the feature branch
git checkout -b "$SESSION_BRANCH" "$FEATURE_BRANCH"
echo "Created and switched to new branch: $SESSION_BRANCH"

# Set OLLAMA URL variable for aider (replace 'your_ollama_url' with the actual URL)
export OLLAMA_URL="your_ollama_url"

# Open aider in mobile notification mode using devstral AI
aider --mobile-notification-mode --ai devstral

# Add planning/tasks.md to aider and have it tell you the open tasks
aider add planning/tasks.md
aider ask "What are the open tasks?"
