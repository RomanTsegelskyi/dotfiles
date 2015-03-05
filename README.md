# Roman's dotfiles

## Installation

### Using Git and the install script

I like to keep it in `~/dotfiles`. The install script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/RomanTsegelskyi/dotfiles.git && cd dotfiles && source install.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source install.sh
```

## Currently supported configurations

* VIM (.vimrc + .vim)
* Git (.gitconfig)
* Bash (.bash_profile)
