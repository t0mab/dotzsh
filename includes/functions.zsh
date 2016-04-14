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
function initproject() {
    unset PYTHON_VERSION
    unset PYTHON_PATH
    unset DJANGO_VERSION
    if [ -z "$1" ];then
        echo -e "Missing argument. Script usage:\n" \
        "   initproject project_name [ -p python_version -d django_version]" \
        "   example : initproject -p 3 -d 1.8.4 "
    else
        PROJECT_NAME=$1
        ARGS=`getopt --long -o "p:d:" "$@"`
        eval set -- "$ARGS"
        while true ; do
            case "$1" in
                -p )
                    PYTHON_VERSION=$2
                    shift 2
                ;;
                -d )
                    DJANGO_VERSION=$2
                    shift 2
                ;;
                *)
                    break
                ;;
            esac
        done;
        PYTHON_VERSION_PATH=`which python$PYTHON_VERSION`
        mkvirtualenv $PROJECT_NAME -p "$PYTHON_VERSION_PATH"
        if [ -z "$DJANGO_VERSION" ];then
            pip install "Django>1.8,<1.9"
        else
            pip install Django==$DJANGO_VERSION
        fi
        django-admin.py startproject --template=https://github.com/unistra/django-drybones/tree/django1.8/archive/master.zip --extension=html,rst,ini,coveragerc --name=Makefile $PROJECT_NAME
        cd $PROJECT_NAME
        setvirtualenvproject $VIRTUAL_ENV $(pwd)
        echo "export DJANGO_SETTINGS_MODULE=$PROJECT_NAME.settings.dev" >> $VIRTUAL_ENV/bin/postactivate
        echo "unset DJANGO_SETTINGS_MODULE" >> $VIRTUAL_ENV/bin/postdeactivate
        workon $PROJECT_NAME
        chmod +x manage.py
        pip install -r requirements/dev.txt
    fi
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
