############
# general
############
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ln="${aliases[ln]:-ln} -v"  # verbose ln
alias l='ls -1'
alias ll='ls -l'
alias la='ls -la'

# notify me before clobbering files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

############
# git
############
alias ga='git add'
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
# Delete dangling images
alias doc_del_dangling='docker rmi $(docker images -aq --filter dangling=true)'

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
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias o='a -e open'      # use fasd to select file/directory to open

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
# start emacs server
alias es='emacs --daemon'
# NOTE: if alternate-editor is an empty string, Emacs is started in daemon mode and emacsclient will try to connect to it
# open emacs in a gui frame
ec() { emacsclient --alternate-editor='' -c $@ &; }
# start emacs in a terminal
alias et="emacsclient --alternate-editor='' -t"
# kill emacs server
alias ek="emacsclient -e '(kill-emacs)'"
# restart emacs server
alias er='ek; es;'

############
# homebrew
############
unalias cask  # for Emacs' Cask tool


