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


# Pebble SDK
export PATH=/Users/romantsegelskyi/pebble-dev/PebbleSDK-current/bin:$PATH

##
# Your previous /Users/romantsegelskyi/.bash_profile file was backed up as /Users/romantsegelskyi/.bash_profile.macports-saved_2014-09-27_at_18:33:58
##

# MacPorts Installer addition on 2014-09-27_at_18:33:58: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# OPAM configuration
. /Users/romantsegelskyi/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# mxtools PATH
export PATH="/Users/romantsegelskyi/Dropbox/RProject/mxtool2/:$PATH"

