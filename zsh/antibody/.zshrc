setopt glob_dots # glob for dotfiles as well (hidden)
setopt no_beep # Disable sound
unsetopt correct

setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

setopt extended_glob

unsetopt menu_complete
unsetopt flowcontrol

setopt always_to_end
setopt auto_menu
setopt complete_in_word
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTFILE=~/.zsh_history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

export HOMEBREW_HOME="/usr/local/Cellar"

bindkey -e  # emacs mode

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold

###
# Load packages
###
source ~/.antibody-bundled-bundles.txt

###
# App settings
###
source /usr/local/share/chruby/chruby.sh
#source /usr/local/share/chruby/auto.sh
#chruby ruby-2.2.3 # Set default ruby version

eval "$(fasd --init auto)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.d/fzf-setup.zsh ] && source ~/.zshrc.d/fzf-setup.zsh 

###
# Keybindings
###
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

###
# Load other config files and compinit (for completion)
###
[ -f ~/.zshrc.d/aliases.zsh ] && source ~/.zshrc.d/aliases.zsh

autoload -U compinit && compinit

[ -f ~/.zshrc.d/completion.zsh ] && source ~/.zshrc.d/completion.zsh
#[ -f ~/.zshrc.d/zaw-setup.zsh ] && source ~/.zshrc.d/zaw-setup.zsh 
[ -f ~/.zshrc.d/local.zsh ] && source ~/.zshrc.d/local.zsh
