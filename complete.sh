#! /bin/bash

set -euo pipefail
exec 1> >(tee -a install.log) 2>&1

exec 1>(tee -a install.log)
exec 2>(tee -a install-errors.log)

MAC_USERNAME=$1
GIT_USERNAME=$2
GIT_EMAIL=$3


divider="====================================================================================="
attention() {
    echo "$divider"
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
    echo "$divider"
}

message_data() {
    echo $divider
    echo ""
    echo "$1"
    echo ""
    echo $divider

    sleep 1
}

xcode-select --install

attention

while true; do
    message_data "Installing Xcode: Command-line-tools"
    read -p "*** Wait for Xcode command-line-tools installation to complete before pressing Y ***" yn

    case $yn in
        [Yy]* ) break;;
        * ) echo "Press Y once XCode: Command-line-tools has been installed";
    esac
done


message_data "Installing Homebrew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

PATH=$PATH:/opt/homebrew/bin

brew doctor
brew analytics off

message_data "Installing Git"

brew install git

message_data "Installing Zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

export ZSH="$HOME/.oh-my-zsh"

message_data "Installing Zsh Plugins: syntax-highlighting, autosuggestions"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> "$HOME/.zshrc"

message_data "Install Zsh: Powerlevel10k Theme / Fonts"

git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts
 
message_data "Downloading iTerm Dracula Theme"

git clone https://github.com/dracula/iterm.git ~/Downloads/iterm

message_data "Installing Rosetta"

sudo softwareupdate --install-rosetta

message_data "Installing NVM and Node@16"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install 16 

message_data "Creating User Directories"

mkdir ~/Development
mkdir ~/Backup
mkdir ~/Scripts
mkdir -p ~/Logs/cron
mkdir ~/.ssh

message_data "Installing Brew Applications"

brew install --cask iterm2
brew install --cask visual-studio-code

# # brew install mysql
# # brew install mongodb-community
# # brew install --cask mysqlworkbench

# # brew install ansible
# # brew install packer
# # brew install terrßßaform
# # brew install --cask docker
# # brew install --cask vagrant
# # brew install --cask postman

# # brew install --cask obsidian
# # brew install --cask notion
# # brew install --cask raindropio
# # brew install --cask freedom
# # brew install --cask rescuetime
# # brew install --cask todoist

# # brew install zoom
# # brew install dropbox
# # brew install --cask obs
# # brew install --cask slack
# # brew install --cask thunderbird
# # brew install --cask protonmail-bridge
# # brew install --cask firefox
# # brew install --cask microsoft-edge
# # brew install --cask google-chrome
# # brew install --cask protonvpn
# # brew install --cask telegram
# # brew install --cask discord
# # brew install --cask google-drive
# # brew install --cask signal

# # brew install --cask dropzone
# # brew install --cask alfred
# # brew install --cask rectangle

# # brew install --cask utm

attention

while true; do
    message_data "Creating GitHub Keypair."
    read -p "*** Name the key 'github' and add a password, after pressing Y ***" yn

    case $yn in
        [Yy]* ) break;;
        * ) echo "Press Y then name the key 'github'";
    esac
done

cd ~/.ssh

ssh-keygen -o -t rsa -C "$GIT_EMAIL"  
ssh-add --apple-use-keychain ~/.ssh/github   

echo "Host github.com"  >> ~/.ssh/config
echo "AddKeysToAgent yes" >> ~/.ssh/config
echo "UseKeychain yes" >> ~/.ssh/config
echo "IdentityFile ~/.ssh/github"  >> ~/.ssh/config

cd ~

git config --global user.name "$GIT_USERNAME"    
git config --global user.email "$GIT_EMAIL"  

pbcopy < ~/.ssh/github.pub

attention

while true; do
    message_data "If you named the key 'github' then the public key should be available on your clipboard."
    read -p "*** Confirm Public Key has been added to github.com, before pressing Y *** " yn
    case $yn in
        [Yy]* ) break;;
        * ) echo "Please press Y to confirm you have added the SSH Key to your github account.";;
    esac
done

message_data "Cloning backup repo"

git clone git@github.com:adampaulsackfield/backup.git ~/Backup/system-config

attention

code ~/Backup/system-config

while true; do
    message_data "VSCode needs to open, close it and press Y."
    read -p "*** Confirm you have closed, before pressing Y *** " yn
    case $yn in
        [Yy]* ) break;;
        * ) echo "Please press Y to confirm you have close VSCode.";;
    esac
done

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

cp ~/Backup/system-config/scirpts/* ~/Scripts
rm ~/Scripts/backup.sh
ln -s ~/Backup/system-config/backup.sh ~/Scripts/backup.sh

attention

message_data "Scheduling Backup"

pbcopy < "1       */1     *       *       *       cd ~/Backup/system-config && ./backup.sh >> ~/Logs/cron/backup-log.txt"

chmod 777 ~/Backup/system-config/backup.sh

while true; do
    message_data "Confirm you have copied the cronjob from above into the VIM window"
    echo: "--> press :wq to quit vim <--"

    read -p "*** Press Y to confirm you have added the cronjon" yn
    case $yn in
        [Yy]* ) break;;
        * ) echo "Please press Y to confirm.";;
    esac
done

crontab -e

attention

while true; do
    message_data "Setting Zsh as default shell"

    read -p "*** Once the Zsh shell launches you must type 'exit' and return" yn
    case $yn in
        [Yy]* ) break;;
        * ) echo "Please press Y to confirm you understand.";;
    esac
done

chsh -s /opt/homebrew/bin/zsh # Set as default 
echo export PATH=$PATH:/opt/homebrew/bin >> ~/.zshrc
source ~/.zshrc

attention

message_data "Recommended Tasks"

while true; do
    echo "- Change font in iTerm goto settings > profiles > text and set font to Space Mono for PowerLine"
    echo "- Set iTerm Theme -> Settings -> Profiles -> Colors -> Color Presets -> Import -> Goto ~/Downloads -> Select theme file" 
    echo "- Once theme is imported select color presets -> Dracula"
    echo "- Run: p10k configure in zsh" # TODO - Check if can copy confifguee file

    read -p "Press Y to confirm: " yn
    case $yn in
        [Yy]* ) break;;
        * ) echo "Please press Y to you understand.";;
    esac
done
