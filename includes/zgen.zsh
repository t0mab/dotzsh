# load zgen
source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen load zsh-users/zsh-syntax-highlighting
    zgen oh-my-zsh plugins/sudo
    zgen load unixorn/autoupdate-zgen
    zgen oh-my-zsh plugins/tmux

    # OS specific plugins
    if [[ $CURRENT_OS == 'OSX' ]]; then
        zgen oh-my-zsh plugins/brew
        zgen oh-my-zsh plugins/brew-cask
        zgen oh-my-zsh plugins/pip
        zgen oh-my-zsh plugins/python
        zgen oh-my-zsh plugins/virtualenv
        zgen oh-my-zsh plugins/perl
        zgen oh-my-zsh plugins/rbenv
        zgen oh-my-zsh plugins/jsontools
        zgen oh-my-zsh plugins/urltools
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/ssh-agent
        zgen oh-my-zsh plugins/vagrant

    elif [[ $CURRENT_OS == 'Linux' ]]; then
        zgen oh-my-zsh plugins/pip
        zgen oh-my-zsh plugins/python
        zgen oh-my-zsh plugins/virtualenv
        zgen oh-my-zsh plugins/perl
        zgen oh-my-zsh plugins/vagrant
        zgen oh-my-zsh plugins/ssh-agent

        if [[ $DISTRO == 'CentOS' ]]; then
            zgen oh-my-zsh centos
        fi

    elif [[ $CURRENT_OS == 'Cygwin' ]]; then
        zgen oh-my-zsh cygwin
    fi

    # completion-only repositories. Add optional path argument to specify
    # what subdirectory of the repository to add to your fpath.
    zgen load zsh-users/zsh-completions src

    # save all to init script
    zgen save
fi
