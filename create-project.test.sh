#!/bin/bash

# Test script for create-project.sh
# This script checks if the test directory exists,
# deletes it and all its files if it does,
# then runs the create-project.sh script with a project called test-givehub-repo-command

TEST_DIR=~/Documents/test-givehub-repo-command

# Check if the test directory exists
if [ -d "$TEST_DIR" ]; then
  echo "Test directory $TEST_DIR already exists. Deleting it..."
  rm -rf "$TEST_DIR"
fi

# Run create-project.sh with a project called test-givehub-repo-command
./create-project.sh test-givehub-repo-command

echo "Test script completed."
