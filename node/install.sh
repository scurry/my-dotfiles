#!/usr/bin/env zsh

# if test ! $(which spoof)
# then
#   sudo npm install spoof -g
# fi

if [ ! -d "$HOME/.zsh-nvm" ]; then
  git clone https://github.com/lukechilds/zsh-nvm.git $HOME/.zsh-nvm
fi

export NVM_NODEJS_ORG_MIRROR=https://repo.forge.lmig.com/node/
source $HOME/.zsh-nvm/zsh-nvm.plugin.zsh

nvm install 'lts/*'
nvm alias default node
