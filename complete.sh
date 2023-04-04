#! /bin/bash

MAC_USERNAME=adamsackfield

xcode-select --install

while true; do
    echo "=============================="
    echo "Installing Xcode: Command-line-tools"
    echo "=============================="
    read -p "Press Y to confirm: " yn

    case $yn in
        [Yy]* ) break;;
        * ) echo "Press Y once XCode: Command-line-tools has been installed";;
    esac
done


echo "=============================="
echo "Installing Homebrew"
echo "=============================="
sleep 1

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

PATH=$PATH:/opt/homebrew/bin

brew doctor
brew analytics off

echo "=============================="
echo "Installing Git"
echo "=============================="
sleep 1

brew install git

echo "=============================="
echo "Installing Zsh"
echo "=============================="
sleep 1

brew install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# chsh -s /opt/homebrew/bin/zsh # Set as default 
export ZSH="$HOME/.oh-my-zsh"


echo "=============================="
echo "Installing Zsh Plugins"
echo "=============================="
sleep 1

mkdir $ZSH_CUSTOM/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> "$HOME/.zshrc"

echo "=============================="
echo "Installing Powerline Theme"
echo "=============================="
sleep 1

git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts

p10k configure
 
echo export PATH=$PATH:/opt/homebrew/bin >> ~/.zshrc
source ~/.zshrc

echo "=============================="
echo "Installing Rosetta"
echo "=============================="
sleep 1

sudo softwareupdate --install-rosetta

echo "=============================="
echo "Installing NVM and Node@16"
echo "=============================="
sleep 1

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install 16 

echo "=============================="
echo "Creating Directories"
echo "=============================="
sleep 1

mkdir ~/Development
mkdir ~/Backup
mkdir ~/Scripts
mkdir -p ~/Logs/cron
mkdir ~/.ssh

echo "=============================="
echo "Installing Brew Applications"
echo "=============================="
sleep 1

brew install --cask iterm2
brew install --cask visual-studio-code

brew install mysql
brew install mongodb-community
brew install --cask mysqlworkbench

brew install ansible
brew install packer
brew install docker
brew install dropbox
brew install --cask vagrant
brew install --cask postman
brew install terraform

brew install --cask obsidian
brew install --cask notion
brew install --cask raindropio
brew install --cask freedom
brew install --cask rescuetime
brew install --cask todoist

brew install --cask obs
brew install --cask slack
brew install --cask thunderbird
brew install --cask protonmail-bridge
brew install --cask firefox
brew install --cask microsoft-edge
brew install --cask google-chrome
brew install --cask protonvpn
brew install --cask telegram
brew install --cask discord
brew install --cask google-drive
brew install --cask signal

brew install --cask dropzone
brew install --cask alfred
brew install --cask rectangle

brew install --cask utm
brew install zoom

echo "=============================="
echo "Create GitHub Key - name: github"
echo "=============================="
sleep 1

cd ~/.ssh
ssh-keygen -o -t rsa -C "adam@adamsackfield.uk"  
ssh-add --apple-use-keychain ~/.ssh/github   
Host github.com  >> ~/.ssh/config
AddKeysToAgent yes >> ~/.ssh/config
UseKeychain yes >> ~/.ssh/config
IdentityFile ~/.ssh/github  >> ~/.ssh/config

git config --global user.name "Adam Sackfield"    
git config --global user.email "adam@adamsackfield.uk"  

while true; do
    echo "Public Key created above must be added to GitHub before continuing"
    read -p "Press Y to confirm: " yn
    case $yn in
        [Yy]* ) break;;
        * ) echo "Please press Y to you understand.";;
    esac
done

echo "=============================="
echo "Cloning Backup Repo"
echo "=============================="
sleep 1

git clone git@github.com:adampaulsackfield/backup.git system-config

echo "=============================="
echo "Copying VSCode Keybindings"
echo "=============================="
sleep 1
cp ~/Backup/system-config/vscode/keybindings.json "/Users/$MAC_USERNAME/Library/Application\ Support/Code/User"
cp ~/Backup/system-config/vscode/settings.json "/Users/$MAC_USERNAME/Library/Application\ Support/Code/User" 

echo "=============================="
echo "Copying VSCode Settings"
echo "=============================="
sleep 1

while read extension; do
    code --install-extension "$extension"
done < ~/Backup/system-config/extensions.txt

echo "=============================="
echo "Copying VSCode Snippets"
echo "=============================="
sleep 1

cp ~/Backup/system-config/vscode/snippets/* "/Users/$MAC_USERNAME/Library/Application\ Support/Code/User/snippets"

echo "=============================="
echo "Copying Scripts"
echo "=============================="
sleep 1

cp ~/Backup/system-config/scirpts/* ~/Scripts
rm ~/Scripts/backup.sh
ln -s ~/Backup/system-config/backup.sh ~/Scripts/backup.sh

echo "=============================="
echo "Schedule Backups"
echo "=============================="
sleep 1

echo "Add to Crontab"
echo "1       */1     *       *       *       cd ~/Backup/system-config && ./backup.sh >> ~/Logs/cron/backup-log.txt"
sleep 1

chmod 777 ~/Backup/system-config/backup.sh

while true; do
    echo "Confirm you have copied the cronjob"
    echo: "--> press :wq to quit vim <--"

    read -p "Press Y to confirm: " yn
    case $yn in
        [Yy]* ) break;;
        * ) echo "Please press Y to confirm.";;
    esac
done

crontab -e

echo "=============================="
echo "Recommended Tasks"
echo "=============================="

while true; do
    echo "- Change font in iTerm goto settings > profiles > text and set font to Space Mono for PowerLine"

    read -p "Press Y to confirm: " yn
    case $yn in
        [Yy]* ) break;;
        * ) echo "Please press Y to you understand.";;
    esac
done
