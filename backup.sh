#!/bin/bash

# https://dev.to/jeffshomali/how-to-backup-sync-all-of-your-dotfiles-with-github-e1c

# Check to see if the Git CLI is installed
IS_GIT_AVAILABLE="$(git --version)"
if [[ $IS_GIT_AVAILABLE == *"version"* ]]; then
  echo "Git is Available"
else
  echo "Git is not installed"
  exit 1
fi

# VSCode
# ====================
# Copy files
cp  $HOME/Library/Application\ Support/Code/User/{keybindings.json,settings.json} $HOME/Backup/system-config/vscode/

# Copy snippets
cp -r $HOME/Library/Application\ Support/Code/User/snippets $HOME/Backup/system-config/vscode/

# Create list of installed extensions
ls ~/.vscode/extensions > $HOME/Backup/system-config/vscode/extensions.txt 

# Dot files
# ====================
# ohmyzsh
cp $HOME/.zshrc .

# aliases
cp $HOME/.aliases .

# Brew packages
# ====================
brew list > $HOME/Backup/system-config/brew/installs.txt

# Mac applications
# ====================
ls -la /Applications/ > $HOME/Backup/system-config/mac/applications.txt

# Git
# ====================
# Git config
cp $HOME/.gitconfig .

# Scripts
# ====================
cp -r $HOME/Scripts/* $HOME/Backup/system-config/scripts

# Status
gs="$(git status | grep -i "modified")"
# echo "${gs}"

# If changes
if [[ $gs == *"modified"* ]]; then
  echo "push"
fi

# Push
git add .
git commit -m "New backup `date +'%Y-%m-%d %H:%M:%S'`"
git push origin main