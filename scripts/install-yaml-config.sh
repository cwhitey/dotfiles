#!/usr/bin/env bash

echo -e "${PRIMARY}** Moving dotfiles configured in install.conf.yaml to their locations ${NC}"

cd $DOTFILES_DIR
./install
