_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh
export PATH=/usr/local/bin:$PATH

WaterlooMount(){
	sshfs Waterloo:/home/roman/ ~/Waterloo/
}

WaterlooUnmount(){
	umount ~/Waterloo
}

xMount(){
	sshfs xinu:/homes/rtsegels/ ~/CSMachine/
}

xUnmount(){
	umount ~/CSMachine/
}

# homebrew path
export PATH=/usr/local/bin:$PATH

# mxtools PATH
export PATH="/Users/romantsegelskyi/Dropbox/RProject/mxtool2/:$PATH"

# go
export GOROOT=/usr/local/go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# aliases
alias prp='cd ~/Programming/rstats/pander; pwd'
alias prt='cd ~/Programming/rstats/testr; pwd'
