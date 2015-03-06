### NOTE: tab completion is controlled here: ~/.inputrc
###       aliases file, and this file, are pulled in by ~/.bash_profile
###
### Installation:
###   from .bash_profile, do: source  $DYNAMIDE_MENU/functions.bash
###   from .bash_profile, do: source  $DYNAMIDE_MENU/d.bash  #My custom directory changer.

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
##BAKBLK='\e[40m'   # Black - Background
BAKBLK='\e[44m'   # Black - Background  ## Laramie 20140604 '\e[44m' is the new '\e[40m'

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function parse_git_status () {
    MOJO=`$DYNAMIDE_MENU/git-branch-status -p 2> /dev/null`
    if [ -z "$MOJO" ] ; then
        FOO=""
    else
        echo -n " :$MOJO"
    fi
}

..() {
    if [ "$#" == "0" ] ; then cd ..; return 0;  fi
    for i in $(seq $1); do cd ..; done;
}

function cd() {
   builtin cd $*;
   'ls' -G;
}

function date() {
    /bin/date "$@"
    if [ "$#" == "0" ] ; then
             echo "  CWD:       `pwd`"
             echo "  STAMP: `/bin/date +%Y%m%d`"
             ## newline works: /bin/date "+DATE: %Y-%m-%d%nTIME: %l:%M %p %Z"
             /bin/date "+  DATE:      %Y-%m-%d"
             CURR=`/bin/date "+%l:%M %p"`
             echo -e "  TIME:     \033[1;32;40m$CURR \033[0m"
    fi
}

