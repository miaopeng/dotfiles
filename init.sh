#!/usr/bin/env bash

function doIt() {
	# rsync --exclude ".git/" --exclude ".DS_Store" --exclude "init.sh" \
		# --exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms ./zshrc ~/zshrc;
	ln -s ~/github/dotfiles/ackrc ~/.ackrc
	ln -s ~/github/dotfiles/zshrc ~/.zshrc
	ln -s ~/github/dotfiles/pryrc ~/.pryrc
	ln -s ~/github/dotfiles/jshint/jshintrc ~/.jshintrc
	ln -s ~/github/dotfiles/jsbeautify/jsbeautifyrc ~/.jsbeautifyrc
	ln -s ~/github/dotfiles/jsbeautify/cssbeautifyrc ~/.cssbeautifyrc
	ln -s ~/github/dotfiles/jsbeautify/htmlbeautifyrc ~/.htmlbeautifyrc
}

# if [ "$1" == "--force" -o "$1" == "-f" ]; then
	# doIt;
# else
	# read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	# echo "";
	# if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	# fi;
# fi;
unset doIt;
