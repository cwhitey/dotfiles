# Expands ... to ../.. (stolen from zprezto)
function expand-dot-to-parent-directory-path {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+='/..'
    else
        LBUFFER+='.'
    fi
}
zle -N expand-dot-to-parent-directory-path
bindkey '.' expand-dot-to-parent-directory-path

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Emacs bindings
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

pb-kill-line () {
    zle kill-line
    echo -n $CUTBUFFER | pbcopy
}

pb-kill-whole-line () {
    zle kill-whole-line
    echo -n $CUTBUFFER | pbcopy
}

pb-backward-kill-word () {
    zle backward-kill-word
    echo -n $CUTBUFFER | pbcopy
}

pb-kill-word () {
    zle kill-word
    echo -n $CUTBUFFER | pbcopy
}

pb-kill-buffer () {
    zle kill-buffer
    echo -n $CUTBUFFER | pbcopy
}

pb-copy-region-and-kill-deactivate-mark () {
    zle copy-region-as-kill
    zle kill-region
    zle set-mark-command -n -1
    echo -n $CUTBUFFER | pbcopy
}

pb-yank () {
    CUTBUFFER=$(pbpaste)
    zle yank
}

zle -N pb-kill-line
zle -N pb-kill-whole-line
zle -N pb-backward-kill-word
zle -N pb-kill-word
zle -N pb-kill-buffer
zle -N pb-copy-region-and-kill-deactivate-mark
zle -N pb-yank

bindkey '^K'   pb-kill-line
bindkey '^U'   pb-kill-whole-line
bindkey '^[^?' pb-backward-kill-word
bindkey '^[D'  pb-kill-word
#bindkey '^X^K' pb-kill-buffer
bindkey '^W'   pb-copy-region-and-kill-deactivate-mark
bindkey '^Y'   pb-yank


