# vim:ft=zsh ts=2 sw=2 sts=2
#
# HISTORY

HISTSIZE=10000
SAVEHIST=9000
HISTFILE=~/.zsh_history

autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "\e[A" history-beginning-search-backward-end
bindkey "\e[B" history-beginning-search-forward-end


