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

function install_vim_package {
  package=$1
  folder=$2
  if [ ! -d "$vimdir/$folder" ]; then
    git clone "$github/$package" "$vimdir/$folder"
  fi
}

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# reinstall vim plugins
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
