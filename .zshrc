# vim:ft=zsh ts=2 sw=2 sts=2
#
# stolen from https://www.reddit.com/r/zsh/comments/3qoo6p/zsh_customization/
# Uncomment line below to troubleshoot startup speed issues
# BENCHMARK=1 && zmodload zsh/zprof

files=(
        checks.zsh
        functions.zsh
        setopt.zsh
        exports.zsh
        zgen.zsh
        prompt.zsh
        completion.zsh
        aliases.zsh
        bindkeys.zsh
        history.zsh
        directories.zsh
        colors.zsh
        )

for file in ${files[*]}
do
    [[ -n "$BENCHMARK" ]] && printf "Sourcing %s\n" "$file"
    source "$HOME/.zsh/includes/${file}"
done

if [[ -n "$BENCHMARK" ]] ;
    then zprof > "$HOME/.zsh/.zgen_benchmark"
fi

case $TERM in
    termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
		precmd () { print -Pn "\e]0;Terminal\a" } 
		preexec () { print -Pn "\e]0;$1\a" }
	;;
    screen|screen-256color)
    	precmd () { 
			print -Pn "\e]83;title \"$1\"\a" 
			print -Pn "\e]0;$TERM\a" 
		}
		preexec () { 
			print -Pn "\e]83;title \"$1\"\a" 
			print -Pn "\e]0;$TERM - $1\a" 
		}
	;; 
esac
