# My dotfiles for my mac system.

This directory contains the dotfiles for my mac system.
There is dotfiles for:
* ZSH
* GHOSTTY
* NEOVIM
* EMACS (A minimal build for MAC)

## Requirements

Ensure you have the following installed on your system

### Git

```
brew install git
```

### Stow

```
brew install stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone https://github.com/styrman-g/macdots.git
$ cd macdots
```

then use GNU stow to create symlinks

```
$ stow .
```

