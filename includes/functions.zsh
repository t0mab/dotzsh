# vim:ft=zsh ts=2 sw=2 sts=2

# -------------------------------------------------------------------
# compressed file expander
# (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# -------------------------------------------------------------------

function ex() {
    if [[ -f $1 ]]; then
        case $1 in
          *.tar.bz2) tar xvjf $1;;
          *.tar.gz) tar xvzf $1;;
          *.tar.xz) tar xvJf $1;;
          *.tar.lzma) tar --lzma xvf $1;;
          *.bz2) bunzip $1;;
          *.rar) unrar $1;;
          *.gz) gunzip $1;;
          *.tar) tar xvf $1;;
          *.tbz2) tar xvjf $1;;
          *.tgz) tar xvzf $1;;
          *.zip) unzip $1;;
          *.Z) uncompress $1;;
          *.7z) 7z x $1;;
          *.dmg) hdiutul mount $1;; # mount OS X disk images
          *) echo "'$1' cannot be extracted via >ex<";;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -------------------------------------------------------------------
# any function from http://onethingwell.org/post/14669173541/any
# search for running processes
# -------------------------------------------------------------------
function any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

# -------------------------------------------------------------------
# display a neatly formatted path
# -------------------------------------------------------------------
function path() {
    echo $PATH | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
            sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
            sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
            sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
            sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
            print }"
}

# -------------------------------------------------------------------
# Mac specific functions
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then

    # view man pages in Preview
    function pman() { ps=`mktemp -t manpageXXXX`.ps ; man -t $@ > "$ps" ; open "$ps" ; }
fi

# -------------------------------------------------------------------
# nice mount (http://catonmat.net/blog/another-ten-one-liners-from-commandlingfu-explained)
# displays mounted drive information in a nicely formatted manner
# -------------------------------------------------------------------
function nicemount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2="";1') | column -t ; }

# -------------------------------------------------------------------
# myIP address
# -------------------------------------------------------------------
function myip() {
    ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
    ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig eno0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "eno0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig eno0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "eno0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig eno1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "eno1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig eno1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "eno1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

# -------------------------------------------------------------------
# (s)ave or (i)nsert a directory.
# -------------------------------------------------------------------
function s() { pwd > ~/.save_dir ; }
function i() { cd "$(cat ~/.save_dir)" ; }

# tm - Tmux tool
tm()
{
    if [ "$1" ];
    then
        tmux att -t $1 || tmux new -s $1
    else
        tmux ls | sed 's/:.*//'
    return
    fi
}

# tms - select tmux session with fzf
tms() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

# -------------------------------------------------------------------
# htpasswd without htpasswd
# -------------------------------------------------------------------
function nohtpasswd()
{
    [ ! $# -eq 2 ] && { echo -e "Usage: nohtpasswd file_name user"; return 1; }
    echo "password:"
    read -s password
    echo -e "$2:`perl -le 'print crypt($password,"salt")'`" >> $1
}

# -------------------------------------------------------------------
# remove  ^M car from files
# usage: removem /path/to/dir
# -------------------------------------------------------------------
function removem()
{
    for file in $(find $1 -type f); do
        tr -d '\r' <$file >temp.$$ && mv temp.$$ $file
    done

}

# -------------------------------------------------------------------
# upgrade calibre
# -------------------------------------------------------------------
function calibre_upgrade()
{
    sudo python -c "import sys; py3 = sys.version_info[0] > 2; u = __import__('urllib.request' if py3 else 'urllib', fromlist=1); exec(u.urlopen('http://status.calibre-ebook.com/linux_installer').read()); main(install_dir='~/bin')"
}

# -------------------------------------------------------------------
# mkdir and cd to new dir
# -------------------------------------------------------------------
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# -------------------------------------------------------------------
# random commit msg
# -------------------------------------------------------------------
function gitrandomc() {
    git commit -m"`curl -s http://whatthecommit.com/index.txt`"
}

# -------------------------------------------------------------------
# git retag
# -------------------------------------------------------------------
function gitretag() {
    git tag -d $1 && git push --delete origin $1 && git tag $1 && git push --tags
}

# -------------------------------------------------------------------
#
# -------------------------------------------------------------------
function gitworkdone(){
    default="1 day ago"
        git log --committer=$1 --pretty=format:"%Cgreen%ar (%h)%n%Creset> %s %b%n" --since="${2:-$default}" --no-merges
}

# -------------------------------------------------------------------
# inits project for django-drybone project
# see https://github.com/unistra/django-drybones
# Usage initproject project_name [ -p python_version -d django_version]
# example initproject -p 3 -d 1.8.4
# -------------------------------------------------------------------
function initproject () {

    # TODO: be sure those variables are required by vitualenv* stuff

    declare -g PYTHON_VERSION=${PYTHON_VERSION:=3.4}
    declare -g PYTHON_PATH=
    declare -g PYTHON_VERSION_PATH=$( which python$PYTHON_VERSION )

    # TODO: split this message up: make it readable

    test -z $1 && {
            echo -e "Missing argument. Script usage:\n" "   initproject project_name [ -p python_version -d django_version]" "   example : initproject -p 3 -d 1.8.4 "
            return 1
    }

    local PROJECT_NAME=$1
    local DJANGO_VERSION=${DJANGO_VERSION:=Django>1.8,<1.9}

    local ARGS=`getopt --long -o "p:d:" "$@"`
    eval set -- "$ARGS"
    while true
    do
            case "$1" in
                    (-p) PYTHON_VERSION=$2
                            shift 2 ;;
                    (-d) DJANGO_VERSION=Django==$2
                            shift 2 ;;
                    (*) break ;;
            esac
    done

    mkvirtualenv $PROJECT_NAME -p "$PYTHON_VERSION_PATH"
    workon $PROJECT_NAME
    test -n ${VIRTUAL_ENV-} || {
        echo no env, no gain >&2
        return 1
    }

    pip install "$DJANGO_VERSION"


    django-admin startproject --template=https://github.com/unistra/django-drybones/archive/django2.2.zip --extension=html,rst,ini,coveragerc --name=Makefile $PROJECT_NAME
    #django-admin startproject --template=https://github.com/unistra/django-drybones/archive/master.zip --extension=html,rst,ini,coveragerc --name=Makefile $PROJECT_NAME
    cd $PROJECT_NAME
    setvirtualenvproject $VIRTUAL_ENV $PWD
    echo "export DJANGO_SETTINGS_MODULE=$PROJECT_NAME.settings.dev" >> $VIRTUAL_ENV/bin/postactivate
    echo "unset DJANGO_SETTINGS_MODULE" >> $VIRTUAL_ENV/bin/postdeactivate
    workon $PROJECT_NAME
    chmod +x manage.py
    pip install -r requirements/dev.txt
}

# -------------------------------------------------------------------
# download entire website
# -------------------------------------------------------------------
function getsite() {
    wget --random-wait -r -p -e robots=off -U mozilla $1
}

# -------------------------------------------------------------------
# ssh via home
# -------------------------------------------------------------------
function tssh() {
    ssh -t $1 ssh $2
}

# -------------------------------------------------------------------
# copy && follow
# -------------------------------------------------------------------
function cpf() {
    cp "$@" && goto "$_";
}

# -------------------------------------------------------------------
# move && follow
# -------------------------------------------------------------------
function mvf() {
    mv "$@" && goto "$_";
}

# -------------------------------------------------------------------
# mkdir && follow
# -------------------------------------------------------------------
function mkdirf() {
    mkdir -vp "$@" && cd "$_";
}

# -------------------------------------------------------------------
# colorized man pages
# -------------------------------------------------------------------
function man() {
    env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# -------------------------------------------------------------------
# colored find
# NOTE: searches current tree recrusively.
# -------------------------------------------------------------------
function f() {
    find . -iregex ".*$@.*" -printf '%P\0' | xargs -r0 ls --color=auto -1d
}

# fif - find in file usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# -------------------------------------------------------------------
# create tar archive
# -------------------------------------------------------------------
function mktar() {
    tar cvf  "${1%%/}.tar" "${1%%/}/";
}

# -------------------------------------------------------------------
# create tar.gz archive
# -------------------------------------------------------------------
function mktgz() {
    tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
}

# -------------------------------------------------------------------
# create tar.bz2 archive
# -------------------------------------------------------------------
function mktbz() {
    tar cvjf "${1%%/}.tar.bz2" "${1%%/}/";
}

# -------------------------------------------------------------------
# print mkv information
# -------------------------------------------------------------------
function mkv() {
    [[ -n "$@" ]] || {
      echo "usage : mkv [file]"
      return
    }
    mkvmerge -i "$@"
}

# -------------------------------------------------------------------
# remux MKV to use only 1 audio && subtible track
# -------------------------------------------------------------------
function remux() {
    [[ -n "$1" ]] && [[ -n "$2" ]] && [[ -n "$3" ]] && [[ -n "$4" ]] || {
      echo "usage : remux [output] [input] [audio track to keep] [subtible track to keep]"
      return
    }
    mkvmerge -o "$1" -d 1 --audio-tracks "$3" --subtitle-tracks "$4" "$2"
}

# -------------------------------------------------------------------
# batch whole directory with this
# -------------------------------------------------------------------
function bremux() {
    local FILTER="*.mkv"
    [[ -n "$1" ]] && [[ -n "$2" ]] || {
        echo "usage : bremux [audio track] [subtible track] [filter]"
        return
    }
        [[ -n "$3" ]] && FILTER="$3"
        for i in $FILTER; do
            remux "[REMUX]$i" "$i" "$1" "$2"
        done
}

# -------------------------------------------------------------------
# this function checks if a command exists and returns either true
# or false. This avoids using 'which' and 'whence', which will
# avoid problems with aliases for which on certain weird systems. :-)
# Usage: check_com [-c|-g] word
#   -c  only checks for external commands
#   -g  does the usual tests and also checks for global aliases
# -------------------------------------------------------------------
function check_com() {
    emulate -L zsh
    local -i comonly gatoo

    if [[ $1 == '-c' ]] ; then
        (( comonly = 1 ))
        shift
    elif [[ $1 == '-g' ]] ; then
        (( gatoo = 1 ))
    else
        (( comonly = 0 ))
        (( gatoo = 0 ))
    fi

    if (( ${#argv} != 1 )) ; then
        printf 'usage: check_com [-c] <command>\n' >&2
        return 1
    fi

    if (( comonly > 0 )) ; then
        [[ -n ${commands[$1]}  ]] && return 0
        return 1
    fi

    if   [[ -n ${commands[$1]}    ]] \
      || [[ -n ${functions[$1]}   ]] \
      || [[ -n ${aliases[$1]}     ]] \
      || [[ -n ${reswords[(r)$1]} ]] ; then

        return 0
    fi

    if (( gatoo > 0 )) && [[ -n ${galiases[$1]} ]] ; then
        return 0
    fi

    return 1
}

# -------------------------------------------------------------------
# Start ssh-agent
# -------------------------------------------------------------------
function start-ssh-agent {
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > $SSH_ENV
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    /usr/bin/ssh-add
}

# -------------------------------------------------------------------
# Change file extensions recursively in current directory
#   change-extension php py
# -------------------------------------------------------------------
function change-extension() {
    foreach f (**/*.$1)
    mv $f $f:r.$2
    end
}

# -------------------------------------------------------------------
# Display git stats per author
#
# awesome work from https://github.com/esc/git-stats
# including some modifications
# -------------------------------------------------------------------
function git_stats {
    if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
        echo "Number of commits per author:"
        git --no-pager shortlog -sn --all
        AUTHORS=$( git shortlog -sn --all | cut -f2 | cut -f1 -d' ')
        LOGOPTS=""
        if [ "$1" == '-w' ]; then
            LOGOPTS="$LOGOPTS -w"
            shift
        fi
        if [ "$1" == '-M' ]; then
            LOGOPTS="$LOGOPTS -M"
            shift
        fi
        if [ "$1" == '-C' ]; then
            LOGOPTS="$LOGOPTS -C --find-copies-harder"
            shift
        fi
        for a in $AUTHORS
        do
            echo '-------------------'
            echo "Statistics for: $a"
            echo -n "Number of files changed: "
            git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f3 | sort -iu | wc -l
            echo -n "Number of lines added: "
            git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f1 | awk '{s+=$1} END {print s}'
            echo -n "Number of lines deleted: "
            git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f2 | awk '{s+=$1} END {print s}'
            echo -n "Number of merges: "
            git log $LOGOPTS --all --merges --author=$a | grep -c '^commit'
        done
    else
        echo "you're currently not in a git repository"
    fi
}

# -------------------------------------------------------------------
# Get a quick overview for your git repo
#
# -------------------------------------------------------------------
function git_info() {
    if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
        # print informations
        echo "git repo overview"
        echo "-----------------"
        echo

        # print all remotes and thier details
        for remote in $(git remote show); do
            echo $remote:
            git remote show $remote
            echo
        done

        # print status of working repo
        echo "status:"
        if [ -n "$(git status -s 2> /dev/null)" ]; then
            git status -s
        else
            echo "working directory is clean"
        fi

        # print at least 5 last log entries
        echo
        echo "log:"
        git log -5 --oneline
        echo

    else
        echo "you're currently not in a git repository"

    fi
}

search() {
    find . -name "*$1*"
}

searchreplace () {
    find proj -name "$1" -type f -exec sed -i -e "s/$2/$3/g" -- {} +
}

alarm() {
    local N=$1; shift

    (sleep $(( $(date --date="$N" +%s) - $(date +%s) )) && notify-send -u critical -i "/usr/share/icons/Paper/48x48/categories/preferences-system-time.svg" "Timer" "$@" && beep -l 50 -r 4 ) &
    echo "timer set for $N"
}

reminder() { ## 2021-05-30
  echo "DISPLAY=:0.0 notify-send \
    -t 300000 'Reminder' '$2'" | \
      at -M "$1" 2>/dev/null
} #note

convertmpeg2mov() {
    for i in *.MP4;
    do name=`echo $i | cut -d'.' -f1`;
    echo $name;
    ffmpeg -i $i -sameq -vcodec mpeg4 $name.mov;
    done
}

convert169() {
    ffmpeg -i $1 -sameq -vcodec mpeg4 -acodec ac3 -aspect 16:9 -strict experimental 16-9-$1 Raw
}

# -------------------------------------------------------------------
# Send mail using mutt
#
# -------------------------------------------------------------------
email() {
  echo $3 | mutt -s $2 $1
}

# -------------------------------------------------------------------
# Find broken symbolic links
#
# -------------------------------------------------------------------
function findbrokenln() {
    find ./ -type l -exec file {} \; |grep broken
}

# -------------------------------------------------------------------
# Zoom fonts in urxvt terminal
#
# -------------------------------------------------------------------
zoom() {
    printf '\33]50;%s\007' "xft:Monaco for Powerline:size=$1:antialias=true"
}

# -------------------------------------------------------------------
# Fix virtualenv after python upgrade
#
# -------------------------------------------------------------------
fixVenv() {
ENV_PATH="$(dirname "$(dirname "$(which pip)")")"
SYSTEM_VIRTUALENV="$(which -a virtualenv|tail -1)"

echo "Ensure the root of current virtualenv:"
echo "    $ENV_PATH"
read -p "‼️  Say no if you are not sure (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "♻️  Removing old symbolic links......"
    find "$ENV_PATH" -type l -delete -print
    echo "💫  Creating new symbolic links......"
    $SYSTEM_VIRTUALENV "$ENV_PATH"
    echo "🎉  Done!"
  fi
}

# -------------------------------------------------------------------
# Zoom in (zp) and out (zm) in urxvt term
#
# -------------------------------------------------------------------
URXVT_SIZE=20
URXVT_PROGRESS_SIZE=5

zp() {
    URXVT_SIZE=$(echo "$URXVT_SIZE+$URXVT_PROGRESS_SIZE" | bc )
    zoom $URXVT_SIZE
}

zm() {
    URXVT_SIZE=$(echo "$URXVT_SIZE-$URXVT_PROGRESS_SIZE" | bc )
    zoom $URXVT_SIZE
}


# -------------------------------------------------------------------
# Zoom in (zp) and out (zm) in urxvt term
#
# -------------------------------------------------------------------
sprite_sf() {
    sprite_sf=( $HOME/Dev/misc/sprites_sf/*.txt  ) ; cat "${sprite_sf[RANDOM % ${#sprite_sf[@]}]}"
}

# -------------------------------------------------------------------
# Dl several files using youtube-dl
#
# -------------------------------------------------------------------
multidl() {
    cat $1 | parallel -j30 --retries 10 --bar youtube-dl {}
}

# archmaj - update arch
archmaj() {
    # get news from archlinux fr
    curl https://archlinux.fr/feed -s|awk '/<title>/ {z=substr($0,10,length($0)-17)} /<pubDate>/ {print z "||" $2" " $3 " " $4} '
    # deactivate virtualenv
    python -c 'import sys; print (sys.real_prefix)' 2>/dev/null && deactivate
    #yaourt -Syua
    yay -Pw                             # print news if any
    yay -Syu --devel --noconfirm        # update repo and AUR packages, including -git packages
    sudo fwupdmgr refresh               # get firmware updates
    sudo fwupdmgr update                # install/schedule boot firmware updates if any
}

# yzf - Helper function to integrate yay and fzf
yzf() {
  pos=$1
  shift
  sed "s/ /\t/g" |
    fzf --nth=$pos --multi --history="${FZF_HISTDIR:-$XDG_STATE_HOME/fzf}/history-yzf$pos" \
      --preview-window=60%,border-left \
      --bind="double-click:execute(xdg-open 'https://archlinux.org/packages/{$pos}'),alt-enter:execute(xdg-open 'https://aur.archlinux.org/packages?K={$pos}&SB=p&SO=d&PP=100')" \
      "$@" | cut -f$pos | xargs
}

# Dev note: print -s adds a shell history entry

# List installable packages into fzf and install selection
yas() {
  cache_dir="/tmp/yas-$USER"
  test "$1" = "-y" && rm -rf "$cache_dir" && shift
  mkdir -p "$cache_dir"
  preview_cache="$cache_dir/preview_{2}"
  list_cache="$cache_dir/list"
  { test "$(cat "$list_cache$@" | wc -l)" -lt 50000 && rm "$list_cache$@"; } 2>/dev/null
  pkg=$( (cat "$list_cache$@" 2>/dev/null || { pacman --color=always -Sl "$@"; yay --color=always -Sl aur "$@" } | sed 's/ [^ ]*unknown-version[^ ]*//' | tee "$list_cache$@") |
    yzf 2 --tiebreak=index --preview="cat $preview_cache 2>/dev/null | grep -v 'Querying' | grep . || yay --color always -Si {2} | tee $preview_cache")
  if test -n "$pkg"
    then echo "Installing $pkg..."
      cmd="yay -S $pkg"
      print -s "$cmd"
      eval "$cmd"
      rehash
  fi
}
# List installed packages into fzf and remove selection
# Tip: use -e to list only explicitly installed packages
yar() {
  pkg=$(yay --color=always -Q "$@" | yzf 1 --tiebreak=length --preview="yay --color always -Qli {1}")
  if test -n "$pkg"
    then echo "Removing $pkg..."
      cmd="yay -R --cascade --recursive $pkg"
      print -s "$cmd"
      eval "$cmd"
  fi
}

# -------------------------------------------------------------------
# visual cp
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed
#
# Usage:
#   cpv file_or_dir_src file_or_dir_dst
#
# -------------------------------------------------------------------
function cpv()
{
  local DST=${@: -1}                    # last element
  local SRC=( ${@: 1 : $# - 1} )        # array with rest of elements

  # checks
  type pv &>/dev/null || { echo "install pv first"; return 1; }
  [ $# -lt 2  ]       && { echo "too few args"    ; return 1; }

  # special invocation
  function cpv_rename()
  {
    local SRC="$1"
    local DST="$2"
    local DSTDIR="$( dirname "$DST" )"

    # checks
    if   [ $# -ne 2     ]; then echo "too few args"          ; return 1; fi
    if ! [ -e "$SRC"    ]; then echo "$SRC doesn't exist"    ; return 1; fi
    if   [ -d "$SRC"    ]; then echo "$SRC is a dir"         ; return 1; fi
    if ! [ -d "$DSTDIR" ]; then echo "$DSTDIR does not exist"; return 1; fi

    # actual copy
    echo -e "\n$SRC 🡺  $DST"
    pv   "$SRC" >"$DST"
  }

  # special case for cpv_rename()
  if ! [ -d "$DST" ]; then cpv_rename "$@"; return $?; fi;

  # more checks
  for src in "${SRC[@]}"; do
    local dst="$DST/$( basename "$src" )"
    if ! [ -e "$src" ]; then echo "$src doesn't exist" ; return 1;
    elif [ -e "$dst" ]; then echo "$dst already exists"; return 1; fi
  done

  # actual copy
  for src in "${SRC[@]}"; do
    if ! [ -d "$src" ]; then
      local dst="$DST/$( basename "$src" )"
      echo -e "\n$src 🡺  $dst"
      pv "$src" > "$dst"
    else
      local dir="$DST/$( basename "$src" )"
      mkdir "$dir" || continue
      local srcs=( $src/* )
      cpv "${srcs[@]}" "$dir";
    fi
  done
  unset cpv_rename
}

# -------------------------------------------------------------------
# add execute right on stuff
# -------------------------------------------------------------------
function x()
{
  chmod u+x -- $@
}

# -------------------------------------------------------------------
# Search for help topics in my personal documentation
# steal from https://github.com/kurkale6ka
# Usage: doc topic
# -------------------------------------------------------------------
function doc()
{
    (($# == 0)) && return 1

    case $1 in
        (rg|regex) cat $DOC_BASE/regex.txt; return ;;
        (pf|printf)     $DOC_BASE/printf.sh; return ;;
        (sort) cat $DOC_BASE/sort.txt;  return ;;
    esac

    typeset -a matches

    while read -r
    do
        matches+=($REPLY)
    done < <(\ag -l -S --hidden --ignore .git --ignore .svn --ignore .hg --ignore misc --ignore '*install*' --ignore 'README*' --ignore 'LICENSE' $1 $DOC_BASE)

    # For a single match, open the help file
    if (( ${#matches} == 1 ))
    then
        # TODO: send to running nvim
        vi $matches -c"0/$1" -c'noh|norm zv<cr>'
    elif (( ${#matches} > 1 ))
    then
        ag $1 $matches
    fi
}

# -------------------------------------------------------------------
# Check archlinux updates both aur and repos packages
# -------------------------------------------------------------------

get_updates()
{
  Updates=$(yay -Qu | wc -l)
  if [ $Updates -eq 0 ] #Solid Green
  then
    echo "\e[92m$Updates\e[0m"
    return
  fi
  if [ $Updates -ge 10 ] #Red Blink
  then
    echo "\e[91m\e[5m$Updates\e[0m"
    return
  fi
  if [ $Updates -ge 5 ] #Yellow Blink
  then
    printf "\e[93m\e[5m$Updates\e[0m" "$Updates"
          return
  fi
  if [ $Updates -ge 1 ] #Blink Green.
  then
    echo "\e[92m\e[5m$Updates\e[0m"
    return
  fi
}

# -------------------------------------------------------------------
# Local network scan
# -------------------------------------------------------------------

nmap_local_scan()
{
  nmap -Ap 80,8000,8080,443,8443,7443,7070,7000,22,23,21 10.5.1.0/24 192.168.0.0/24 192.168.1.0/24
}

localhost_get()
{
curl -H "Access-Control-Request-Method: GET" -H "Origin: http://localhost" --head $1
}

# -------------------------------------------------------------------
# Systemd relatives functions
# -------------------------------------------------------------------

# systemlevel
start() { sudo systemctl start "$1"; }
stop() { sudo systemctl stop "$1"; }
restart() { sudo systemctl restart "$1"; }
status() { sudo systemctl status "$1"; }
enabled() { sudo systemctl enable "$1"; listd; }
disabled() { sudo systemctl disable "$1"; listd; }

# userlevel
ustart() { systemctl --user start "$1"; }
ustop() { systemctl --user stop "$1"; }
ustatus() { systemctl --user status "$1"; }
uenabled() { systemctl --user enable "$1"; }
udisabled() { systemctl --user disable "$1"; }

# cpu
cpufreq() { watch -n 5 "lscpu | grep MHz"; }

# jq
#
jsondiff() {
diff <(jq -S . $1) <(jq -S . $2)

}

# initprojet2 -
# TODO: check if still usefull
function initproject2 () {

    # TODO: be sure those variables are required by vitualenv* stuff

    declare -g PYTHON_VERSION=${PYTHON_VERSION:=3.4}
    declare -g PYTHON_PATH=
    declare -g PYTHON_VERSION_PATH=$( which python$PYTHON_VERSION )

    # TODO: split this message up: make it readable

    test -z $1 && {
            echo -e "Missing argument. Script usage:\n" "   initproject project_name [ -p python_version -d django_version]" "   example : initproject -p 3 -d 1.8.4 "
            return 1
    }

    local PROJECT_NAME=$1
    local DJANGO_VERSION=${DJANGO_VERSION:=Django>1.8,<1.9}

    local ARGS=`getopt --long -o "p:d:" "$@"`
    eval set -- "$ARGS"
    while true
    do
            case "$1" in
                    (-p) PYTHON_VERSION=$2
                            shift 2 ;;
                    (-d) DJANGO_VERSION=Django==$2
                            shift 2 ;;
                    (*) break ;;
            esac
    done

    mkvirtualenv $PROJECT_NAME -p "$PYTHON_VERSION_PATH"
    workon $PROJECT_NAME
    test -n ${VIRTUAL_ENV-} || {
        echo no env, no gain >&2
        return 1
    }

    pip install "$DJANGO_VERSION"


    django-admin startproject --template=/home/toma/Dev/k8s/django-drybones-k8s.zip --extension=html,rst,ini,yaml,yml,coveragerc --name=Makefile $PROJECT_NAME
    #django-admin startproject --template=https://github.com/unistra/django-drybones/archive/master.zip --extension=html,rst,ini,coveragerc --name=Makefile $PROJECT_NAME
    cd $PROJECT_NAME
    setvirtualenvproject $VIRTUAL_ENV $PWD
    echo "export DJANGO_SETTINGS_MODULE=$PROJECT_NAME.settings.dev" >> $VIRTUAL_ENV/bin/postactivate
    echo "unset DJANGO_SETTINGS_MODULE" >> $VIRTUAL_ENV/bin/postdeactivate
    workon $PROJECT_NAME
    chmod +x manage.py
    pip install -r requirements/dev.txt
}

# venvactivate - Activate venv with fzf
function venvactivate() {
  local selected_env
  selected_env=$(ls ~/.virtualenvs/ | fzf)

  if [ -n "$selected_env" ]; then
    source "$HOME/.virtualenvs/$selected_env/bin/activate"
  fi
}

# delete-branches - Remove branches
function delete-branches() {
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {}" |
    xargs --no-run-if-empty git branch --delete --force
}

# gs2 - git status
function gs2() {
  git -c color.status=always status --short |
  fzf --height 50% --border --ansi --multi --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
gbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
        fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# gcoc - checkout git commit
gcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# gshow_preview - git commit browser with previews
gshow_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}

# gstash - easier way to deal with stashes
# type gstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
gstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

# fgst - pick files from `git status -s`
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gstf() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    echo "$item" | awk '{print $2}'
  done
  echo
}

# nuke - Kill root process
nuke() {
  local pid
  pid=$(ps -ef | grep -v ^root | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fkill - kill processes
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}


# ks - Read k8s config context
function kc() {
  kubectl config get-contexts | tail -n +2 | fzf | cut -c 2- | awk '{print $1}' | xargs kubectl config use-context
}


function update_kubeconfigs() {
  [ ! -d "$HOME/.kube/config.d" ] && mkdir $HOME/.kube/config.d -p -v
  # Will run only if there are new files in the config directory
  local new_files=$(find $HOME/.kube/config.d/ -newer $HOME/.kube/config -type f | wc -l)
  if [[ $new_files -ne "0" ]]; then
    local current_context=$(kubectl config current-context) # Save last context
    local kubeconfigfile="$HOME/.kube/config"               # New config file
    cp -a $kubeconfigfile "${kubeconfigfile}_$(date +"%Y%m%d%H%M%S")"  # Backup
    local kubeconfig_files="$kubeconfigfile:$(ls $HOME/.kube/config.d/* | tr '\n' ':')"
    KUBECONFIG=$kubeconfig_files kubectl config view --merge --flatten > "$HOME/.kube/tmp"
    mv "$HOME/.kube/tmp" $kubeconfigfile && chmod 600 $kubeconfigfile
    export KUBECONFIG=$kubeconfigfile
    kubectl config use-context $current_context --namespace=default
  fi
}

# This will call each time you source .bashrc, remove it if you want to call it manually each time
update_kubeconfigs


# json - JSON file with jq
function json {
  jq -C . $1 | bat
}

# md2pdf - Convert md to pdf
function md2pdf {
  pandoc -s --toc --number-sections -t latex -o $2 $1
}

# history-remove - Remove line from history
# Accepts one history line number as argument.
# Alternatively, you can do `dc -1` to remove the last line.
function history_remove () {
  # Prevent the specified history line from being saved.
  local HISTORY_IGNORE="${(b)$(fc -ln $1 $1)}"

  # Write out the history to file, excluding lines that match `$HISTORY_IGNORE`.
  fc -W

  # Dispose of the current history and read the new history from file.
  fc -p $HISTFILE $HISTSIZE $SAVEHIST

  # TA-DA!
  print "Deleted '$HISTORY_IGNORE' from history."
}

#
# Docker relatives
#

# da - Select a docker container to start and attach to
function da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# ds - Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# Select a docker container to remove
# function drm() {
#   local cid
#   cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

#   [ -n "$cid" ] && docker rm "$cid"
# }
# drm - Select a docker container to remove but allows multi selection:
function drm() {
  docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
}

# drmi - Select a docker image or images to remove
function drmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi
}

# fzf specific
_fzf_complete_myssh() {
  _fzf_complete_ssh "$@"
}

# vs - Vagrant machines list
vs(){
  #List all vagrant boxes available in the system including its status, and try to access the selected one via ssh
  cd $(cat ~/.vagrant.d/data/machine-index/index | jq '.machines[] | {name, vagrantfile_path, state}' | jq '.name + "," + .state  + "," + .vagrantfile_path'| sed 's/^"\(.*\)"$/\1/'| column -s, -t | sort -rk 2 | fzf | awk '{print $3}'); vagrant ssh
}

# fns - Run npm script (requires jq)
fns() {
  local script
  script=$(cat package.json | jq -r '.scripts | keys[] ' | sort | fzf) && npm run $(echo "$script")
}

# brave_history - Browse chrome/chromium/brave history
brave_history() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default//History"
    open=open
  else
    # TODO: add chrome/chromium only brave for now
    brave_history="$HOME/.config/BraveSoftware/Brave-Browser/Default/History"
    open=xdg-open
  fi
  cp -f "$brave_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
    from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

# brave_bookmark - browse brave bookmarks
brave_bookmark() {
  local bookmarks_path="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
  local jq_script='def ancestors: while(. | length >= 2; del(.[-1,-2])); . as $in | paths(.url?) as $key | $in | getpath($key) | {name,url, path: [$key[0:-2] | ancestors as $a | $in | getpath($a) | .name?] | reverse | join("/") } | .path + "/" + .name + "\t" + .url'
  jq -r $jq_script < "$bookmarks_path" \
  | sed -E $'s/(.*)\t(.*)/\\1\t\x1b[36m\\2\x1b[m/g' \
  | fzf --ansi \
  | cut -d$'\t' -f2 \
  | xargs open
}

# cdb - shell bookmark
# see ~/.cdb_path
cdb() {
    local dest_dir=$(cdscuts_glob_echo | fzf )
    if [[ $dest_dir != '' ]]; then
      cd "$dest_dir"
    fi
}
