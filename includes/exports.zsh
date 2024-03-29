# vim:ft=zsh ts=2 sw=2 sts=2
#
# Currently this path is appended to dynamically when picking a ruby version
# zshenv has already started PATH with rbenv so append only here
export PATH=$PATH~/bin:/usr/local/bin:/usr/local/sbin:~/bin:~/Scripts:~/.local/bin:~/.gem/ruby/2.3.0/bin:~/.gem/ruby/2.5.0/bin:/usr/bin/core_perl:~/go/bin

# Set default console Java
# export JAVA_HOME=/dev/null

# Setup terminal, and turn on colors
#export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Use nvim for manpages
export MANPAGER="nvim +Man! -c ':set signcolumn='"
export MANWIDTH=999

# Enable color in grep
# deprecated !
# export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS='-arch x86_64'

# -i   : ignore case
# -r/R : raw control characters
# -s   : Squeeze multiple blank lines
# -W   : Highlight first new line after any forward movement
# -M   : very verbose prompt
# -PM  : customize the very verbose prompt (there is also -Ps and -Pm)
# ?letterCONTENT. - if test true display CONTENT (the dot ends the test) OR
# ?letterTRUE:FALSE.
# ex: ?L%L lines, . - if number of lines known: display %L lines,
#export LESS='--ignore-case --raw-control-chars'
export LESS='-i -r -s -W -M -PM?f%f - :.?L%L lines, .?ltL\:%lt:.?pB, %pB\% : .?e(Bottom)%t'
export PAGER='less'
export EDITOR='vi'
export VISUAL=$EDITOR
export BROWSER=brave

#export NODE_PATH=/opt/github/homebrew/lib/node_modules
#export PYTHONPATH=/usr/local/lib/python2.6/site-packages
# CTAGS Sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE=C

# Langages
#export LC_COLLATE=fr_FR.UTF-8
export LC_CTYPE=fr_FR.UTF-8
export LC_MESSAGES=fr_FR.UTF-8
export LC_MONETARY=fr_FR.UTF-8
export LC_NUMERIC=fr_FR.UTF-8
export LC_TIME=fr_FR.UTF-8
#export LC_ALL=fr_FR.UTF-8
export LANG=fr_FR.UTF-8
export LANGUAGE=fr_FR.UTF-8
export LESSCHARSET=utf-8

#Virtual Environment Stuff major part stolen from oh-my-zsh venv plugin
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Dev/python

# Not showing end of partial line
export PROMPT_EOL_MARK=''

# Misc
export DOC_BASE=$HOME/Dropbox/Help

virtualenvwrapper='virtualenvwrapper.sh'

if (( $+commands[$virtualenvwrapper] )); then
  function {
    setopt local_options
    unsetopt equals
    source ${${virtualenvwrapper}:c}
  }
elif [[ -f "/etc/bash_completion.d/virtualenvwrapper" ]]; then
  function {
    setopt local_options
    unsetopt equals
    virtualenvwrapper="/etc/bash_completion.d/virtualenvwrapper"
    source "/etc/bash_completion.d/virtualenvwrapper"
  }
elif [[ -f "/usr/bin/virtualenvwrapper.sh" ]]; then
  function {
    setopt local_options
    unsetopt equals
    virtualenvwrapper="/usr/bin/virtualenvwrapper.sh"
  }
fi
# source /usr/bin/virtualenvwrapper.sh

if [[ "$WORKON_HOME" == "" ]]; then
  print "[oh-my-zsh] \$WORKON_HOME is not defined so virtualenvwrapper will not work" >&2
  return
fi

# Default browsers
if [ -n "$DISPLAY"  ]; then
  export BROWSER=/usr/bin/brave
else
  export BROWSER=/usr/bin/w3m
fi

# export CHECKTERM=$(xprop -id "$WINDOWID" WM_CLASS | cut -d" " -f3 | sed 's/^.\(.*\)..$/\1/')
#

# Config of long cmd notification
bgnotify_threshold=4  ## set your own notification threshold

function bgnotify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time
  [ $1 -eq 0 ] && title="FTW!" || title="EPIC FAIL!"
  bgnotify " $title -- after $3 s" "$2";
}

export GPG_TTY=$(tty)

# XDG configuration home
if [[ -z $XDG_CONFIG_HOME ]]
then
  export XDG_CONFIG_HOME=$HOME/.config
fi

# XDG data home
if [[ -z $XDG_DATA_HOME ]]
then
  export XDG_DATA_HOME=$HOME/.local/share
fi

export QT_AUTO_SCREEN_SCALE_FACTOR=0
export VIRTUAL_ENV_DISABLE_PROMPT=0

export ANSIBLE_NOCOWS=1
export GOOGLE_SEARCH_ID='007958786242743939509:hqcwep444ll'
export SEARCH_CSE='cse'
export GOOGLE_API_KEY='AIzaSyBuYWk7duGtDaBYvjAtQx5XXU6bD5R9p-8'

export PRINTER='TOSHIBA_e-STUDIO2555C'

export LF_ICONS="di=📁:\
fi=📃:\
tw=🤝:\
ow=📂:\
ln=⛓:\
or=❌:\
ex=🎯:\
*.txt=✍:\
*.mom=✍:\
*.me=✍:\
*.ms=✍:\
*.png=🖼:\
*.ico=🖼:\
*.jpg=📸:\
*.jpeg=📸:\
*.gif=🖼:\
*.svg=🗺:\
*.xcf=🖌:\
*.html=🌎:\
*.xml=📰:\
*.gpg=🔒:\
*.css=🎨:\
*.pdf=📚:\
*.djvu=📚:\
*.epub=📚:\
*.csv=📓:\
*.xlsx=📓:\
*.tex=📜:\
*.md=📘:\
*.r=📊:\
*.R=📊:\
*.rmd=📊:\
*.Rmd=📊:\
*.mp3=🎵:\
*.opus=🎵:\
*.ogg=🎵:\
*.m4a=🎵:\
*.flac=🎼:\
*.mkv=🎥:\
*.mp4=🎥:\
*.webm=🎥:\
*.mpeg=🎥:\
*.zip=📦:\
*.rar=📦:\
*.7z=📦:\
*.tar.gz=📦:\
*.z64=🎮:\
*.v64=🎮:\
*.n64=🎮:\
*.1=ℹ:\
*.nfo=ℹ:\
*.info=ℹ:\
*.log=📙:\
*.iso=📀:\
*.img=📀:\
*.bib=🎓:\
*.ged=👪:\
*.part=💔:\
*.torrent=🔽:\
"

export KUBECONFIG=~/.kube/config

# Node shit
source /usr/share/nvm/init-nvm.sh
#export npm_config_prefix="$HOME/.local"
