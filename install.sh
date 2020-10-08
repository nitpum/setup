#!/bin/sh

## Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K\r'
CLEAR_SCREEN='\033c'

# Check is project exists
if [ -d ~/pum ]; then 
  cd ~/pum
  if ! git status 2>&1 | grep -i 'not a git repository' > /dev/null ; then
    echo "${GREEN}✔ pum already cloned${NO_COLOR}"
  fi
else
  # No project
  mkdir -p ~/pum

  if ! [ -x "$(command -v curl)" ]; then
    echo "${YELLOW}⚠ Not found curl${NO_COLOR}"
    echo "Installing curl"
    apt update
    apt install curl
  fi


  echo "📦 Cloning project..."
  cd ~/pum
  git clone git@github.com:nitpum/pum.git ~/pum
fi

# Create symlink to bin
if [ -L ~/bin/pum.sh ]; then
  echo "${GREEN}✔ Launch already setup${NO_COLOR}"
else
  echo "🚀 Setup launch file..."
  mkdir -p ~/bin
  ln -s ~/pum/pum.sh ~/bin/pum.sh
  chmod +x ~/pum/pum.sh
fi

cd ~/

if grep "PATH=~/bin:\$PATH" .profile > /dev/null; then
  echo "${GREEN}✔ PATH already setup${NO_COLOR}"
else 
  echo "🚄 Setup PATH"

  echo -e "\nexport PATH=~/bin:\$PATH" >> ~/.profile
fi

if grep -E 'alias pum=pum\.sh' .profile > /dev/null; then
  echo "${GREEN}✔ Alias already setup${NO_COLOR}"
else
  echo "📢 Setup alias"

  echo -e "alias pum=pum.sh" >> ~/.profile
fi