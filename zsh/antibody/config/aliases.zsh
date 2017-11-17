############
# general
############
alias ln="${aliases[ln]:-ln} -v"  # verbose ln

# ls shortcuts
alias ls='ls -G'         # ls with colours
alias l='ls -1A'         # One column, hidden files
alias ll='ls -lh'        # Human readable
alias lr='ll -R'         # Human readable, recursively
alias la='ll -A'         # Human readablem hidden files
alias lm='la | "$PAGER"' # Human readable, hidden files, in pager
alias lx='ll -XB'        # By extension (GNU only).
alias lk='ll -Sr'        # By size, largest last.
alias lt='ll -tr'        # By date, most recent last.
alias lc='lt -c'         # By date, most recent last, change time.
alias lu='lt -u'         # By date, most recent last, access time.

# notify me before clobbering files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias keybindings='bindkey'

############
# git
############
[ -f $ZCONFIG/aliases-git.zsh ] && source $ZCONFIG/aliases-git.zsh
alias gcv='git commit --verbose'
alias ga='git add'
alias gap='git add --patch'
alias gst='git status'
alias gstash='git stash'
alias gpop='git pop'
alias gcb='git checkout -b'
alias gphm='git push heroku master'

############
# docker
############
alias doc=docker
alias dc=docker-compose
# Kill exited (non-running)
alias doc_rm_exited='docker rm $(docker ps -aq --filter status=exited)'
# Kill running
alias doc_rm_running='docker rm -f $(docker ps -aq --filter status=running)'
# Kill all
alias doc_rm_all='docker rm -f $(docker ps -aq)'
# Delete all images
alias doc_del_all_images='docker rmi $(docker images -aq)'
# Delete dangling images
alias doc_del_dangling_images='docker rmi $(docker images -aq --filter dangling=true)'

############
# clojure
############
alias cljsbuild="lein trampoline cljsbuild $@"

############
# ruby
############
alias be='bundle exec'

############
# terminal markdown viewer (https://github.com/axiros/terminal_markdown_viewer)
############
alias mdv='mdv -t "palette 99"'

############
# emacs
############
# check if the server is running
emacs_server_is_running() {
    ps ux | grep emacs | grep daemon
}
# start emacs server
alias es='emacs --daemon'
# start emacs without coupling to current terminal and push output to ~/nohup.out
e() { sh -c 'cd /tmp; nohup emacs &'; }
# NOTE: if alternate-editor is an empty string, Emacs is first started in daemon mode and emacsclient will try to connect to it
# NOTE: this doesn't work well when emacsclient is called this way by another program .e.g git
# open emacs in a new gui frame (do this the first time you use emacs after firing up server)
ecc() { emacsclient --alternate-editor='' -c $@ &; }
# open emacs in the existing gui frame (it's annoying you have to distinguish...)
ec() { emacsclient --alternate-editor='' $@ &; }
# start emacs in the current terminal
alias et="emacsclient --alternate-editor='' -t"
# kill emacs server
alias ek="emacsclient -e '(kill-emacs)'"
# restart emacs server
alias er='ek; es;'

############
# fasd
############
jj() {
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}
# smart-open with emacsclient
v() {
    local file
    file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && ec "${file}" || return 1
}
# smart-open with terminal emacs
vt() {
    local file
    file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && et "${file}" || return 1
}
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias f='fasd -f'        # file
alias d='fasd -d'        # directory
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
#unalias j
alias j='fasd_cd -d'     # mimic autojump behaviour
alias o='fasd -ea open'      # use fasd to select file/directory to open

############
# Ripgrep
############
# make ripgrep case insensitive
alias rg="rg -i"

############
# OSX
############
# Acknowledgements
# https://github.com/mwilliammyers/plugin-osx
# https://github.com/unixorn/tumult.plugin.zsh

if [[ $(uname) == *Darwin* ]]; then
    # Lock the screen
    if [[ $(uname) == *Darwin* ]]; then
        alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
    fi

    # Trim new lines and copy to clipboard
    alias c="tr -d '\n' | pbcopy"

    # Show/hide hidden files in Finder
    alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    
    # Hide/show all desktop icons (useful when presenting)
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
    
    # turn ethernet on/off
    alias ethoff="sudo networksetup setnetworkserviceenabled 'Ethernet 1' off"
    alias ethon="sudo networksetup setnetworkserviceenabled 'Ethernet 1' on"
    alias ethre="ethoff && ethon"
    
    alias mute="osascript -e 'set volume output muted true'"

    # MySQL
    # Use homebrew versions if present
    if [ -x /usr/local/bin/mysql/bin/mysql ]; then
        alias mysql="/usr/local/mysql/bin/mysql"
    fi

    if [ -x /usr/local/bin/mysql/bin/mysqladmin ]; then
        alias mysqladmin="/usr/local/mysql/bin/mysqladmin"
    fi
    
    ############
    # homebrew
    ############
    [ -f ~/.zshrc.d/aliases-homebrew.zsh ] && source ~/.zshrc.d/aliases-homebrew.zsh 
fi
