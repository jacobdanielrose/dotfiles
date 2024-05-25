# Dotfiles

This directory contains the dotfiles for my setup. This repo allows me to deploy that config to any system relatively easily. 

## Requirements

This setup requires a few programs to be installed. Among them are [tmux plugin manager](https://github.com/tmux-plugins/tpm), [zoxide](https://github.com/ajeetdsouza/zoxide), [neovim](https://neovim.io/), and [fzf](https://github.com/junegunn/fzf). You will also need a [Nerd Font](https://www.nerdfonts.com/). Choose whatever you like, however I chose the 0xProto font. 

This process has been condensed into a setup script that is (moderately) distro agnostic.

## Installation

### Automatic

First, check out the dotfiles repo in your $HOME directory using git

```
git clone git@github.com:jacobdanielrose/dotfiles.git
cd dotfiles
```

Then run the setup script 

```
chmod +x scripts/setup.sh
scripts/setup.sh
```

### Manual
Assuming the script ran without issues, you can then use GNU stow to create symlinks

```
git clone git@github.com:jacobdanielrose/dotfiles.git
cd dotfiles
```
Then you can manually enable stow
```
stow .
```

At this point you will have to restart the terminal or log back in. Zinit should then configure your zsh environment. To use the nvim config, open up nvim (it should be aliased to just vim) and you will see that nvchad then installs automatically and applies the config from this repo. 

## Issues

If you encounter the following on WSL when opening a new terminal
```
compinit:503: no such file or directory: /usr/share/zsh/vendor-completions/_docker
```

then try the solution shown [here](https://github.com/docker/for-win/issues/8336#issuecomment-718369597). It is automatically implemented in the script if you are running it on a WSL-based distro.

I have only tested the install script on Ubuntu, Debian, and Arch. Older versions or other distros may or may not work, your mileage may vary. Feel free to fork this repo and improve the setup script, I created it with my very limited bash skills and a helpful dose of ChatGPT. 
