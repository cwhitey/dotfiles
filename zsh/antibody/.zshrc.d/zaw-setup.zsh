# Configure Zaw

# Visual/Behavioral stuff
zstyle ':filter-select' max-lines 10
zstyle ':filter-select' hist-find-no-dups yes
zstyle ':filter-select' extended-search yes
zstyle ':filter-select' case-insensitive yes
zstyle ':filter-select' rotate-list yes

bindkey '^Z' zaw

# The following zaw source needs fixing
function zaw-src-fuzzy() {
    # Get the file list by find .
    OLDIFS=$IFS
    IFS=$'\n'
    candidates=($(find .))
    candidates=(${(iou)candidates[@]})
    IFS=$OLDIFS

    # Define what kind of action can be performed on the selected item
    # first: accept-line
    # second: accept-search
    actions=("zaw-callback-execute" "zaw-callback-append-to-buffer")
    act_descriptions=("execute" "append to edit buffer")
}
# Register our plugin
zaw-register-src -n fuzzy zaw-src-fuzzy
# Setup Ctrl-F shortcut to trigger
function fuzzy-start { kill-line; zaw-fuzzy }
zle -N fuzzy-start

bindkey '^F' zaw-git-files
