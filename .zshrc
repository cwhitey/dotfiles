# Mostly borrowed from sharat87's 'lawn' repo

# start_time="$(date +%s)"

# Antigen — A zsh plugin manager
source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo declared above.
antigen bundles <<EOBUNDLES

##
# Clojure
##
lein


##
# Python
##
pip
python
virtualenv


##
# Ruby
##
ruby
gem
rake
bundler


##
# Node
##
npm
node


##
# Heroku
##
heroku


##
# Version control
##
svn
git
git-extras


##
# ZSH
##
# ZSH port of Fish shell's history search feature.
zsh-users/zsh-history-substring-search

# Syntax highlighting bundle.
zsh-users/zsh-syntax-highlighting

# nicoulaj's moar completion files for zsh
zsh-users/zsh-completions src

# Navigate 'cd' history using ALT-LEFT and ALT-RIGHT
dirhistory

# Press ESC twice to put sudo in front of current command, or previous
sudo

# Helper for extracting different types of archives.
extract

# Guess what to install when running an unknown command.
command-not-found


##
# lulz
##
#lol
#nyan

EOBUNDLES

# Tracks your most used directories, based on 'frecency'. And its accompanying
# setup code.
antigen bundle rupa/z
add-zsh-hook precmd _z_precmd
function _z_precmd {
    _z --add "$PWD"
}


##
# OS Detection, stolen from jdavis
##
UNAME=`uname`

# Fallback info
CURRENT_OS='Linux'
DISTRO=''

if [[ $UNAME == 'Darwin' ]]; then
    CURRENT_OS='OS X'
else
    # Must be Linux, determine distro
    if [[ -f /etc/redhat-release ]]; then
        # CentOS or Redhat?
        if grep -q "CentOS" /etc/redhat-release; then
            DISTRO='CentOS'
        else
            DISTRO='RHEL'
        fi
    fi
fi


##
# OS specific plugins
##
if [[ $CURRENT_OS == 'OS X' ]]; then
    # Keep directories when resuming OS session
    #antigen bundle terminalapp

    # Add completion for 'brew' command
    antigen bundle brew
    antigen bundle brew-cask

    auto-ls () { ls; }

elif [[ $CURRENT_OS == 'Linux' ]]; then
    auto-ls () { ls --classify; }

    if [[ $DISTRO == 'CentOS' ]]; then
    fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
fi


##
# User-specific stuff
##
USER=$(whoami)
if [[ $USER == "whitec" ]]; then
    # Must be on work computer
    # I want to use java 1.7
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
fi


##
# Hostname-specific stuff
##
HOSTNAME=$(hostname)
if [[ $HOSTNAME == "apdmmac-33.dpost.local" ]]; then

fi


##
# Clojure
##
export LEIN_FAST_TRAMPOLINE=y
alias cljsbuild="lein trampoline cljsbuild $@"


##
# Emacs
##
export PATH="/usr/local/Cellar/emacs/24.5/bin:$PATH"
# start emacs server
alias es='emacs --daemon'
# if alternate-editor is an empty string, Emacs is started in daemon mode and emacsclient will try to connect to it
function checker-ec { emacsclient --alternate-editor='' $@; }
# kill emacs server
alias ek="emacsclient -e '(kill-emacs)'"
# start emacs with a gui frame
function ec { checker-ec -c $@ &; }
# start emacs in a terminal
function et { checker-ec -t $@; }
# restart emacs server
alias er='ek; es;'
# fix color issues
export TERM=xterm-256color


##
# Editor
##
export EDITOR='et'


# Load the prompt theme.
# antigen theme prose
# antigen theme sindresorhus/pure pure
# antigen theme jdavis/zsh-files themes/jdavis
# antigen theme gallois
antigen theme gianu

# Tell Antigen that we're done.
antigen apply

# Automatically list directory contents on `cd`.
chpwd_functions=( auto-ls $chpwd_functions )

# wohwohwohowhohohoho!
# fortune -s -n 300 | cowsay | lolcat

# end_time="$(date +%s)"
# echo .zshrc: $((end_time - start_time)) seconds

# phantomjs
#export PATH="/opt/phantomjs/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
