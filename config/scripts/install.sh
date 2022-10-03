#!/bin/bash

sudo apt-get install -y tmux zsh subversion vim-gtk

# vim setup script
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
svn export "https://github.com/chriskempson/tomorrow-theme.git/trunk/vim/colors/" ~/.vim/colors
# in vim, :PulginInstall :PluginList shift + D to delete ; PluginSearch then i to install that plugin


#i3 setup script 
#ln -s ~/BACKUP/dotfiles/i3/config ~/.config/i3/config

# tmux setup script
git clone https://github.com/gpakosz/.tmux ~/.tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# in tmux , :source-file ~/.tmux.conf

# for traystart in i3 config
#ln -s /home/username/BACKUP/dotfiles/scripts/traystart ~/.local/bin/traystart

# zsh setup script
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed  's/exec zsh -l//g')"
source ~/.zshrc
