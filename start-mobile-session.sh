#!/bin/bash

# Get the current branch name
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Check if the current branch is a feature branch
if [[ "$CURRENT_BRANCH" != feature-* ]]; then
  # List all branches that start with "feature-"
  FEATURE_BRANCHES=$(git branch | grep '^  feature-' | sed 's/^  //')

  # Check if there are any feature branches
  if [ -z "$FEATURE_BRANCHES" ]; then
    echo "No feature branches found. Please start a new feature first."
    exit 1
  fi

  echo "Current branch is not a feature branch. Please select a feature branch:"
  echo "$FEATURE_BRANCHES"

  # Prompt the user to select a feature branch
  read -p "Enter the name of the feature branch: " FEATURE_BRANCH

  # Check if the entered branch exists
  if ! git show-ref --verify --quiet refs/heads/"$FEATURE_BRANCH"; then
    echo "Branch '$FEATURE_BRANCH' does not exist."
    exit 1
  fi
else
  FEATURE_BRANCH=$CURRENT_BRANCH
fi

SESSION_BRANCH="session-$(date +'%Y-%m-%d_%H-%M')"

# Create a new temporary branch from the feature branch
git checkout -b "$SESSION_BRANCH" "$FEATURE_BRANCH"
echo "Created and switched to new branch: $SESSION_BRANCH"

# Set OLLAMA API BASE variable for aider using HOSTNAME variable
export OLLAMA_API_BASE=http://$HOSTNAME:11434

# Open aider in mobile notification mode using devstral AI
aider --model ollama_chat/devstral:latest --notifications

# Add planning/tasks.md to aider and have it tell you the open tasks
aider add planning/tasks.md
aider ask "What are the open tasks?"
