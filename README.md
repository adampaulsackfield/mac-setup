# mac-setup

A simple script used to set up M1 Mac from factory settings for a developement environment;

## Disclaimer

User input is required for some steps, as is inputting password. This project only works if it has access to your backup files (sample strucutre below). The `backup.sh` script can be viewed [here](https://github.com/adampaulsackfield/mac-setup/blob/main/backup.sh)

### Backup Repo Structure

```
├── brew/
│ └── install.txt
├── mac/
│ └── applications.txt
├── scripts/
│ ├── backup.sh
│ └── otherUserScripts.sh
├── vscode/
│ ├── snippets/
│ │ ├── global.json.code-snippets
│ │ ├── javascript.json
│ │ ├── javascriptreact.json
│ │ ├── typescript.json
│ │ └── typescriptreact.json
│ ├── extensions.txt
│ ├── keybindings.json
│ └── settings.json
├── .aliases
├── .gitconfig
├── .zshrc
├── README.md
└── backup.sh
```

## How to Use

Simply run the following commands:

- `curl -O https://raw.githubusercontent.com/adampaulsackfield/mac-setup/main/complete.sh`
- `chmod 777 complete.sh`
- `./complete.sh`

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
