#!/bin/zsh

# resolve zsh dotfiles directory
SOURCE=${(%):-%N}
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
ZSOURCEDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
ZCONFIG="$ZSOURCEDIR/config"
fpath=( $ZSOURCEDIR $fpath )

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
setopt append_history # allow multiple terminal sessions to all append to one zsh command history
setopt inc_append_history # add commands as they are typed, don't wait until shell exit
setopt extended_history # save timestamp of command and duration
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups # ignore consecutive duplicates
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_verify # don't execute, just expand history

export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTFILE=~/.zsh_history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# completiona
unsetopt flow_control
unsetopt menu_complete # do not autoselect the first completion entry
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs
setopt complete_in_word # allow completion from within a word/phrase
setopt always_to_end # when completing from the middle of a word, move the cursor to the end of the word

# keybindings
bindkey -e # use emacs mode keybindings

# set proper word style so kill and move commands stop on directory delimiters etc.
autoload -U select-word-style
select-word-style bash
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold

###
# Load packages
###
source $ZSOURCEDIR/antibody-bundled-bundles.txt

###
# after-package-load overrides
###
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"
export HOMEBREW_HOME="/usr/local/Cellar"

###
# Theme
###
autoload -U promptinit; promptinit
prompt pure

###
# App settings
###
source /usr/local/share/chruby/chruby.sh
#source /usr/local/share/chruby/auto.sh
#chruby ruby-2.2.3 # Set default ruby version

eval "$(fasd --init auto)"

# may need to run /usr/local/Cellar/fzf/0.17.1/install if this doesn't exist
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#[ -f $ZCONFIG/fzf-setup.zsh ] && source $ZCONFIG/fzf-setup.zsh

###
# Keybindings
###
[ -f $ZCONFIG/keybindings.zsh ] && source $ZCONFIG/keybindings.zsh

###
# Load other config files and compinit (for completion)
###
[ -f $ZCONFIG/git-functions.zsh ] && source $ZCONFIG/git-functions.zsh
[ -f $ZCONFIG/aliases.zsh ] && source $ZCONFIG/aliases.zsh

[ -f $ZCONFIG/completion.zsh ] && source $ZCONFIG/completion.zsh
# initialise zsh completion system
autoload -U compinit && compinit

#[ -f $ZCONFIG/zaw-setup.zsh ] && source $ZCONFIG/zaw-setup.zsh 
[ -f $ZCONFIG/local.zsh ] && source $ZCONFIG/local.zsh || true
