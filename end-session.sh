#!/bin/bash

# Get the current branch name
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Find the origin branch of the current branch
PARENT_BRANCH=$(git for-each-ref --format='%(upstream:short)' refs/heads/"$CURRENT_BRANCH")

if [ -z "$PARENT_BRANCH" ]; then
  echo "Could not determine the parent branch. Please specify it manually:"
  git branch
  read -p "Enter the name of the parent branch: " PARENT_BRANCH
fi

# List all commit messages since the current branch diverged from its parent branch
echo "Commits made during this session:"
git log "$PARENT_BRANCH".."$CURRENT_BRANCH" --pretty=format:"* %s"

# Prompt the user to summarize the work done in the session
read -p "Please summarize the work done in this session: " SUMMARY

# Append all previous commit messages to the new summary commit message with a header of "AI Changes"
COMMIT_MESSAGES=$(git log "$PARENT_BRANCH".."$CURRENT_BRANCH" --pretty=format:"* %s")
SUMMARY_COMMIT_MESSAGE="$SUMMARY

AI Changes:
$COMMIT_MESSAGES"

# Squash all commits since the branch started into the summary commit message
git reset --soft "$PARENT_BRANCH"
git add .
git commit -m "$SUMMARY_COMMIT_MESSAGE"

# Push the branch to remote
git push origin "$CURRENT_BRANCH"
