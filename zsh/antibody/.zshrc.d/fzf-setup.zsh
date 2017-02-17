# Dedicated completion key while retaining default TAB (^I) behaviour
export FZF_COMPLETION_TRIGGER=''
#bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion
fzf_color_options="--color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229 --color info:150,prompt:110,spinner:150,pointer:167,marker:174"
export FZF_DEFAULT_OPTS="--exact --cycle --reverse --height 12 --inline-info --bind=ctrl-j:accept,ctrl-k:kill-line $fzf_color_options"
# Use the fast the_platinum_surfer instead of find. Also respects .gitignore etc.
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bindkey '^Z' fzf-file-widget
