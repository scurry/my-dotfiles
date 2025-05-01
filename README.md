# My Dotfiles

This repository contains my personal dotfiles, which are configuration files for various tools and environments. Below is a brief description of each file included in this project:

## Files

- **.bashrc**: This file contains shell commands that are executed when a new terminal session is started. It is used to set environment variables and configure the shell environment.

- **.vimrc**: This file is the configuration file for Vim. It includes settings and preferences for the Vim text editor, such as key mappings and plugin configurations.

- **.gitconfig**: This file is the configuration file for Git. It contains user-specific settings for Git, including user name, email, and aliases for Git commands.

## Setup Instructions

To use these dotfiles, you can follow these steps:

1. Clone this repository to your home directory:
   ```
   git clone https://github.com/yourusername/my-dotfiles.git ~/.dotfiles
   ```

2. Create symbolic links for each dotfile:
   ```
   ln -sf ~/.dotfiles/.bashrc ~/.bashrc
   ln -sf ~/.dotfiles/.vimrc ~/.vimrc
   ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
   ```

3. Reload your terminal or source your `.bashrc` file:
   ```
   source ~/.bashrc
   ```

Feel free to customize these files to suit your preferences!


For testing this on a container:

1. Ensure container has SSH installed and a key
   1. `ssh-keygen -t ed25519 -C "your_email@example.com"`
1. Make sure git is installed `sudo apt install git`
1. Make sure github has the ssh key or upload if not
1. need url to call bootstrap directly:`curl -fsSL https://raw.githubusercontent.com/scurry/my-dotfiles/main/script/bootstrap | bash`

