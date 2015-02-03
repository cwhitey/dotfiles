#!/bin/bash

rsync -av ~/.emacs.d/ .emacs.d
rsync --exclude "self-installs" -av ~/.lein/ .lein
rsync ~/.zshrc .
