#!/bin/bash

# https://dev.to/jeffshomali/how-to-backup-sync-all-of-your-dotfiles-with-github-e1c

# THIS REPO SHOULD BE PRIVATE AND YOU SHOULD BE WARY WHERE YOU STORE SENSITIVE DATA SUCH AS AWS KEYS

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
ls ~/.vscode/extensions > $HOME/Backup/system-config/vscode/extensions-ver.txt 

while read -r line; do
  new_name=$(echo "$line" | awk -F'.' '{print $1"."$2}' | sed 's/-[^-]*$//')
  echo "$line" "->" "$new_name"
done < "$HOME/Backup/system-config/vscode/extensions-ver.txt" > extensions.txt

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