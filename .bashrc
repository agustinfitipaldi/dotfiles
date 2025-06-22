# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============ HISTORY ============
HISTCONTROL=ignoreboth      # Don't save duplicates or lines starting with space
shopt -s histappend         # Append to history, don't overwrite
HISTSIZE=10000              # Bumped this up - 1000 is nothing
HISTFILESIZE=20000          # Disk is cheap, history is valuable

# ============ SHELL OPTIONS ============
shopt -s checkwinsize       # Update LINES/COLUMNS after each command
# shopt -s globstar         # Uncomment if you want ** to match recursively

# ============ PROMPT ============
PS1='\[\033[36m\]\W\[\033[0m\] $ '
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'  # Set terminal title to current path

# ============ COLORS ============
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ============ KEYBINDINGS ============
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ============ ALIASES ============
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git
alias g='git'
alias gst='git status'

# System
alias ZZ='exit'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Keyboard layouts (your custom stuff)
alias keyboard-default='sudo cp /etc/keyd/default.conf /etc/keyd/default.conf.active && sudo keyd reload'
alias keyboard-sun='sudo cp /etc/keyd/sun.conf /etc/keyd/default.conf.active && sudo keyd reload'

# ============ FUNCTIONS ============
# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# cd and list
cdl() {
    builtin cd "$@" && ls
}

# Theme toggle for Alacritty
tt() {
    config_dir="$HOME/.config/alacritty"
    current_config="$config_dir/alacritty.toml"
    dark_config="$config_dir/alacritty-dark.toml"
    light_config="$config_dir/alacritty-light.toml"
    
    # Create symlink if it doesn't exist
    if [ ! -L "$current_config" ]; then
        ln -sf "$dark_config" "$current_config"
    fi
    
    # Toggle between themes
    if [ "$(readlink $current_config)" = "$dark_config" ]; then
        ln -sf "$light_config" "$current_config"
        echo "Switched to light theme"
    else
        ln -sf "$dark_config" "$current_config"
        echo "Switched to dark theme"
    fi
    
    # Reload Alacritty config
    touch "$current_config"  # Sometimes needed to trigger reload
}

# ============ ENVIRONMENT VARIABLES ============
# Development tools
export SSH_AUTH_SOCK=~/.1password/agent.sock
export NVM_DIR="$HOME/.nvm"
export ANDROID_HOME=$HOME/Android/Sdk

# PATH modifications (consolidated)
export PATH="$HOME/bin:$HOME/.cargo/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# ============ SOURCE EXTERNAL CONFIGS ============
# Bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    fi
fi

# Tool-specific sourcing
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/dev/alacritty/extra/completions/alacritty.bash" ] && source "$HOME/dev/alacritty/extra/completions/alacritty.bash"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Load additional aliases if they exist
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
