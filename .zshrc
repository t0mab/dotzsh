# vim:ft=zsh ts=2 sw=2 sts=2
#
# stolen from https://www.reddit.com/r/zsh/comments/3qoo6p/zsh_customization/
# Uncomment line below to troubleshoot startup speed issues
# BENCHMARK=1 && zmodload zsh/zprof

files=(
        checks.zsh
        colors.zsh
        setopt.zsh
        exports.zsh
        zgen.zsh
        prompt.zsh
        completion.zsh
        aliases.zsh
        bindkeys.zsh
        functions.zsh
        history.zsh
        directories.zsh
        )

for file in ${files[*]}
do
    [[ -n "$BENCHMARK" ]] && printf "Sourcing %s\n" "$file"
    source "$HOME/.zsh/includes/${file}"
done

if [[ -n "$BENCHMARK" ]] ;
    then zprof > "$HOME/.zsh/.zgen_benchmark"
fi
