# vim:ft=zsh ts=2 sw=2 sts=2
#
# stolen from https://www.reddit.com/r/zsh/comments/3qoo6p/zsh_customization/
# Uncomment line below to troubleshoot startup speed issues
# BENCHMARK=1 && zmodload zsh/zprof

#export TERM=xterm-256color
export TERM=rxvt-unicode-256color
# POWERLEVEL9K relative
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='black'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='220'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='204'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='148'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
POWERLEVEL9K_HIDE_BRANCH_ICON=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time background_jobs virtualenv)
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_middle'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=4
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_FOLDER_ICON=""
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='178'
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='black'
POWERLEVEL9K_VIRTUALENV_FOREGROUND='green'
POWERLEVEL9K_VIRTUALENV_BACKGROUND='black'
POWERLEVEL9K_TIME_BACKGROUND='black'
POWERLEVEL9K_TIME_FOREGROUND='green'
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND='015'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='black'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='148'
POWERLEVEL9K_SHOW_CHANGESET=true


files=(
        checks.zsh
        functions.zsh
        setopt.zsh
        exports.zsh
        zgen.zsh
        #prompt.zsh
        completion.zsh
        aliases.zsh
        bindkeys.zsh
        history.zsh
        directories.zsh
        colors.zsh
        fzf.zsh
        )

for file in ${files[*]}
do
    [[ -n "$BENCHMARK" ]] && printf "Sourcing %s\n" "$file"
    source "$HOME/.zsh/includes/${file}"
done

if [[ -n "$BENCHMARK" ]] ;
    then zprof > "$HOME/.zsh/.zgen_benchmark"
fi
source /usr/share/autoenv/activate.sh

#zgen load bhilburn/powerlevel9k powerlevel9k
zstyle ':notify:*' error-title "#fail background cmd"
zstyle ':notify:*' success-title "#success background cmd"
