# vim:ft=zsh ts=2 sw=2 sts=2
#
# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

bindkey "^K"      kill-whole-line                               # ctrl-k
#bindkey "^R"      history-incremental-search-backward           # ctrl-r
bindkey "^A"      beginning-of-line                             # ctrl-a
bindkey "^E"      end-of-line                                   # ctrl-e
bindkey "[B"      history-search-forward                        # down arrow
bindkey "[A"      history-search-backward                       # up arrow
bindkey "^D"      delete-char                                   # ctrl-d
bindkey "^F"      forward-char                                  # ctrl-f
bindkey "^B"      backward-char                                 # ctrl-b
bindkey "^R"      history-incremental-pattern-search-backward   # ctrl-r
bindkey '^W'      backward-kill-word                            # ctrl-w  
#bindkey "^Y"      accept-and-hold                               # ctrl-y
bindkey "^N"      insert-last-word                              # ctrl-n  
#bindkey -v   # Default to standard vi bindings, regardless of editor string
#bindkey "${terminfo[khome]}" beginning-of-line
#bindkey "${terminfo[kend]}" end-of-line

# for rxvt
bindkey "^[[4~" end-of-line
bindkey "^[[1~" beginning-of-line
