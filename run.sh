#!/usr/bin/env bash

set -euo pipefail

DROPBOX_DIR="$HOME/Dropbox"

# Install Homebrew
if ! type "brew" &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi
brew doctor
brew update

# Install Dropbox
if ! brew ls --versions --cask dropbox &> /dev/null; then
  brew install --cask dropbox
  open -a /Applications/Dropbox.app
fi
echo 'Wait for Dropbox to fully sync and press RETURN to continue...'
while IFS='' read -r -s -n 1 -d '' key; do
  if [ "${key}" = $'\n' ]; then
    break
  fi
done

# Install Ansible
if ! type "ansible-playbook" &> /dev/null; then
  brew install ansible
fi

# Run
cd "$DROPBOX_DIR/restore/ansible"
ansible-playbook playbook.yml
