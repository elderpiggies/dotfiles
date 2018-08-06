#!/usr/bin/env bash

osname=$(uname)

if [ "$osname" != "Darwin" ]; then
  bootstrap_echo "Oops, it looks like you're using a non-UNIX system. This script
only supports Mac. Exiting..."
  exit 1
fi

printf "\\nEnter a name for your Mac.\\n"
read -r -p "> " HOST_NAME
export HOST_NAME=${HOST_NAME}


printf "\\nEnter your Alias.\\n"
read -r -p "> " ALIAS
export ALIAS=${ALIAS}

################################################################################
# Authenticate
################################################################################

sudo -v

# Keep-alive: update existing `sudo` time stamp until bootstrap has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

export ALIAS = $1

# Make SSH key
mkdir ~/.ssh
cd ~/.ssh
ssh-keygen -t rsa -b 4096 -C "${ALIAS}@gmail.com"

#TODO put logic in to wait for uploading public key to github.com


# Create new dotfiles
cd ~/dotfiles
rm -rf .git
git init
git commit -m "DEV: First commit."
git remote add origin git@github.com:${ALIAS}/dotfiles.git
git push -u origin master

# Name
sudo scutil --set ComputerName "$HOST_NAME"
sudo scutil --set HostName "$HOST_NAME"
sudo scutil --set LocalHostName "$HOST_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$HOST_NAME"

ln -s ~/dotfiles/.tmuxinator/ $HOME/.tmuxinator
ln -s ~/dotfiles/.teamocil/ $HOME/.teamocil
ln -s ~/dotfiles/.vim/ $HOME/.vim
ln -s ~/dotfiles/.zshrc/ $HOME/.zshrc




