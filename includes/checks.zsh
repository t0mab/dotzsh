# vim:ft=zsh ts=2 sw=2 sts=2
#
# os.zsh (stolen from zshuery)

CURRENT_OS=$(uname)

if [[ $(uname) = 'Linux' ]]; then
    IS_LINUX=1
fi

if [[ $(uname) = 'Darwin' ]]; then
    IS_MAC=1
fi

if [[ -x `which brew` ]]; then
    HAS_BREW=1
fi

if [[ -x `which apt-get` ]]; then
    HAS_APT=1
fi

if [[ -x `which yum` ]]; then
    HAS_YUM=1
fi

if [[ -x `which yaourt` ]]; then
    HAS_YAOURT=1
fi
