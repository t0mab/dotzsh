# vim:ft=zsh ts=2 sw=2 sts=2
#
# Executes commands at login post-zshrc.
#

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

if (( $+commands[alsi] )); then
  if [[ -t 0 || -t 1 ]]; then
    if (( $+commands[lolcat] )); then
      alsi|lolcat
    else
      alsi 
    fi
    print
  fi
fi

# Print a random, hopefully interesting, adage.
if (( $+commands[fortune] )); then
  if [[ -t 0 || -t 1 ]]; then
    fortune -s
    print
  fi
fi

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
