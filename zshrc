# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

export ZSH_THEME="candy"

export DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew bundler gem git rbenv)

source $ZSH/oh-my-zsh.sh

export PATH=/usr/local/bin:$PATH

alias b='bundle exec'
alias tmux='TERM=screen-256color-bce tmux'

export EDITOR=vim

# Ruby tweaks
export RUBY_HEAP_MIN_SLOTS=500000
export RUBY_HEAP_SLOTS_INCREMENT=250000
export RUBY_GC_MALLOC_LIMIT=50000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# Chef
export OPSCODE_USER="acooper"
export OPSCODE_ORGNAME="partnerpedia"

# Node
export NODE_PATH='/usr/local/lib/node_modules'

# stop oh-my-zsh from updating the window title
export DISABLE_AUTO_TITLE=true

# RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && . $HOME/.rvm/scripts/rvm

