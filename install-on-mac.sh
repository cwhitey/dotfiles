#!/usr/bin/env bash

set -e

export PRIMARY='\033[0;32m'
export NC='\033[0m'

echo -e "${PRIMARY}* Installing system dependencies and dotfiles ${NC}"

./scripts/install-homebrew.sh &&
    ./scripts/install-homebrew-packages.sh &&
    ./scripts/install-spacemacs.sh
./install-yaml-config.sh
