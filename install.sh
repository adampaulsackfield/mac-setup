#! /bin/bash

set -euo pipefail

# LOGGING
exec &> >(tee install.log)

# FUNCTIONS
attention() {
    echo "$DIVIDER"
    echo "             _______   _______   ______   _   _   _______   _____    ____    _   _  " 
    echo "     /\     |__   __| |__   __| |  ____| | \ | | |__   __| |_   _|  / __ \  | \ | | " 
    echo "    /  \       | |       | |    | |__    |  \| |    | |      | |   | |  | | |  \| | " 
    echo "   / /\ \      | |       | |    |  __|   | .   |    | |      | |   | |  | | | .   | " 
    echo "  / ____ \     | |       | |    | |____  | |\  |    | |     _| |_  | |__| | | |\  | " 
    echo " /_/    \_\    |_|       |_|    |______| |_| \_|    |_|    |_____|  \____/  |_| \_| " 
    echo "                                                                                    " 
    echo "        _____    ______    ____    _    _   _____   _____    ______   _____         " 
    echo "       |  __ \  |  ____|  / __ \  | |  | | |_   _| |  __ \  |  ____| |  __ \        " 
    echo "       | |__) | | |__    | |  | | | |  | |   | |   | |__) | | |__    | |  | |       " 
    echo "       |  _  /  |  __|   | |  | | | |  | |   | |   |  _  /  |  __|   | |  | |       " 
    echo "       | | \ \  | |____  | |__| | | |__| |  _| |_  | | \ \  | |____  | |__| |       " 
    echo "       |_|  \_\ |______|  \___\_\  \____/  |_____| |_|  \_\ |______| |_____/        "
    echo ""
    echo "$DIVIDER"
    echo ""
    echo "$DIVIDER"
    echo ""
    echo "$1"
    echo ""
    echo "$DIVIDER"
}

message_data() {
    echo $DIVIDER
    echo ""
    echo "$1"
    echo ""
    echo $DIVIDER
}

prompt_user() {
    read -p "Press enter only when requirement is met"
}

# USER INPUT
echo "Enter the your name for Github. e.g. Adam Sackfield"
read  GIT_NAME

echo "Enter the your Github username. e.g adampaulsackfield"
read  GIT_USERNAME

echo "Enter the your Github email."
read  GIT_EMAIL

echo "Name your Github SSH_KEY: 'github' for instance."
read  GIT_SSH

# VARIABLES
MAC_USERNAME=$(whoami)
DIVIDER="====================================================================================="

# =====================================================================================
# INSTALLING XCODE TOOLS
# =====================================================================================

xcode-select --install

message_data "Installing Xcode: Command-line-tools"

attention "Wait for Xcode command-line-tools installation to complete before pressing enter"

prompt_user

# =====================================================================================
# INSTALLING HOMEBREW
# =====================================================================================

message_data "Installing Homebrew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

PATH=$PATH:/opt/homebrew/bin

brew doctor
brew analytics off

# =====================================================================================
# INSTALLING GIT
# =====================================================================================

message_data "Installing Git"

brew install git

# =====================================================================================
# INSTALLING ZSH
# =====================================================================================

message_data "Installing Zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

export ZSH="$HOME/.oh-my-zsh"

# =====================================================================================
# INSTALLING ZSH - PLUGINS
# =====================================================================================

message_data "Installing Zsh Plugins: syntax-highlighting, autosuggestions"

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> "$HOME/.zshrc"

# =====================================================================================
# INSTALLING ZSH - THEME: Powerlevel10k & Fonts
# =====================================================================================

message_data "Install Zsh: Powerlevel10k Theme / Fonts"

git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts
 
# =====================================================================================
# DOWNLOADING ITERM THEME: Dracula
# =====================================================================================

message_data "Downloading iTerm Dracula Theme"

git clone https://github.com/dracula/iterm.git ~/Downloads/iterm

# =====================================================================================
# INSTALLING ROSETTA
# =====================================================================================

message_data "Installing Rosetta"

sudo softwareupdate --install-rosetta

# =====================================================================================
# INSTALLING NVM / NODE:16
# =====================================================================================

message_data "Installing NVM and Node@16"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install 16 

# =====================================================================================
# CREATING USER DIRECTORIES
# =====================================================================================

message_data "Creating User Directories"

mkdir ~/Development
mkdir ~/Backup
mkdir ~/Scripts
mkdir -p ~/Logs/cron
mkdir ~/.ssh

# =====================================================================================
# INSTALLING BREW APPLICATIONS: This will take some time, user password may be required
# =====================================================================================

message_data "Installing Brew Applications \n This will take some time, user password may be \n required by some apps."

brew install --cask iterm2
brew install --cask visual-studio-code

# brew install mysql
# brew install mongodb-community
# brew install --cask mysqlworkbench

# brew install ansible
# brew install packer
# brew install terrßßaform
# brew install --cask docker
# brew install --cask vagrant
# brew install --cask postman

# brew install --cask obsidian
# brew install --cask notion
# brew install --cask raindropio
# brew install --cask freedom
# brew install --cask rescuetime
# brew install --cask todoist

# brew install zoom
# brew install dropbox
# brew install --cask obs
# brew install --cask slack
# brew install --cask thunderbird
# brew install --cask protonmail-bridge
# brew install --cask firefox
# brew install --cask microsoft-edge
# brew install --cask google-chrome
# brew install --cask protonvpn
# brew install --cask telegram
# brew install --cask discord
# brew install --cask google-drive
# brew install --cask signal

# brew install --cask dropzone
# brew install --cask alfred
# brew install --cask rectangle

# brew install --cask utm

# =====================================================================================
# GITHUB KEYPAIR CREATION / GIT CONFIG
# =====================================================================================

message_data "Creating GitHub Keypair."

cd ~/.ssh

ssh-keygen -o -t ed25519 -C "$GIT_EMAIL" -f ~/.ssh/$GIT_SSH  

ssh-add --apple-use-keychain "~/.ssh/$GIT_SSH"  

echo "Host github.com"  >> ~/.ssh/config
echo "AddKeysToAgent yes" >> ~/.ssh/config
echo "UseKeychain yes" >> ~/.ssh/config
echo "IdentityFile ~/.ssh/$GIT_SSH"  >> ~/.ssh/config

cd ~

git config --global user.name "$GIT_NAME"    
git config --global user.email "$GIT_EMAIL"  

# =====================================================================================
# COPY PUBLIC KEY FOR GITHUB
# =====================================================================================

pbcopy < ~/.ssh/$GIT_SSH.pub

attention "Public key will be on your clipboard, head to GitHub and add a new SSH Key, you can paste the key after adding a name."

prompt_user

# =====================================================================================
# CLONE PRIVATE BACKUP REPO USING SSH
# =====================================================================================

message_data "Cloning backup repo"

git clone "git@github.com:$GIT_USERNAME/backup.git" ~/system-config
# TODO - ADD PATH BACK -  ~/Backup/system-config

attention "VSCode will launch to trigger directory creation. Please close (VSCode) before pressing enter"

code ~/Backup/system-config

prompt_user

# =====================================================================================
# RESTORING VSCODE CONFIGURATION
# =====================================================================================

message_data "Configuring VSCode: Keybindings"

cp ~/Backup/system-config/vscode/keybindings.json "/Users/$MAC_USERNAME/Library/Application\ Support/Code/User"

message_data "Configuring VSCode: Settings"

cp ~/Backup/system-config/vscode/settings.json "/Users/$MAC_USERNAME/Library/Application\ Support/Code/User" 

message_data "Configuring VSCode: Installing Extensions"

while read extension; do
    code --install-extension "$extension"
done < ~/Backup/system-config/extensions.txt

message_data "Configuring VSCode: Snippets"

cp ~/Backup/system-config/vscode/snippets/* "/Users/$MAC_USERNAME/Library/Application\ Support/Code/User/snippets"

message_data "Restoring Scripts from Backup"

# =====================================================================================
# RESTORING SCRIPTS: MAKING SYMBOLIC LINK FOR BACKUP.SH
# =====================================================================================

cp ~/Backup/system-config/scirpts/* ~/Scripts
rm ~/Scripts/backup.sh
ln -s ~/Backup/system-config/backup.sh ~/Scripts/backup.sh

# =====================================================================================
# SCHEDULE CRONJOB: CREATING REGULAR CONFIG BACKUP
# =====================================================================================

message_data "Scheduling Backup: The inverse of this process"

attention "Crontab job for backups should be copied to the clipboard, after pressing enter VIM will launch, paster and then press :qw and return"

echo "1       */1     *       *       *       cd ~/Backup/system-config && ./backup.sh >> ~/Logs/cron/backup-log.txt" | pbcopy 

prompt_user

chmod 777 ~/Backup/system-config/backup.sh

crontab -e

# =====================================================================================
# ZSH SET AS DEFAULT
# =====================================================================================

message_data "Setting Zsh as default shell"

attention "Once the Zsh shell launches you must type 'exit' and return"

prompt_user

chsh -s /opt/homebrew/bin/zsh # Set as default 
echo export PATH=$PATH:/opt/homebrew/bin >> ~/.zshrc
source ~/.zshrc

# =====================================================================================
# RECOMMENDED TASKS
# =====================================================================================

attention "Recommended Tasks"

echo "- Change font in iTerm goto settings > profiles > text and set font to Space Mono for PowerLine"
echo "- Set iTerm Theme -> Settings -> Profiles -> Colors -> Color Presets -> Import -> Goto ~/Downloads -> Select theme file" 
echo "- Once theme is imported select color presets -> Dracula"
echo "- Run: p10k configure in zsh" # TODO - Check if can copy confifguee file

prompt_user
