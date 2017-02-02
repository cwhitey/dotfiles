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
## leiningen
export LEIN_FAST_TRAMPOLINE=y

## ls
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS= 'di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

## editors
export VISUAL='nano'
export PAGER='less'
export EDITOR='nano'

## browser
if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

## language
if [[ -z "$LANG" ]]; then
    export LANG='en_US.UTF-8'
fi

## less
# default Less options
# -X disables mouse scrolling (disable screen clearing).
# remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'
# source-highlight for syntax highlighting in less
[ -f /usr/local/bin/src-hilite-lesspipe.sh ] && export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"

## temporary Files
if [[ ! -d "$TMPDIR" ]]; then
    export TMPDIR="/tmp/$LOGNAME"
    mkdir -p -m 700 "$TMPDIR"
fi
TMPPREFIX="${TMPDIR%/}/zsh"
