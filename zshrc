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
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"

source $ZSH/oh-my-zsh.sh

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# aliases
# python3 to python
# alias python=/usr/local/bin/python3
# alias pip=/usr/local/bin/pip3

## dir aliases
alias c='cd'

## ccache
export CCACHE_SLOPPINESS=clang_index_store,file_stat_matches,include_file_ctime,include_file_mtime,ivfsoverlay,pch_defines,modules,system_headers,time_macros
export CCACHE_FILECLONE=true
export CCACHE_DEPEND=true
export CCACHE_INODECACHE=true

## update setting
alias vz='vim ~/.zshrc'
alias cz='cat ~/.zshrc'
alias uz='source ~/.zshrc'
alias vh='sudo vim /etc/hosts'

## react native additions
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export JAVA_HOME=/usr/local/opt/openjdk@11
export PATH=$JAVA_HOME/bin:$PATH

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
export PATH=$PATH:/Users/romantsegelskyi/Library/Android/sdk/platform-tools/

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="/Users/romantsegelskyi/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/sbin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/usr/local/opt/postgresql@10/bin:$PATH"
