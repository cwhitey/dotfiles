#!/bin/zsh

# Resolve this file through ~/.zshrc's symlink, wherever the repo was cloned.
ZSOURCEDIR=${${(%):-%N}:A:h}
ZCONFIG="$ZSOURCEDIR/config"
fpath=( $ZSOURCEDIR $fpath )
fpath+=("$(brew --prefix)/share/zsh/site-functions")

###
# Settings
#     - opt names are case insensitive and ignore underscores
###

# general settings
setopt no_beep # disable sound on error

# changing directories
setopt auto_cd # automatically cd to a directory if not cmd
setopt auto_pushd # automatically pushd directories on dirstack
setopt pushd_ignore_dups # don't push dups on stack
setopt pushd_minus # don't push multiple copies of the same directory onto the directory stack

# correction
unsetopt correct # no command or argument spell correction (too intrusive)

# glob/expansion settings
setopt glob_dots # don't require a ('.') specifically
setopt extended_glob # treat #, ~, and ^ as part of patterns for filename generation

# history
setopt share_history # imports new commands and appends typed commands to history
setopt extended_history # save timestamp of command and duration
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_verify # don't execute, just expand history

export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history

# completiona
unsetopt flow_control
unsetopt menu_complete # do not autoselect the first completion entry
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt complete_in_word # allow completion from within a word/phrase
setopt always_to_end # when completing from the middle of a word, move the cursor to the end of the word

# keybindings
bindkey -e # use emacs mode keybindings

# set proper word style so kill and move commands stop on directory delimiters etc.
autoload -U select-word-style
select-word-style bash
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Interactive terminal environment
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
export PAGER='less'
export LESSOPEN="| /opt/homebrew/bin/highlight %s --out-format xterm256 --line-numbers --quiet --force --style moria"
export LESS=' -R'
if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

###
# Load packages (completion must precede fzf-tab and widget plugins).
###
source "$ZCONFIG/zim.zsh"
if [[ ! "$ZIM_HOME/init.zsh" -nt "$ZIM_CONFIG_FILE" ]]; then
    if [[ -r "$ZIM_SCRIPT" ]]; then
        source "$ZIM_SCRIPT" init
    else
        print -u2 'Zim is missing: run brew install zimfw, then bb shell:install in your dotfiles repo.'
    fi
fi
[[ -r "$ZIM_HOME/init.zsh" ]] && source "$ZIM_HOME/init.zsh"

###
# after-package-load overrides
###
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"

###
# Theme
###
autoload -U promptinit; promptinit
prompt pure

###
# fzf
###
source $ZCONFIG/fzf-setup.zsh

###
# Keybindings
###
source $ZCONFIG/keybindings.zsh

###
# Load other config files
###
source $ZCONFIG/aliases.zsh

# zsh's built-in _zed completion is for an unrelated legacy editor and doesn't
# know about the Zed code editor's flags (e.g. -n), so it breaks file completion
compdef _files zed

[ -f $ZCONFIG/local.zsh ] && source $ZCONFIG/local.zsh || true

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

if [[ "$TERM_PROGRAM" == "kiro" ]] && (( $+commands[kiro] )); then
    source "$(kiro --locate-shell-integration-path zsh)"
fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# fnm (Fast Node Manager) — auto-switch Node on cd via .node-version / .nvmrc
eval "$(fnm env --use-on-cd --shell zsh)"

# SDKMAN (must be at the end of the file)
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
