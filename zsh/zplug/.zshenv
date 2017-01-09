############
# Path
############
# Set the list of directories that Zsh searches for programs.
path=(
    /usr/local/{bin,sbin}
    $path
)
# Node's install path
export NODE_PATH=/opt/lib/node_modules
# AWS
export AWS_CLI=/usr/local/bin/aws

############
# Settings
############
# leiningen
export LEIN_FAST_TRAMPOLINE=y

############
# Editors
############
export VISUAL='nano'
export PAGER='less'
export EDITOR='nano'

############
# Browser
############
if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

############
# Language
############
if [[ -z "$LANG" ]]; then
    export LANG='en_US.UTF-8'
fi

############
# Less
############
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'
# Use source-highlight for syntax highlighting in less
[ -f /usr/local/bin/src-hilite-lesspipe.sh ] && export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"

############
# Temporary Files
############
if [[ ! -d "$TMPDIR" ]]; then
    export TMPDIR="/tmp/$LOGNAME"
    mkdir -p -m 700 "$TMPDIR"
fi
TMPPREFIX="${TMPDIR%/}/zsh"
