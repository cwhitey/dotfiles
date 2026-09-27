############
# general
############
alias ln="${aliases[ln]:-ln} -v"  # verbose ln

# ls shortcuts
alias ls='ls -G'         # ls with colours
alias l='ls -1A'         # One column, hidden files
alias ll='ls -oh'        # Human readable
alias lr='ls -ohR'       # Human readable, recursively
alias la='ls -ohA'       # Human readable, hidden files
alias lk='ls -ohSr'      # By size, largest last.
alias lt='ls -ohtr'      # By date, most recent last.
alias lc='ls -ohtrc'     # By date, most recent last, change time.
alias lu='ls -ohtru'     # By date, most recent last, access time.

# notify me before clobbering files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias keybindings='bindkey'

############
# git
############
[ -f $ZCONFIG/aliases-git.zsh ] && source $ZCONFIG/aliases-git.zsh

############
# emacs
############
#NOTE: Try to use modules/emacs/scripts/e instead
# start emacs server
alias es='emacs --daemon'
# start emacs without coupling to current terminal and push output to ~/nohup.out
em() { sh -c 'cd /tmp; nohup emacs &'; }
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
    alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

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

fi
