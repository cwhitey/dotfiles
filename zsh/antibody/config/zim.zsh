# Shared by interactive startup and the Babashka maintenance tasks.
# Keep downloads and generated loaders outside the dotfiles repository.
ZIM_HOME=${ZIM_HOME:-${ZDOTDIR:-$HOME}/.zim}
ZIM_CONFIG_FILE=${${(%):-%N}:A:h:h}/.zimrc
ZIM_SCRIPT="$(brew --prefix)/opt/zimfw/share/zimfw.zsh"
