# vim:ft=zsh ts=2 sw=2 sts=2

# -------------------------------------------------------------------
# use nocorrect alias to prevent auto correct from "fixing" these
# -------------------------------------------------------------------
#alias foobar='nocorrect foobar'
alias g8='nocorrect g8'

# -------------------------------------------------------------------
# directory movement
# -------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias 'bk=cd $OLDPWD'

# -------------------------------------------------------------------
# directory information & management
# -------------------------------------------------------------------
alias lh='ls -d .*' # show hidden files/directories only
#alias lsd='ls -aFhlG'
alias l='ls -al'
alias ls='ls -GFh'  # Colorize output, add file type indicator, and put sizes in human readable format
alias ll='ls -GFhl' # Same as above, but in long listing format
alias lst='ls -AlFhrt'
alias la="exa -abghl --git --color=automatic"
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias 'dus=du -sckx * | sort -nr'        #directories sorted by size
alias dirsize='du -sch'                  # Show size of current directory
alias 'wordy=wc -w * | sort | tail -n10' # sort files in current directory by the number of words they contain
alias 'filecount=find . -type f | wc -l' # number of files (not directories)
alias mkdir='mkdir -p -v'
alias mutt='neomutt'
# -------------------------------------------------------------------
# Mac only
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then
    alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
    alias oo='open .'                  # open current directory in OS X Finder
    alias 'today=calendar -A 0 -f /usr/share/calendar/calendar.mark | sort'
    alias 'mailsize=du -hs ~/Library/mail'
    alias 'smart=diskutil info disk0 | grep SMART' # display SMART status of hard drive
    # Hall of the Mountain King
    alias cello='say -v cellos "di di di di di di di di di di di di di di di di di di di di di di di di di di"'
    # alias to show all Mac App store apps
    alias apps='mdfind "kMDItemAppStoreHasReceipt=1"'
    # reset Address Book permissions in Mountain Lion (and later presumably)
    alias resetaddressbook='tccutil reset AddressBook'
    # refresh brew by upgrading all outdated casks
    alias refreshbrew='brew outdated | while read cask; do brew upgrade $cask; done'
    # rebuild Launch Services to remove duplicate entries on Open With menu
    alias rebuildopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.fram ework/Support/lsregister -kill -r -domain local -domain system -domain user'
fi

# -------------------------------------------------------------------
# remote machines
# -------------------------------------------------------------------
alias 'asciipunks=ssh toma@asciipunks.fr.nf'
alias 'datapunks=ssh admin@datapunks.fr -p 2323'

# -------------------------------------------------------------------
# database
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then
    alias 'psqlstart=/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start'
    alias 'psqlstop=/usr/local/pgsql/bin/pg_ctl stop'
fi
alias mysql='mysql -u root'
alias mysqladmin='mysqladmin -u root'

# -------------------------------------------------------------------
# devvm start, stop, ssh, and mount, vagrant stuff
# -------------------------------------------------------------------
alias 'startvm=VBoxHeadless --startvm devvm'
alias 'stopvm=VBoxManage controlvm devvm poweroff'
alias v1='ssh vagrant@192.168.1.2'
alias v1copyid='ssh-copy-id vagrant@192.168.1.2'
alias v2='ssh vagrant@192.168.1.3'
alias v2copyid='ssh-copy-id vagrant@192.168.1.2'
alias vacopyid='ssh-copy-id vagrant@192.168.1.2 && ssh-copy-id vagrant@192.168.1.3'
alias vagrantaddssh='ssh-add /home/toma/Dev/vagrant/.vagrant/machines/default/virtualbox/private_key'

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias ga='git add'
alias gall='git add -A'
alias gb='git branch'
alias gc='git commit -v'
alias gco='git checkout'
alias gca='git commit -v -a'
alias gcb='git checkout -b'
alias gcl='git clone'
alias gci='git commit --interactive'
alias gcm='git commit -v -m'
alias gd='git diff'
alias gdel='git branch -D'
alias gexport='git archive --format zip --output'
alias gf='git fetch --all --prune'
alias gft='git fetch --all --prune --tags'
alias gfv='git fetch --all --prune --verbose'
alias gftv='git fetch --all --prune --tags --verbose'
alias gitclean='find . -maxdepth 2 -type d -name '.git' -print0 | while read -d ""; do (cd "$REPLY"; git gc); done'
alias gitcountcommits="git log --pretty=format:'' | wc -l"
alias gitsearch='git rev-list --all | xargs git grep -F'
alias gl='git log'
alias gm='git commit -m'
alias gma='git commit -am'
alias gp='git push'
alias gpl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gpu='git pull'
alias gra='git remote add'
alias grr='git remote rm'
alias gs='git status'
alias gta='git tag -a -m'
alias gv='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr'
#alias g='git'
# leverage aliases from ~/.gitconfig
alias gh='git hist'
alias gt='git today'
alias gitcountlines='git ls-files | git ls-files | xargs file | grep "ASCII" | cut -d : -f 1 | xargs wc -l'

# curiosities
# gsh shows the number of commits for the current repos for all developers
alias gsh="git shortlog | grep -E '^[ ]+\w+' | wc -l"

# gu shows a list of all developers and the number of commits they've made
alias gu="git shortlog | grep -E '^[^ ]'"

# -------------------------------------------------------------------
# Python stuff & virtualenv
# -------------------------------------------------------------------
alias covertest='coverage run -m unittest discover tests/'
alias djangoserver='python manage.py runserver'
alias formatpep8="autopep8 -r -i ."
alias mkenv='mkvirtualenv'
alias off="deactivate"
alias on="workon"
alias pipupdate="pip freeze --local | grep -v -E '(^Django\=|^\-f|^\-e)' | cut -d = -f 1  | xargs pip install -U"
alias venvproject="setvirtualenvproject $VIRTUAL_ENV $(pwd)"

# -------------------------------------------------------------------
# Symfony
# -------------------------------------------------------------------
alias scc='php symfony cc'

# -------------------------------------------------------------------
# Tmux relatives
# -------------------------------------------------------------------
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'
alias tk='tmux kill-session -t'
alias tmux='TERM=screen-256color-bce tmux' # force tmux in 256 colors

# -------------------------------------------------------------------
# Grep relatives
# -------------------------------------------------------------------
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# -------------------------------------------------------------------
# Misc stuff
# -------------------------------------------------------------------
alias 'ttop=top -ocpu -R -F -s 2 -n30' # fancy top
alias 'rm=rm -i'                       # make rm command (potentially) less destructive
alias 'vi=nvim'                        # using nvim everywhere
alias 'vim=nvim'                       # using nvim everywhere
alias bcat='pygmentize -O style=monokai -f console256 -g'
alias ccat='pygmentize -O bg=dark'
alias c='pygmentize -O style=borland -f console256 -g'
alias cui='uuidgen | tr -d "\n" | xclip -selection clipboard'
alias e='exit'
alias fact='wget randomfunfacts.com -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;"'
alias fu='sudo fuser -mv' # what uses the named files, sockets, or filesystems
alias genpass='pwgen -Bcy 15 1'
alias i3cheatsheet='egrep "^bind" ~/.i3/config | cut -d '\'' '\'' -f 2- | sed '\''s/ /\t/'\'' | column -ts $'\''\t'\'' | pr -2 -w 160 -t | less'
alias kindlesend='mutt bastardkindlefromhell@kindle.com -s "new book" -a'

alias open_ports="lsof -i -P | grep -i 'listen'"
alias path='echo $PATH | tr -s ":" "\n"'
alias pdf='zathura'
alias t='todo.sh -d ~/.todo/config'
alias turn-off-screen='xset dpms force off' # force to turn off screens
# Weather
alias weatherfc='echo -n "Meteo de la semaine à Strasbourg  " | pv -qL 20 && weatherman -x "Strasbourg,France" | ccze -A'
alias urldecode='python2.7 -c "import sys, urllib as ul; \
        print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python2.7 -c "import sys, urllib as ul; \
        print ul.quote_plus(sys.argv[1])"'
alias atomplist="apm list --installed --bare | grep '^[^@]\+' -o"
#netstat -tulpn | grep -P ":80|443"
alias xclip='xclip -selection c'
# alias to cat this file to display
alias acat='< ~/.zsh/aliases.zsh'
alias fcat='< ~/.zsh/functions.zsh'
alias sz='source ~/.zshrc'
alias disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h;'
# Surfraw
alias srg='surfraw google'
alias srd='surfraw duckduckgo'
alias srs='surfraw stack'
alias sra='surfraw aur'
alias srl='surfraw slinuxdoc'
# dl from ftp/site
alias dldir="wget -c -nd -r -l 0 -np"
alias aria2c="aria2c --console-log-level=error --check-integrity --bt-hash-check-seed=false -c"
alias wget-all='wget --user-agent=Mozilla -e robots=off --content-disposition --mirror --convert-links -E -K -N -r -c'
alias ytmp3="youtube-dl -f bestaudio --extract-audio --audio-format mp3 --add-metadata --embed-thumbnail"
alias '?=whence -ca' # print info about a command, alias, function..
# network
#alias myip='curl -s icanhazip.com'
# kitty kittens
alias icat="kitty +kitten icat"
alias difff="kitty +kitten diff"
# -------------------------------------------------------------------
# Source: http://aur.archlinux.org/packages/lolbash/lolbash/lolbash.sh
# -------------------------------------------------------------------
alias wtf='dmesg'
alias onoz='cat /var/log/errors.log'
alias rtfm='man'
alias visible='echo'
alias invisible='cat'
alias moar='more'
alias icanhas='mkdir'
alias donotwant='rm'
alias dowant='cp'
alias gtfo='mv'
alias hai='cd'
alias plz='pwd'
alias inur='locate'
alias nomz='ps aux | less'
alias nomnom='killall'
alias cya='reboot'
alias kthxbai='halt'

# http://www.zzapper.co.uk/zshtips.html
alias -g ND='*(/om[1])' # newest directory
alias -g NF='*(.om[1])' # newest file
alias -g NO='&>|/dev/null'
alias -g P='2>&1 | $PAGER'
alias -g VV='| vim -R -'
alias -g L='| less'
alias -g M='| most'
alias -g C='| wc -l'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
# config files
alias virc='vi ~/.vimrc'
alias vizsh='vi ~/.zshrc'
alias vimutt='vi ~/.muttrc'
alias vitmux='vi ~/.tmux.conf'
alias vii3="vi ~/.config/i3/config"
# docker
alias purge_docker="docker ps -qa | xargs docker rm -f ; docker images -qa | xargs docker rmi -f"
# k8z
alias k='kubectl'
# Alias sonos
alias couleur3='sonos 192.168.0.62 play_fav "RTS couleur 3"'
# rep or silver searcher aliases
# if (($ + commands[ag])); then
#     alias ag='ag -S --hidden --ignore=.git --ignore=.svn --ignore=.hg --color-line-number="00;32" --color-path="00;35" --color-match="01;31"'
#     alias gr=ag
#     alias g=ag
# else
#     alias g='grep -iE --color=auto --exclude="*~" --exclude tags'
#     alias gr='grep -IRiE --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.hg --color=auto --exclude="*~" --exclude tags'
# fi
# fzf+bat search and preview
alias preview='fzf --height=50% --layout=reverse --preview="bat --color=always {}"'
#
alias psrun='ps -m -o %cpu,%mem,command'
# mount work ad
alias unistra_admount='sudo mount -t cifs -o username=baguet //vfiler-ad-pers.ad.unistra.fr/baguet /mnt/windows_share'
alias unistra_resignkey="curl -f -k -H 'Content-Type: application/json' -XPOST --user baguet https://tower.di.unistra.fr/api/v2/job_templates/48/launch/"
# Sonos
alias couleur3='sonos 192.168.0.62 play_fav "RTS couleur 3"'
alias so='sonos 192.168.0.62'
# -------------------------------------------------------------------
#  Specific os relatives alias
# -------------------------------------------------------------------
#TODO : us checkos.zsh style for this !!!!!

OS="$(uname)"
case $OS in
'Linux')
    OS='Linux'
    alias ls="ls --group-directories-first --color=tty --quoting-style=literal"
    #ubuntu relative
    alias apt-foreign="aptitude search ~o"
    alias aptmaj="sudo apt-fast update && sudo apt-fast upgrade -y && sudo apt-fast clean"
    alias install-essential="sudo add-apt-repository ppa:ricotz/docky;sudo apt-get update; sudo apt-get install php5-common libapache2-mod-php5 php5-cli git plank vim skype guake chromium-browser git firefox vlc filezilla"

    #arch linux relatives
    alias pacc="sudo pacman -Scc"     # Clean cache - delete all not currently installed package files
    alias pacexpl="pacman -D --asexp" # Mark one or more installed packages as explicitly installed
    alias pacimpl="pacman -D --asdep" # Mark one or more installed packages as non explicitly installed
    alias pacin='sudo pacman -S'      # Install specific package(s) from the repositories
    alias pacins='sudo pacman -U'     # Install specific package not from the repositories but from a file
    alias paclf="pacman -Ql"          # List all files installed by a given package
    alias paclo="pacman -Qdt"         # List all packages which are orphaned
    alias pacloc='pacman -Qi'         # Display information about a given package in the local database
    alias paclocs='pacman -Qs'        # Search for package(s) in the local database
    alias pacre='sudo pacman -R'      # Remove the specified package(s), retaining its configuration(s) and required dependencies
    alias pacrem='sudo pacman -Rns'   # Remove the specified package(s), its configuration(s) and unneeded dependencies
    alias pacrep='pacman -Si'         # Display information about a given package in the repositories
    alias pacreps='pacman -Ss'        # Search for package(s) in the repositories
    alias pacupg='sudo pacman -Syu'   # Synchronize with repositories and then upgrade packages that are out of date on the local system.
    alias pacshow='grep "upgraded" /var/log/pacman.log | tail -n45 | cut -d" " -f5-8'
    # '[r]emove [o]rphans' - recursively remove ALL orphaned packages
    alias pacro="pacman -Qtdq > /dev/null && sudo pacman -Rns \$(pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"
    # Additional pacman alias examples
    alias pacinsd='sudo pacman -S --asdeps'    # Install given package(s) as dependencies
    alias pacmir='sudo pacman -Syy'            # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
    alias pacupd='sudo pacman -Sy && sudo abs' # Update and refresh the local package and ABS databases against repositories
    alias sc='sudo systemctl'                  #
    # Simplified pacman aliases
    alias pacman-upgrade="sudo pacman -Syu"            # Synchronize with repositories and then upgrade packages that are out of date on the local system.
    alias pacman-download="pacman -Sw"                 # Download specified package(s) as .tar.xz ball
    alias pacman-install="sudo pacman -S"              # Install specific package(s) from the repositories
    alias pacman-install-file="sudo pacman -U"         # Install specific package not from the repositories but from a file
    alias pacman-remove="sudo pacman -R"               # Remove the specified package(s), retaining its configuration(s) and required dependencies
    alias pacman-purge="sudo pacman -Rns"              # Remove the specified package(s), its configuration(s) and unneeded dependencies
    alias pacman-repoinfo="pacman -Si"                 # Display information about a given package in the repositories
    alias pacman-search="pacman -Ss"                   # Search for package(s) in the repositories
    alias pacman-dbinfo="pacman -Qi"                   # Display information about a given package in the local database
    alias pacman-dbsearch="pacman -Qs"                 # Search for package(s) in the local database
    alias pacman-list-orphaned="pacman -Qdt"           # List all packages which are orphaned
    alias pacman-clean-cache="sudo pacman -Scc"        # Clean cache - delete all the package files in the cache
    alias pacman-list-package-files="pacman -Ql"       # List all files installed by a given package
    alias pacman-provides-="pacman -Qo"                # Show package(s) owning the specified file(s)
    alias pacman-force-installed="pacman -D --asexp"   # Mark one or more installed packages as explicitly installed
    alias pacman-force-uninstalled="pacman -D --asdep" # Mark one or more installed packages as non explicitly installed
    alias update-mirrors="sudo reflector --verbose --latest 40 --number 10 --sort rate --protocol http --save /etc/pacman.d/mirrorlist"
    ### Systemd ###
    alias sdisable=' sudo systemctl disable $@'
    alias senable='sudo systemctl enable $@'
    alias srestart='sudo systemctl restart $@'
    alias sstart='sudo systemctl start $@'
    alias sstatus='sudo systemctl status $@'
    alias sstop='sudo systemctl stop $@'
    alias start='sudo systemctl start'
    alias stop='sudo systemctl stop'
    alias restart='sudo systemctl restart'
    alias status='systemctl status'
    alias serror='journalctl -xe -p4 -b0'
    #misc
    #
    # byzanz screencaster to gif
    # sudo add-apt-repository ppa:fossfreedom/byzanz
    # sudo apt-get update && sudo apt-get install byzanz
    alias gifcast='byzanz-record --duration=15 --x=200 --y=300 --width=700 --height=400 out.gif'
    alias screenrecord="ffmpeg -f x11grab -s 1920x1080 -an -i :0.0 -c:v libvpx -b:v 5M -crf 10 -quality realtime -y -loglevel quiet"
    # secure mv & rm
    alias mv=' timeout 8 mv -iv'
    alias rm=' timeout 3 rm -Iv --one-file-system'
    alias 'o'='xdg-open'
    alias archerrors='echo -n Journal Errors | pv -qL 10 && journalctl -b -p err | ccze -A'
    alias systemdmsg="sudo journalctl /usr/lib/systemd/systemd | ccze -A"
    alias cleansyslog="sudo journalctl --vacuum-time=2d"
    alias blame="systemd-analyze blame | ccze -A"
    alias boot="echo -n Boot Time | pv -qL 10 && systemd-analyze | ccze -A"
    alias units="echo -n Listing Units | pv -qL 10 && systemctl list-units | ccze -A"
    alias i3edit="vi ~/.config/i3/config"
    alias vpnudscisco="sudo openconnect -u baguet vpn.u-strasbg.fr"
    alias vpnuds="sudo openfortivpn -u baguet vpn.unistra.fr"
    alias redshift-strasbourg="redshift -v -l 48.57:7.75 -b 1.0:0.6"
    # pause/resume dunst notifications
    #alias notifications-pause="notify-send DUNST_COMMAND_PAUSE"
    alias notifications-pause="dunstctl set-paused true"
    #alias notifications-resume="notify-send DUNST_COMMAND_RESUME"
    alias notifications-resume="dunstctl set-paused false"
    #alias notifications-toggle="notify-send DUNST_COMMAND_TOGGLE"
    alias notifications-toggle="dunstctl set-paused toggle"
    ;;
'FreeBSD')
    OS='FreeBSD'
    alias ls='ls -G'
    ;;
'WindowsNT')
    OS='Windows'
    ;;
'Darwin')
    OS='Mac'

    #osx specific
    alias airdropoff="defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool FALSE; killall Finder"
    alias airdropon="defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool TRUE; killall Finder"
    alias brewmaj="brew update && brew upgrade --all && brew cask update && brew cleanup && brew cask cleanup"
    alias cleandownload="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
    alias DiskUtility_debug='defaults write com.apple.DiskUtility DUDebugMenuEnabled 1' # http://osxdaily.com/2011/09/23/view-mount-hidden-partitions-in-mac-os-x/
    alias dockspace="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'"
    alias ebin="rm -rf ~/.Trash/*"
    alias eject_force="diskutil unmountDisk force"
    alias finder='open -a Finder ./'
    alias flushdns="dscacheutil -flushcache"
    alias histdownload="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineDataURLString from LSQuarantineEvent'"
    alias kcrash_verbose='sudo nvram boot-args="-v keepsyms=y"'
    alias osxpg_start="postgres -D /usr/local/var/postgres"
    alias portmaj="sudo port selfupdate -v && sudo port upgrade outdated -v"
    alias quiet_boot="sudo nvram SystemAudioVolume=%80"
    alias sound_boot="sudo nvram -d SystemAudioVolume"
    alias sql_istat='grep -oE "INTO `\w+`" | grep -oE "`\w+`" | sort | uniq -c | sort -nr'
    alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
    alias swap_off="sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist"
    alias swap_on="sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist"
    ;;
'SunOS')
    OS='Solaris'
    ;;
'AIX') ;;
*) ;;
esac

alias b='echo -e "enter brightness:\n"; read val; xrandr  --output eDP1 --brightness "${val}"'
