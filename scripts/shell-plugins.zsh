#!/bin/zsh
# Run without loading the interactive shell: usable on a fresh machine.
if [[ $# != 1 || ( $1 != install && $1 != update ) ]]; then
    print -u2 'Usage: zsh scripts/shell-plugins.zsh install|update'
    exit 2
fi
if ! (( $+commands[brew] )); then
    print -u2 'Homebrew is required. Install it and initialise brew shellenv first.'
    exit 1
fi
source "${0:A:h:h}/zsh/antibody/config/zim.zsh"
if [[ ! -r "$ZIM_SCRIPT" ]]; then
    print -u2 'Zim is missing. Run: brew install zimfw'
    exit 1
fi
source "$ZIM_SCRIPT" "$1"
