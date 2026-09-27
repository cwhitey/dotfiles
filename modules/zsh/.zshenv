#!/bin/zsh
############
# Path
############
# Set the list of directories that Zsh searches for programs.
path=(
    /usr/local/bin
    $path
)
export AWS_DEFAULT_REGION="ap-southeast-2"

## editors
# The `e` wrapper is not currently provisioned; revisit when its Emacs path is updated.
# if hash e 2>/dev/null; then
#     export VISUAL='e'
#     export EDITOR='e'
# else
export VISUAL='nano'
export EDITOR='nano'
# fi
## language
if [[ -z "$LANG" ]]; then
    export LANG='en_US.UTF-8'
fi

## temporary Files
if [[ ! -d "$TMPDIR" ]]; then
    export TMPDIR="/tmp/$LOGNAME"
    mkdir -p -m 700 "$TMPDIR"
fi
TMPPREFIX="${TMPDIR%/}/zsh"
