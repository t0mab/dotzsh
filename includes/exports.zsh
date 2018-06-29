# vim:ft=zsh ts=2 sw=2 sts=2
#
# Currently this path is appended to dynamically when picking a ruby version
# zshenv has already started PATH with rbenv so append only here
export PATH=$PATH~/bin:/usr/local/bin:/usr/local/sbin:~/bin:~/Scripts:~/.gem/ruby/2.3.0/bin:~/.gem/ruby/2.5.0/bin:/usr/bin/core_perl

# Set default console Java
# export JAVA_HOME=/dev/null

# Setup terminal, and turn on colors
#export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Enable color in grep
export GREP_OPTIONS='--color=auto'
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
export BROWSER=chromium

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
export PROJECT_HOME=$HOME/Dev/django

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
fi

if [[ "$WORKON_HOME" == "" ]]; then
  print "[oh-my-zsh] \$WORKON_HOME is not defined so virtualenvwrapper will not work" >&2
  return
fi

# Default browsers
if [ -n "$DISPLAY"  ]; then
  export BROWSER=/usr/bin/chromium
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
  bgnotify "$title -- after $3 s" "$2";
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
