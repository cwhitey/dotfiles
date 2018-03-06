#!/usr/bin/env bash

set -e

./scripts/install-homebrew.sh &&
    ./scripts/install-homebrew-packages.sh &&
    ./scripts/install-spacemacs.sh &&
    ./install-yaml-config.sh
