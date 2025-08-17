#!/bin/bash

# Script to install all the scripts in this repository and make them available as bash commands

# Define the target installation directory
INSTALL_DIR="/usr/local/bin"
TEMPLATE_DIR=$(dirname "$(realpath "$0")")

# Create a backup of the original files if they exist
backup_files() {
  for file in "$@"; do
    if [ -f "$file" ]; then
      cp "$file" "${file}.bak"
      echo "Backed up $file to ${file}.bak"
    fi
  done
}

# Install scripts and templates
install_scripts() {
  # List of scripts to install
  SCRIPTS=("create-project.sh" "start-mobile-session.sh" "end-session.sh" "create-feature.sh")

  for script in "${SCRIPTS[@]}"; do
    if [ -f "$TEMPLATE_DIR/$script" ]; then
      cp "$TEMPLATE_DIR/$script" "$INSTALL_DIR/"
      chmod +x "$INSTALL_DIR/$script"
      echo "Installed $script to $INSTALL_DIR"
    else
      echo "Script $script not found in $TEMPLATE_DIR"
    fi
  done

  # List of template directories to install
  TEMPLATE_DIRS=("create-project.templates" "mobile-session.templates")

  for dir in "${TEMPLATE_DIRS[@]}"; do
    if [ -d "$TEMPLATE_DIR/$dir" ]; then
      cp -r "$TEMPLATE_DIR/$dir" "$INSTALL_DIR/"
      echo "Installed $dir to $INSTALL_DIR"
    else
      echo "Template directory $dir not found in $TEMPLATE_DIR"
    fi
  done

  # Copy additional templates and files
  if [ -f "$TEMPLATE_DIR/create-feature.templates/load-commands.md" ]; then
    cp "$TEMPLATE_DIR/create-feature.templates/load-commands.md" "$INSTALL_DIR/"
    echo "Installed create-feature.templates/load-commands.md to $INSTALL_DIR"
  fi

  if [ -f "$TEMPLATE_DIR/planning/install-aide.spec.md" ]; then
    cp "$TEMPLATE_DIR/planning/install-aide.spec.md" "$INSTALL_DIR/"
    echo "Installed planning/install-aide.spec.md to $INSTALL_DIR"
  fi
}

# Main function
main() {
  # Check if the script is run as root
  if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or use sudo."
    exit 1
  fi

  # Backup existing files in the installation directory
  backup_files "$INSTALL_DIR/create-project.sh" "$INSTALL_DIR/start-mobile-session.sh" "$INSTALL_DIR/end-session.sh" "$INSTALL_DIR/create-feature.sh"

  # Install scripts and templates
  install_scripts

  echo "Installation complete."
}

# Run the main function
main
