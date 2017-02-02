#!/bin/sh
if which brew >/dev/null 2>&1; then
    brew install getantibody/tap/antibody
else
    curl -sL https://git.io/antibody | sh -s
fi

antibody bundle < "bundles.txt" > ~/.antibody-bundled-bundles.txt
antibody bundle sindresorhus/pure >> ~/.antibody-bundled-bundles.txt
# Some special packages have to be loaded last
antibody bundle < "last_bundles.txt" >> ~/.antibody-bundled-bundles.txt
