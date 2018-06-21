# Dedicated completion key while retaining default TAB (^I) behaviour
export FZF_COMPLETION_TRIGGER=''
#bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion >/dev/null

# fzf_color_options="--color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229 --color info:150,prompt:110,spinner:150,pointer:167,marker:174"

# Gruvbox theme
local color00='#282828'
local color01='#3c3836'
local color02='#504945'
local color03='#665c54'
local color04='#bdae93'
local color05='#d5c4a1'
local color06='#ebdbb2'
local color07='#fbf1c7'
local color08='#fb4934'
local color09='#fe8019'
local color0A='#fabd2f'
local color0B='#b8bb26'
local color0C='#8ec07c'
local color0D='#83a598'
local color0E='#d3869b'
local color0F='#d65d0e'

fzf_color_options="
  --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
"

export FZF_DEFAULT_OPTS="--exact --cycle --reverse --height 12 --inline-info --bind=ctrl-j:accept,ctrl-k:kill-line $fzf_color_options"
# Use the fast the_platinum_surfer instead of find. Also respects .gitignore etc.
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bindkey '^Z' fzf-file-widget
