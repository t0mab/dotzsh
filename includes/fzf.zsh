
# fzf support (need fzf)
#
if [[ ! "$PATH" == */usr/bin/fzf* ]]; then
  export PATH="$PATH:/usr/bin/fzf"
fi

# Auto-completion
[[ $- == *i* ]] && source "/usr/share/fzf/completion.zsh" 2> /dev/null

# Key bindings
source "/usr/share/fzf/key-bindings.zsh"

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -S --hidden --ignore=.git --ignore=.svn --ignore=.hg -g ""'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_fzf_compgen_path() {
  ag -g "" "$1"
}
