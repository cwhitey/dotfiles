#!/usr/bin/env bash

echo -e "${PRIMARY}** Installing homebrew and cask packages ${NC}"

cd $DOTFILES_DIR/osx
brew bundle
