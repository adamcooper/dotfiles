# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

export ZSH_THEME="robbyrussell"

export DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew bundler gem git rbenv)

source $ZSH/oh-my-zsh.sh

# add homebrew
export PATH=/usr/local/bin:$PATH

# disable autocorrect
unsetopt correct_all
#alias heroku=’nocorrect heroku’

export EDITOR=vim

# Ruby tweaks
export RUBY_GC_HEAP_INIT_SLOTS=500000
export RUBY_HEAP_SLOTS_INCREMENT=250000
export RUBY_GC_MALLOC_LIMIT=50000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# Node
# export NODE_PATH='/usr/local/lib/node_modules'

# Go Lang settings
export GOPATH=$HOME/Projects/go
export PATH=$PATH:/usr/local/opt/go/libexec/bin:$GOPATH/sdk/go_appengine

# Ionic settings
export PATH=$PATH:~/Projects/android-sdk/tools:~/Projects/android-sdk/platform-tools

# stop oh-my-zsh from updating the window title
# nice to have for tmux!
export DISABLE_AUTO_TITLE=true

# RBENV
# Recently had to move it from .zshenv to avoid "command not found: rbenv"
export PATH=$HOME/.rbenv/bin:$PATH
#eval "$(rbenv init -)"



export NVM_DIR="/Users/adam/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
