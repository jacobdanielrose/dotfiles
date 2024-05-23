# Dotfiles

This directory contains the dotfiles for my system

## Requirements

### zsh
First make sure that you have `zsh` installed on your system. If it's not the default then run:

```
sudo apt-get install zsh
```
Then change the default shell to `zsh`

```
chsh <your user>
```
Then enter the path of the `zsh` binary. If you don't know where it is then run `which zsh`.


Then ensure you have the following installed on your system

### Git

```
sudo apt-get install git
```

### Stow

```
sudo apt-get install stow
```

### fzf

Unfortunately the default version that ships in the Ubuntu/Debian repos doesn't contain the `--zsh` flag, so in this case you can install the binary directly.

```
wget -c https://github.com/junegunn/fzf/releases/download/0.52.1/fzf-0.52.1-linux_amd64.tar.gz -O - | tar -xz ; sudo mv fzf /usr/local/bin/
```

### Neovim

```
sudo apt-get install neovim
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
git clone git@github.com:jacobdanielrose/dotfiles.git
cd dotfiles
```

then use GNU stow to create symlinks

```
stow .
```
