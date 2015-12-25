#!/bin/bash
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/Code/dotfiles
############################

########## Variables

dir=~/Code/dotfiles                    			# dotfiles directory
olddir=~/.dotfiles_old                 			# old dotfiles backup directory
files="vimrc gitconfig bash_profile gitignore"  # list of files/folders to symlink in homedir
vimdir=~/.vim/bundle
github=https://github.com
tempdotfiles="$TMPDIR/dotfiles"

function install_vim_package {
  link=$1
  package=$2
  dir=`pwd`
  if [ ! -d "$vimdir/$package" ]; then
    echo "Cloning $package"
    git clone "$github/$link" "$vimdir/$package" >> "$tempdotfiles/clone_$package"
  else
    cd "$vimdir/$package"
    echo "Pulling updates for $package"
    git pull >> "$tempdotfiles/pull_$package"
    cd $dir
  fi
}

for i in "$@"
do
case $i in
	-b=|--backup)
    backup=1
    shift
    ;;
    *)
    ;;
esac
done

if [ $backup ] && [ ! -d "$olddir" ]; then
	echo "Creating $olddir for backup of any existing dotfiles in ~"
	mkdir -p $olddir
	echo "...done"
fi

echo "Changing to the $dir directory"
mkdir -p $tempdotfiles
cd $dir
for file in $files; do
    if [ $backup ]; then
    	echo "Moving any existing dotfiles from ~ to $olddir"
    	mv ~/.$file $olddir
    fi
    if [ -e ~/.$file ]; then
      echo "~/.$file exists"
      if [ ! $backup ] && [ ! -L ~/.$file ]; then
        echo "Backup options in not selected and it's not a symlink, so bailing out. re-run with -b option"
        exit 1
      else
        echo "File backed up or symlink, so removing it"
        rm ~/.$file
      fi
	    echo "Creating symlink to $file in home directory."
    	ln -s $dir/$file ~/.$file
	 fi
done

# reinstall vim plugins
mkdir -p $vimdir
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

echo "Logs available at $tempdotfiles"
