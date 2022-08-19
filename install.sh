#!/bin/bash
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/Code/dotfiles
############################

########## Variables

# list of files/folders to symlink in homedir
FILES="vimrc gitconfig gitignore zshrc vim spacemacs"
DIR=~/code/personal/dotfiles
OLDDIR=~/.dotfiles_old
VIMDIR=~/.vim/bundle
GITHUB=https://github.com
TEMPDIR="$TMPDIR/dotfiles"
BACKUP=0

windows() { [[ -n "$WINDIR" ]]; }

link() {
		target=$1
		link=$2
		if windows; then
				link_win=`cygpath -w $link`
				target_win=`cygpath -w $target`
				if [[ -d "$2" ]]; then
						cmd /c mklink /D "$link_win" "$target_win" > /dev/null
				else
						cmd /c mklink "$link_win" "$target_win" > /dev/null
				fi
		else
				# ln's parameters are backwards.
				ln -shf "$target" "$link"
		fi
}

rmlink() {
		if windows; then
				# Windows needs to be told if it's a file or directory.
				if [[ -d "$1" ]]; then
						rmdir "$1";
				else
						rm "$1"
				fi
		else
				rm "$1"
		fi
}

install_vim_package() {
		link=$1
		package=$2
		DIR=`pwd`
		if [ ! -d "$VIMDIR/$package" ]; then
				echo "Cloning $package"
				git clone "$GITHUB/$link" "$VIMDIR/$package" >> "$TEMPDIR/clone_$package"
		else
				cd "$VIMDIR/$package"
				git reset --hard origin/master
				echo "Pulling updates for $package"
				git pull >> "$TEMPDIR/pull_$package"
				cd $DIR
		fi
}


cmdline() {
		for i in "$@"
		do
				case $i in
						-b|--backup)
								BACKUP=1
								shift
								;;
						*)
								;;
				esac
		done
}

BACKUP() {
		echo "BACKUP - $BACKUP"

		if [ $BACKUP ] && [ ! -d "$OLDDIR" ]; then
				echo "Creating $OLDDIR for BACKUP of any existing dotfiles in ~"
				mkdir -p $OLDDIR
				echo "...done"
		fi
}

process() {
		local filename=$1
		cd $DIR
	  if [ -d $filename ]; then
				echo "=== Directory - $filename"
				cp -a $filename/. ~/.$filename/
		else
				if [ $BACKUP ] && [ -e ~/.$filename ]; then
						echo "Moving any existing dotfilenames from ~ to $OLDDIR"
						mv ~/.$filename $OLDDIR
				fi
				echo "=== Filename - $filename"
				if [ -e ~/.$filename ]; then
						echo "~/.$filename exists"
						if [ ! $BACKUP ] && [ ! -L ~/.$filename ]; then
								echo "BACKUP options in not selected and it's not a symlink, so bailing out. re-run with -b option"
								exit 1
						else
								echo "Filename backed up or symlink, so removing it"
								rm ~/.$filename
						fi
				fi
				echo "Creating symlink to $filename in home directory."
				link $DIR/$filename ~/.$filename
		fi
}

# reinstall vim plugins
main() {
		# symlink FILES and directories
		mkdir -p $TEMPDIR
		for filename in $FILES; do
				process $filename
		done

		# install vim packages
		mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
		install_vim_package bling/vim-airline vim-airline
		install_vim_package mhinz/vim-signify vim-signify
		install_vim_package rking/ag.vim ag
		install_vim_package kien/ctrlp.vim.git ctrlp.vim
		install_vim_package sjl/gundo.vim.git gundo
		install_vim_package tpope/vim-fugitive.git vim-fugitive
		install_vim_package airblade/vim-gitgutter.git vim-gitgutter
		install_vim_package rust-lang/rust.vim.git rust.vim
		install_vim_package fatih/vim-go.git vim-go
		install_vim_package Shougo/neocomplete.vim.git neocomplete.vim
		install_vim_package ervandew/supertab.git supertab
		install_vim_package SirVer/ultisnips.git ultisnips
		install_vim_package majutsushi/tagbar.git tagbar

		# install spacemacs if it is missing
#		if [ ! -d ~/.emacs.d ]; then
#				git clone $GITHUB/syl20bnr/spacemacs ~/.emacs.d
#		fi

		echo "Logs available at $TEMPDIR"
}

main
