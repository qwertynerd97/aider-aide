#!/bin/bash

# Check if the current branch contains "feature" or "session"
current_branch=$(git symbolic-ref --short HEAD)
if [[ $current_branch == feature* || $current_branch == session* ]]; then
  echo "You are currently on a feature or session branch. Please switch to the main branch before creating a new feature."
  exit 1
fi

# Prompt the user for a feature name
read -p "Enter the feature name: " feature_name

# Create a new branch with the format feature-featureName and switch to it
new_branch="feature-$feature_name"
git checkout -b "$new_branch"

# Create the feature description file with a short prompt in vim
mkdir -p planning
echo "# $feature_name" > "planning/$feature_name.spec.md"
echo "" >> "planning/$feature_name.spec.md"
echo "Please describe how this feature works:" >> "planning/$feature_name.spec.md"
vim "planning/$feature_name.spec.md"

# Start aider
aider --model ollama_chat/devstral:latest --notifications --load create-feature.templates/load-commands.md
