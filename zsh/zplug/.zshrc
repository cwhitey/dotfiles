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

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "~/.zsh_cache"

# install/init zplug
export ZPLUG_HOME=/usr/local/opt/zplug # for possible brew support
if [[ ! -d "${ZPLUG_HOME}" ]]; then
    echo "Installing zplug"
    curl --progress-bar -sL zplug.sh/installer | zsh
    source "${ZPLUG_HOME}/init.zsh"
    zplug update --self
else
    source "${ZPLUG_HOME}/init.zsh"
fi

# Additional completions - consider using prezto modules/completion
zplug "zsh-users/zsh-completions"
zplug "felixr/docker-zsh-completion"
zplug "plugins/lein", from:oh-my-zsh

# Auto-suggestions for commands (KEEP BEFORE syntax-highlighting)
zplug "zsh-users/zsh-autosuggestions"

zplug "unixorn/git-extra-commands"
zplug "tj/git-extras", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:3
ZSH_HIGHLIGHT_HIGHLIGHTERS=(
    main                          # Basic highlighting
    brackets                      # Match parenthesis
    root                          # Highlight when root
)
zplug "hlissner/zsh-autopair", defer:3
# highlight URLs based on their validity
zplug "ascii-soup/zsh-url-highlighter"
zplug "chrissicool/zsh-256color"
# load history-substring-search AFTER syntax-highlighting
zplug "zsh-users/zsh-history-substring-search"
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
zplug "supercrabtree/k"
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "zsh-users/zaw"
zplug 'caarlos0/zsh-mkc'

# theme
#zplug "mafredri/zsh-async", on:sindresorhus/pure
#zplug "sindresorhus/pure", use:pure.zsh, defer:3
zplug "frmendes/geometry"

# zplug alias packages
zplug "djui/alias-tips"
zplug "tcnksm/docker-alias"
zplug "modules/git", from:prezto
zplug "modules/fasd", from:prezto
zplug "modules/homebrew", from:prezto, if:"[[ $(uname) == *Darwin* ]]"
# load extra personal configs
zplug "~/.zshrc.d", from:local, use:"*.zsh"

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install new zplug packages? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose


source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
chruby ruby-2.2.3 # Set default ruby version

eval "$(fasd --init auto)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Dedicated completion key while retaining default TAB (^I) behaviour
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion
# Use the fast the_platinum_surfer instead of find. Also respects .gitignore etc.
export FZF_DEFAULT_COMMAND='pt -l ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=250" # set right-side color for autosuggestions
