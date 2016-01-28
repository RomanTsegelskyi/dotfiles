# Path to your oh-my-zsh installation.
export ZSH=/Users/romantsegelskyi/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast git-extras brew command-not-found common-aliases docker history osx)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/go/bin:/Library/TeX/texbin"

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# go
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$HOME/Code/golang
export PATH=$PATH:$GOPATH/bin

# create sublime symlink
if [ ! -e /usr/local/bin/subl ]; then
 ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
fi

# aliases

## dir aliases
alias c='cd'
alias crp='cd ~/Code/rstats/pander; pwd'
alias crt='cd ~/Code/rstats/testr; pwd'
alias cr='cd ~/Code/rjit; pwd'
alias wb='cd ~/Writing/blog; pwd'
alias ww='cd ~/Writing/romantsegelskyi.github.io; pwd'
alias wl='cd ~/Writing/lists; pwd'
alias pr='cd ~/Code/rstats; pwd'

## go
alias cg='cd ~/Code/golang; pwd'
alias csm='cd ~/Code/golang/src/smsummarizer; pwd'
alias gbsm='go build smsummarizer'

## rustdevtools
alias crt='cd ~/Code/rusttools; pwd'
alias cbrt='cargo build'
run_rusttools() {
    ~/Code/rusttools/target/debug/rusttools @_
}
alias rrt=run_rusttools

## food app
alias cfa='cd ~/Code/food_matching/foodapp; pwd'
alias cfam='cd ~/Code/food_matching/foodapp_scripts; pwd'

# commands
alias mk="make -j 8"
alias ..='cd ..'
alias c='clear'
alias ctc='ctags -R -f .tags'
alias reb='make clean && make -j 8'

## vm
alias vmc='ssh -i ~/.ssh/myserver_id_rsa romantsegelskyi@192.168.99.102'
alias vmm='sshfs -o IdentityFile=~/.ssh/myserver_id_rsa romantsegelskyi@192.168.99.102:/home/romantsegelskyi/ /Users/romantsegelskyi/mvm'
alias vmu='umount /Users/romantsegelskyi/mvm'
alias rc='ssh teamcity@reactor.ccs.neu.edu -L 8111:localhost:8111'

## testr and rjit
alias trr="~/Code/rstats/vmr/bin/R --vanilla -e 'devtools::install(\"~/Code/rstats/testr\")'"

## update setting
alias vz='vim ~/.zshrc'
alias cz='cat ~/.zshrc'
alias uz='source ~/.zshrc'
alias vh='sudo vim /etc/hosts'
