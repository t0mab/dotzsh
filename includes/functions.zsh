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
    ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
    ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

# -------------------------------------------------------------------
# (s)ave or (i)nsert a directory.
# -------------------------------------------------------------------
function s() { pwd > ~/.save_dir ; }
function i() { cd "$(cat ~/.save_dir)" ; }

# Tmux tool
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

    django-admin startproject --template=https://github.com/unistra/django-drybones/archive/master.zip --extension=html,rst,ini,coveragerc --name=Makefile $PROJECT_NAME
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

# -------------------------------------------------------------------
# Maj archlinux
#
# -------------------------------------------------------------------
archmaj() {
    # get news from archlinux fr
    curl https://archlinux.fr/feed -s|awk '/<title>/ {z=substr($0,10,length($0)-17)} /<pubDate>/ {print z "||" $2" " $3 " " $4} '
    python -c 'import sys; print (sys.real_prefix)' 2>/dev/null && deactivate
    #yaourt -Syua
    yay -Syu --noconfirm
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
