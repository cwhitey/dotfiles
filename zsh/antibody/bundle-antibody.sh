#!/bin/sh

BUNDLE_FILE="./antibody-bundled-bundles.txt"
touch $BUNDLE_FILE
# antibody bundle < "bundles.txt" > $BUNDLE_FILE
antibody bundle chrissicool/zsh-256color >> $BUNDLE_FILE
antibody bundle zsh-users/zsh-completions >> $BUNDLE_FILE
antibody bundle caarlos0/zsh-open-github-pr >> $BUNDLE_FILE
antibody bundle peterhurford/git-it-on.zsh >> $BUNDLE_FILE
# antibody bundle tcnksm/docker-alias >> $BUNDLE_FILE
# antibody bundle greymd/docker-zsh-completion >> $BUNDLE_FILE
antibody bundle hlissner/zsh-autopair >> $BUNDLE_FILE
# antibody bundle Tarrasch/zsh-bd >> $BUNDLE_FILE
# antibody bundle zsh-users/zaw >> $BUNDLE_FILE
# antibody bundle zsh-users/zsh-autosuggestions >> $BUNDLE_FILE

# Themes
# antibody bundle sindresorhus/pure >> $BUNDLE_FILE
# antibody bundle dfurnes/purer >> $BUNDLE_FILE
# antibody bundle marszall87/lambda-pure >> $BUNDLE_FILE

# Some special packages have to be loaded last
# antibody bundle < "last_bundles.txt" >> $BUNDLE_FILE
antibody bundle zdharma/fast-syntax-highlighting >> $BUNDLE_FILE
antibody bundle zsh-users/zsh-history-substring-search >> $BUNDLE_FILE
