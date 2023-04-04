# mac-setup

A simple script used to set up M1 Mac from factory settings for a developement environment;

## Disclaimer

User input is required for some steps, as is inputting password.

## Regular Installs:

- Xcode
- Homebrew
- Rosetta
- NVM (Node Version Manager)
  - Node Version 16

## Brew Install:

- Development
  - Git
  - Zsh (OhMyZsh)
  - iTerm2
  - VSCode
  - Postman
- Databases
  - MySQL
  - MySQLWorkbench
  - Mongodb-community
- DevOps
  - Ansible
  - Packer
  - Vagrant
  - Terraform
  - Docker
- Storage
  - Dropbox
- Notes
  - Obsidian
  - Notion
  - Raindrop.io
- Productivity
  - Freedom.to
  - RescueTime
  - Todoist
  - Alfred
- Messaging
  - Slack
  - TeleGram
  - Discord
  - Signal
- General
  - OBS
  - ThunderBird
  - ProtonMail-Bridge
  - ProtonVPN
  - DropZone
  - Rectangle
- Browsers
  - Firefox
  - MicroSoft Edge
  - Google Chrome

### Zsh Config

- Plugin: zsh-autosuggestions
- Plugin: zsh-syntax-highlighting
- Theme: Powerline10k

### Git Config

- Creates SSH Key for GitHub SSH connection (expects name `github`)
  - Adds to keychain
  - Adds config to ~/.ssh/config
  - Adds global user.name
  - Adds global user.email
  - Hangs until user confirms key has been saved to github.com

### VSCode Config

- Copies keybindings from backup
- Copies settings from backup
- Copies snippets from backup
- Install extensions from backup

### General Tasks

- Pulls config backup data from GitHub, which are used to update settings
- Pulls Scripts from backup
- Copies .aliases to .zshrc from backup
- Schedules cronjob to backup config files