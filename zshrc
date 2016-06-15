# Path to your oh-my-zsh installation.
if [ -e /Users/romants/.oh-my-zsh ]; then
		export ZSH=/Users/romants/.oh-my-zsh
else
		export ZSH=/Users/romantsegelskyi/.oh-my-zsh
fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

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
alias vmc='ssh romantsegelskyi@192.168.99.100'
alias vmm='sshfs -o IdentityFile=~/.ssh/myserver_id_rsa romantsegelskyi@192.168.99.100:/home/romantsegelskyi/ /Users/romantsegelskyi/Mounted/ubuntu-lts'
alias vmu='umount /Users/romantsegelskyi/Mounted/ubuntu-lts'

# reactor machine
alias rc='ssh teamcity@reactor.ccs.neu.edu -L 8111:localhost:8111'

## work pc ssh
alias wmc='ssh romants@romants-macdev'
alias wmms='sshfs -o IdentityFile=~/.ssh/id_rsa romants@romants-macdev:/Users/romants/Source /Users/romantsegelskyi/Mounted/romants-macdev-source'
alias wmmb='sshfs -o IdentityFile=~/.ssh/id_rsa romants@romants-macdev:/Volumes/Builds/ /Users/romantsegelskyi/Mounted/romants-macdev-builds'
alias wmub='umount /Users/romantsegelskyi/Mounted/romants-macdev-builds'
alias wmus='umount /Users/romantsegelskyi/Mounted/romants-macdev-source'

## raspberry pi
alias pic='ssh pi@black-pearl'
alias pim='sshfs -o IdentityFile=~/.ssh/id_rsa pi@black-pearl:/home/pi/ /Users/romantsegelskyi/Mounted/pi'
alias piu='umount /Users/romantsegelskyi/Mounted/pi'

## testr and rjit
alias trr="~/Code/rstats/vmr/bin/R --vanilla -e 'devtools::install(\"~/Code/rstats/testr\")'"

## update setting
alias vz='vim ~/.zshrc'
alias cz='cat ~/.zshrc'
alias uz='source ~/.zshrc'
alias vh='sudo vim /etc/hosts'

## work to mac path aliases
alias wxomx='open ~/Mounted/romants-macdev-source/sd_devmain/dev/mbu/source/omx/src/omx.xcodeproj'
alias wxxl='open ~/Mounted/romants-macdev-source/sd_devmain/dev/xlshared/apple/project/xlshared.xcodeproj'
alias wxxlg='open ~/Mounted/romants-macdev-builds/builds_devmain/devmain/genproj/xlshared_genproj/xlshared_genproj.xcodeproj'

## react native additions
export ANDROID_HOME=~/Library/Android/sdk
export PATH="~/Library/Android/sdk/tools:~/Library/Android/sdk/platform-tools:${PATH}"

# ZSH standalone npm install autocompletion.
_npm_install_completion() {
		local si=$IFS

		# if 'install' or 'i ' is one of the subcommands, then...
		if [[ ${words} =~ 'install' ]] || [[ ${words} =~ 'i ' ]]; then

				# add the result of `ls ~/.npm` (npm cache) as completion options
				compadd -- $(COMP_CWORD=$((CURRENT-1)) \
															 COMP_LINE=$BUFFER \
															 COMP_POINT=0 \
															 ls ~/.npm -- "${words[@]}" \
															 2>/dev/null)
		fi

		IFS=$si
}

compdef _npm_install_completion 'npm'
## END ZSH npm install autocompletion
