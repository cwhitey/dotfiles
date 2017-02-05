#!/bin/sh
if which brew >/dev/null 2>&1; then
    brew install getantibody/tap/antibody
else
    curl -sL https://git.io/antibody | sh -s
fi
