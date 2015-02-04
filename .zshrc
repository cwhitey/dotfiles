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
elif [[ $CURRENT_OS == 'Linux' ]]; then
    # None so far...

    if [[ $DISTRO == 'CentOS' ]]; then
    fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
fi


# Load the prompt theme.
# antigen theme prose
# antigen theme sindresorhus/pure pure
# antigen theme jdavis/zsh-files themes/jdavis
antigen theme gallois

# Vim like bindings plugin. Need to run after theme, so mode indicator
# can be set, if the theme didn't already set it.
# antigen-bundle sharat87/zsh-vim-mode
# ZSH_VIM_MODE_NORMAL_MAP=^k
# antigen bundle ~/labs/zsh-vim-mode --no-local-clone

# Tell Antigen that we're done.
antigen apply

# Automatically list directory contents on `cd`.
auto-ls () { ls --classify; }
chpwd_functions=( auto-ls $chpwd_functions )

# wohwohwohowhohohoho!
# fortune -s -n 300 | cowsay | lolcat

# end_time="$(date +%s)"
# echo .zshrc: $((end_time - start_time)) seconds

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
