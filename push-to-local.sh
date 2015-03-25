#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# commented out because this takes a few seconds and it's annoying
#git pull origin master;

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "push-to-local.sh" \
		--exclude "update-repo-using-local.sh" --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" --exclude "magnars-emacs-config" \
        --exclude ".lein/self-installs" -avh --no-perms . ~;

    # emacs backup files will go here as per emacs configuration in custom.el
    if [ ! -e ~/.emacs-backups ]; then
                echo "Creating dir ~/.emacs-backups"
        mkdir ~/.emacs-backups
    fi;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
