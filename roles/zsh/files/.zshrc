#!/usr/bin/env zsh
# export ZDOTDIR=$HOME/.config/zsh >> Add this to /etc/zsh/zshenv

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#######################################################
# Display manager
#######################################################

# Check if a graphical session is already active
if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" ]]; then
    # Load  UWSM after tty login
    source "$HOME/.config/zsh/uwsm"
fi

#######################################################
# Exports
#######################################################

if [ -d "$HOME/.config/zsh" ]; then
    export ZSH="$HOME/.config/zsh"
fi

if [[ -f "$HOME/.config/starship/starship.toml" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
fi

if [ -d "$HOME/.cache" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi

if [ -d "$HOME/.config" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -d "$HOME/.local/share" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -d "$HOME/.local/state" ]; then
    export XDG_STATE_HOME="$HOME/.local/state"
fi

export TERM="xterm-256color" 
export EDITOR='nvim'
export VISUAL='nvim'
export TERMINAL='kitty'
export BROWSER='app.zen_browser.zen'

# Load completions
autoload -U compinit; compinit

#######################################################
# Source
#######################################################

# Load plugins
source $ZSH/.zsh_plugins
# source $ZSH/.zsh_zinit

# Load aliases
source $HOME/.aliases
# source $ZSH/.zsh_alias

######################################################
# ZSH Basic Options
#######################################################

setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
bindkey -v

#######################################################
# History Configuration
#######################################################

HISTFILE="$ZSH/.zsh_history"
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTDUP=erase
export HISTTIMEFORMAT="%d/%m/%y %T " # add timestamp to history
export HISTORY_IGNORE="(a|aa|c|cd|e|exit|f|ff|h|history|l|ll|ls|n|N|pwd|r|v|y|Y|z|sz|zz)"
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#######################################################
# Completion styling
#######################################################

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#######################################################
# Add Common Binary Directories to Path
#######################################################

# Add directories to the end of the path if they exist and are not already in the path
# Link: https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
function pathappend() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}

# Add directories to the beginning of the path if they exist and are not already in the path
function pathprepend() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="$ARG${PATH:+":$PATH"}"
        fi
    done
}

# Add the most common personal binary paths located inside the home folder (these directories are only added if they exist)
pathprepend "$HOME/bin" "$HOME/sbin" "$HOME/.local/bin" "$HOME/local/bin" "$HOME/.bin" "/var/lib/flatpak/exports/bin"

# Add personal scripts (these directories are only added if they exist)
pathappend "$HOME/.local/bin/arch" "$HOME/.local/bin/audio" "$HOME/.local/bin/wayland" "$HOME/.local/bin/x11" "$HOME/.config/emacs/bin"

#######################################################
# Functions
#######################################################

# y shell wrapper that provides the ability to change the current working directory when exiting Yazi.
# y shell wrapper that provides the ability to change the current working directory when exiting Yazi.
function y() {
	local tmp=""

	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

	yazi "$@" --cwd-file="$tmp"

	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd" || return
	fi

	rm -f -- "$tmp"
}

# Start a program but immediately disown it and detach it from the terminal
function runfree() {
	"$@" > /dev/null 2>&1 & disown
}

# ex = EXtractor for all kinds of archives
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.deb)       ar x "$1"      ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.tar.zst)   tar xf "$1"    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#######################################################
# Shell integrations
#######################################################

# Initialize starship
eval "$(starship init zsh)"

# Initialize zoxide
eval "$(zoxide init zsh)" # --cmd cd zsh


