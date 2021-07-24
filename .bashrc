# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#################################
# custom dave stuff starts here
#################################

########################
# rbenv
#######################
#PATH=$PATH:~/.rbenv/bin

#eval "$(rbenv init -)"

####################
# pbcopy
###################
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipobard -o'

###################
# mirth
###################
alias gohub='getMirthPass; launcher > /dev/null & disown; ssh hub'
alias gomint='getMirthPass; launcher > /dev/null & disown; ssh mint'
alias gometl='getMirthPass; launcher > /dev/null & disown; ssh metl'

#############################
# kubernetes
#############################

export KOPS_STATE_STORE="s3://com-medaxion-kops-state"
export PATH="/home/dave/code/tfenv/bin:$PATH"

source <(kubectl completion bash)

alias kc=kubectl
complete -F __start_kubectl kc

alias kgp='kubectl get pods -o wide'
alias kgpv='kubectl get pv; echo "###"; kubectl get pvc;'

pbash() {
    pod_name=$(kgp | cut -d' ' -f1 | fzf)
    kubectl exec $pod_name --stdin --tty -- /bin/bash;
}

kgl() {
    pod_name=$(kgp | cut -d' ' -f1 | fzf)
    kubectl logs $pod_name
}

kdp() {
    pod_name=$(kgp | cut -d' ' -f1 | fzf)
    kubectl describe pods/$pod_name
}

alias login-memsql-kube='kops export kubecfg memsql-2.kops.medaxion.info --admin' 


#############################
# terraform
#############################

alias tf='/home/dave/code/tfenv/bin/terraform'
alias wgu='sudo wg-quick up /etc/wireguard/wg0.conf'
alias wgd='sudo wg-quick down /etc/wireguard/wg0.conf'
alias 1pw='eval $(op signin medaxion)'

#############################
# composure settings
############################
export XDG_DATA_HOME=/home/dave/code/medops/scripts
source /home/dave/code/medops/scripts/composure.sh

######################
# graphene build
######################
export PATH="/home/dave/code/platform-tools:$PATH"

#####################
# nvm
####################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

###################################
# add pip install stuff to my path
###################################
# /usr/bin/python3 -m pip scripts
export PATH="/home/dave/.local/bin:$PATH"

###################################
# clockify-cli
##################################
alias ck="clockify-cli"


##############
# libreoffice
##############
calc() {
    libreoffice --calc $1 &
}

#############
# rhinojs
# depends on
#       java
#       rhinojs being install at /home/dave/code/rhinojs/rhino-jar.jar
############
rr() {
    java -jar /home/dave/code/rhinojs/rhino-1.7.13.jar $1
}

###############
# 1password
# depends on 
#       1password cli binary being install at /usr/local/bin/op
##############

# Sign into 1password medaxion
op-s() {
    eval $(op signin medaxion)
}

# Get the entry uuid by it's title
get_op_uuid_by_entry_title() {
    op_entry_title=$1
    local uuid=$(op list items | jq -r --arg OP_ENTRY_TITLE "$op_entry_title" '.[    ] | select(.overview.title == $OP_ENTRY_TITLE) | .uuid')
    echo -n $uuid
}

# Get a credential by uuid and name. This works with 1password note datatypes and expects credentials to be in the "fields" section
get_op_credential_by_uuid_and_name() {
    local uuid=$1
    local title=$2
    local credential=$(op get item $uuid | jq -r --arg TITLE "$title" '.details.sections[] | .fields[] | select(.t == $TITLE) | .v')
    echo -n $credential
}

# Mirth
    # export mirth pass
    exmp() {
        export MIRTH_PASS=$(get_op_credential_by_uuid_and_name "$(get_op_uuid_by_entry_title "Mirth Credential")" "password")
    }

    # copy mirth pass
    cmp() {
        get_op_credential_by_uuid_and_name "$(get_op_uuid_by_entry_title "Mirth Credentials")" "password" | pbcopy
    }

# looker
    exlci() {
        export LOOKER_API_CLIENT_ID=$(get_op_credential_by_uuid_and_name "$(get_op_uuid_by_entry_title "Looker API Credentials")" "client_id")
    }

    exlcs() {
        export LOOKER_API_CLIENT_SECRET=$(get_op_credential_by_uuid_and_name "$(get_op_uuid_by_entry_title "Looker API Credentials")" "client_secret")
    }

##################################
# system config bare repo
#################################
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"


