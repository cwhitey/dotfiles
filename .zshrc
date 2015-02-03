# Mostly borrowed from sharat87's 'lawn' repo

# start_time="$(date +%s)"

# Antigen — A zsh plugin manager
source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo declared above.
antigen bundles <<EOBUNDLES

lein
pip

# Guess what to install when running an unknown command.
command-not-found

# The heroku tool helper plugin.
heroku

# Helper for extracting different types of archives.
extract

# Help working with version control systems.
svn
git

# nicoulaj's moar completion files for zsh
zsh-users/zsh-completions src

# ZSH port of Fish shell's history search feature.
zsh-users/zsh-history-substring-search

# Syntax highlighting bundle.
zsh-users/zsh-syntax-highlighting

EOBUNDLES

# Tracks your most used directories, based on 'frecency'. And its accompanying
# setup code.
antigen bundle rupa/z
add-zsh-hook precmd _z_precmd
function _z_precmd {
    _z --add "$PWD"
}

# Load the prompt theme.
# antigen theme prose
# antigen theme sindresorhus/pure pure
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
