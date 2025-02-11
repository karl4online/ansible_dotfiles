#!/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

#shopt
shopt -s autocd # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize # checks term size when bash regains control

#######################################################
# EXPORTS
#######################################################

### EXPORT ###
export TERM="xterm-256color" 
export EDITOR='nvim'
export VISUAL='nvim'
export HISTCONTROL=ignoreboth:erasedups
export MANPAGER="nvim +Man!"
export PAGER='less'

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=9999
export HISTTIMEFORMAT="%d/%m/%y %T " # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace
export HISTIGNORE="a:aa:c:cd:e:exit:f:ff:h:history:l:ll:ls:la:n:N:pwd:v:y:Y:z:zz"

if [[ -x "$(command -v starship)" ]]; then
  export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
fi

# set up XDG folders
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

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi

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

eval "$(starship init bash)"
eval "$(zoxide init bash)"


# if [ -d "$HOME/.local/bin" ] ;
#     then PATH="$HOME/.local/bin:$PATH"
#
#     if [ -d "$HOME/.local/bin/arch" ] ;
#         then PATH="$HOME/.local/bin/arch:$PATH"
#     fi
#
#     if [ -d "$HOME/.local/bin/arch" ] ;
#         then PATH="$HOME/.local/bin/audio:$PATH"
#     fi
#
#     if [ -d "$HOME/.local/bin/audio" ] ;
#         then PATH="$HOME/.local/bin/wayland:$PATH"
#     fi
#
#     if [ -d "$HOME/.local/bin/wayland" ] ;
#         then PATH="$HOME/.local/bin/wayland:$PATH"
#     fi
# fi
