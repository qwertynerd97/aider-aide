#!/bin/bash

# Script to set up a new project
# Usage: ./setup_new_project.sh <project_name>

# Check if the project name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR=~/Documents/$PROJECT_NAME
TEMPLATE_DIR=$(dirname "$(realpath "$0")")/create-project.templates

# Create project directory
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# Initialize git repository
git init

# Create initial files from template
cp $TEMPLATE_DIR/README.md.template README.md
sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" README.md

cp $TEMPLATE_DIR/LICENSE.template LICENSE

mkdir -p planning
cp $TEMPLATE_DIR/planning/tasks.md.template planning/tasks.md

cp $TEMPLATE_DIR/.gitignore.template .gitignore

# Prompt to create GitHub repository and get remote URL
echo "Please go to https://github.com/new and create a new repository named $PROJECT_NAME."
echo "Once the repository is created, copy the remote URL (e.g., https://github.com/yourusername/$PROJECT_NAME.git)."
read -p "Enter the remote URL: " REMOTE_URL

# Check if the GitHub repository contains commits
if git ls-remote --heads $REMOTE_URL main &>/dev/null; then
  echo "The GitHub repository already contains commits. Are you sure you want to overwrite it? (y/n)"
  read -r CONFIRM
  if [ "$CONFIRM" != "y" ]; then
    echo "Operation cancelled."
    exit 1
  fi
fi

# Add remote URL to local repository
git remote add origin $REMOTE_URL

# Make an initial commit with force flag for git add
git add -f .
git commit -m "Initial commit"

# Push changes to GitHub with main branch set as "main"
git push -u --force origin main

echo "Project setup complete for $PROJECT_NAME. Repository has been pushed to GitHub."

# Open README.md file in the default text editor
cd $PROJECT_DIR
vim README.md
