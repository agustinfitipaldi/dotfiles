# ~/.bashrc: executed by bash(1) for non-login shells.

# Silence Apple's bash deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============ PLATFORM DETECTION ============
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MAC=true
else
    IS_MAC=false
fi

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
if [ "$IS_MAC" = true ]; then
    # macOS uses BSD ls
    alias ls='ls -G'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    # Linux with GNU coreutils
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
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

# Git
alias g='git'
alias gst='git status'

# Pantry
alias mp='vim -O /Users/agustinfitipaldi/dev/truth/meal.md /Users/agustinfitipaldi/dev/truth/pantry.md'
alias lp='vim -O /Users/agustinfitipaldi/dev/truth/lunchbox.md /Users/agustinfitipaldi/dev/truth/pantry.md'
alias m='vim /Users/agustinfitipaldi/dev/truth/meal.md'
alias l='vim /Users/agustinfitipaldi/dev/truth/lunchbox.md'
alias p='vim /Users/agustinfitipaldi/dev/truth/pantry.md'
alias mc='vim -o /Users/agustinfitipaldi/dev/truth/meal.md /Users/agustinfitipaldi/dev/truth/compost.md'
alias ml='vim -O /Users/agustinfitipaldi/dev/truth/meal.md /Users/agustinfitipaldi/dev/truth/lunchbox.md'
alias jls='ls ~/dev/truth/jars'
# System
alias ZZ='exit'

# YTDLP
alias ytdlp='~/dev/ytdlp/download.sh'
alias unq='xattr -d com.apple.quarantine'

# Platform-specific aliases
if [ "$IS_MAC" = false ]; then
    # Linux only
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

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

j() {
    vim "/Users/agustinfitipaldi/dev/truth/jars/${1}-jar.md"
}

# ============ ENVIRONMENT VARIABLES ============
# NVM
export NVM_DIR="$HOME/.nvm"

# Platform-specific SSH auth socket
if [ "$IS_MAC" = true ]; then
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
else
    export SSH_AUTH_SOCK=~/.1password/agent.sock
fi

# Development tools (only set if they exist)
[ -d "$HOME/Android/Sdk" ] && export ANDROID_HOME=$HOME/Android/Sdk

# PATH modifications (consolidated)
export PATH="$HOME/bin:$HOME/.cargo/bin:$PATH"
[ -d "/usr/local/go/bin" ] && export PATH="$PATH:/usr/local/go/bin"
[ -n "$ANDROID_HOME" ] && export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# ============ SOURCE EXTERNAL CONFIGS ============
# Bash completion
if [ "$IS_MAC" = true ]; then
    # Homebrew bash completion
    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
else
    # Linux bash completion
    if ! shopt -oq posix && [ -f /usr/share/bash-completion/bash_completion ]; then
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

. "$HOME/.local/bin/env"

alias claude="/Users/agustinfitipaldi/.claude/local/claude"
