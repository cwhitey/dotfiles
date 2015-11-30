#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# commented out because this takes a few seconds and it's annoying
#git pull origin master;

function strap() {
    #rsync stuff
    rsync --exclude "README.md" --exclude ".git" --exclude ".gitignore" --exclude ".DS_Store" --exclude "bootstrap.sh" \
          --exclude "LICENSE-MIT.txt" --exclude "old-emacs-configs" --exclude "do-not-use" --exclude "emacs-prelude" \
          --exclude "purcell" --exclude ".lein/self-installs" -avh --no-perms . ~;

    #rsync prelude to .emacs.d
    rsync -avh --no-perms emacs-prelude/ ~/.emacs.d;

    # emacs backup files will go here as per emacs configuration in custom.el
    #if [ ! -e ~/.emacs-backups ]; then
    #            echo "Creating dir ~/.emacs-backups"
    #    mkdir ~/.emacs-backups
    #fi;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	strap;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		strap;
	fi;
fi;
unset strap;
