##export PS1="\[\e]0;\w\a\]\n\[\e[0;92m\e[40m\]\u@\h \[\e[1;95m\]\w\[\e[1;33m\]\$(parse_git_branch)\[\e[0m\]\n\$ "
function setTitle() {
    case "$1" in 
    --help)
        echo
        echo "  title  [-user [{username}]|-nouser] [-nohost|-host|-host {myhostname}] [-title {mytitle}] [-window]"
        echo "  title  -clear"
        echo
        echo "  Set the title and optional user and hostname in your bash PS1 prompt." 
        echo "  Options:"
        echo "    -u, -user               - includes user login in prompt"
        echo "    -u, -user {myusername}  - uses the supplied override (for display only)"
        echo "    -a, -anon, -nouser      - excludes user login from prompt"
        echo "    -h, -host               - uses the system hostname"
        echo "    -h, -host {myhostname}  - uses the supplied hostname override"
        echo "    -n, -nohost             - hides display of the hostname"
        echo "    -n, -window             - reports the TITLE to the shell window"
        echo "    -t, -title {mytitle}    - sets a description at the left of the info line"
        echo 
        echo "    -clear - clears the PS1 of title, user, and host"
        echo
        echo "  Examples:"
        echo "   title -t mytitle "
        echo -e "     - sets the title and removes the user and hostname display\n"
        echo "   title -host myhost -t mytitle "
        echo -e "     - sets the title and overrides the hostname with 'myhost'\n"
        echo "   title -h -t mytitle "
        echo -e "     - sets the title and uses the system hostname\n"
        echo "   title -u -h -t mytitle "
        echo -e "     - sets the title and uses the shell user and system hostname\n"
        echo "   title -anon -n -t mytitle "
        echo -e "     - sets the title, no user or hostname (same as title -t mytitle)\n"
        echo "   title -u myDisplayName -h myhost -title 'My Title'"
        echo -e "     - sets a long title, overrides the hostname and user\n"
        return
        ;;
    esac
    local DYNAMIDE_SHOW_HOST_PS1=
    local DYNAMIDE_SHOW_USER_PS1=
    TITLE=
    SPaCE=
    USER_HOST=
    DYNAMIDE_TITLE_SESSION=
    
    if [ "$1" == "-clear" ]; then
        shift
        DYNAMIDE_SHOW_USER_PS1=
        DYNAMIDE_SHOW_HOST_PS1=
        TITLE=
        SPaCE=
        USER_HOST=
    fi
    
    while test $# -gt 0; do
        case "$1" in
        -u|-user)
                shift
                if [ "$1" == "" ]; then  #no more args.
                    export DYNAMIDE_SHOW_USER_PS1="\u"
                    continue  
                fi
                echo "$1" |grep '^-' > /dev/null
                if [ "$?" -eq 0 ]; then
                    export DYNAMIDE_SHOW_USER_PS1='\u'
                else 
                    export DYNAMIDE_SHOW_USER_PS1="$1"
                    shift
                fi
                ;;
        -a|-anon|-nouser)
                shift
                export DYNAMIDE_SHOW_USER_PS1=""
                ;;
        -h|-host)
                shift
                if [ "$1" == "" ]; then
                    export DYNAMIDE_SHOW_HOST_PS1='\h'
                    continue  
                fi
                echo "$1" |grep '^-' > /dev/null
                if [ "$?" -eq 0 ]; then
                    export DYNAMIDE_SHOW_HOST_PS1='\h'
                else 
                    export DYNAMIDE_SHOW_HOST_PS1="$1"
                    shift
                fi
                ;;
        -t|-title)
                shift
                if [ "$1" == "" ]; then
                    echo "WARNING: -title was specified without an argument"
                    return  
                fi
                
                echo "$1" |grep '^-'  > /dev/null
                if [ "$?" -eq 0 ]; then
                    echo "WARNING: -title was specified without an argument, next option found: $1"
                else 
                    export TITLE="$1"
                    shift
                fi
                ;;
        -n|-nohost)
                shift
                export DYNAMIDE_SHOW_HOST_PS1=''
                ;;
        -w|-window)
                shift
                export DYNAMIDE_TITLE_SESSION='\033]0;$TITLE\007'
                ;;
         *)
                echo "Unknown option: $1"
                shift
                ;;
        esac
    done
    
    ##echo "Options set: TITLE $TITLE DYNAMIDE_SHOW_HOST_PS1 $DYNAMIDE_SHOW_HOST_PS1 DYNAMIDE_SHOW_USER_PS1 $DYNAMIDE_SHOW_USER_PS1" 
    
    local USER_HOST=
    
    if [ "$DYNAMIDE_SHOW_HOST_PS1" != "" ] &&  [ "$DYNAMIDE_SHOW_USER_PS1" != "" ];then
        USER_HOST="$DYNAMIDE_SHOW_USER_PS1@$DYNAMIDE_SHOW_HOST_PS1"
    elif [ "$DYNAMIDE_SHOW_USER_PS1" != ""  ]; then
        USER_HOST="$DYNAMIDE_SHOW_USER_PS1"
    elif [ "$DYNAMIDE_SHOW_HOST_PS1" != ""  ]; then    
        USER_HOST="$DYNAMIDE_SHOW_HOST_PS1"
    fi
        
    if [ "$USER_HOST" != "" ];then
        USER_HOST="[$USER_HOST]"  
    fi
    
    local SPaCE=
    if [ "$TITLE" != "" ] &&  [ "$USER_HOST" != "" ];then
        SPaCE=' '
    fi
    export PS1="\[\e]0;\w\a\]\n\[\e[0;92m\]\[\e[1;33m\]$TITLE$SPaCE$USER_HOST \[\e[1;95m\]\w\[\e[1;33m\] (\$(parse_git_branch)\[\e[1;34m\]\$(parse_git_status)\e[1;33m\])${DYNAMIDE_TITLE_SESSION}\n$ \[\e[0m\]"
    
    ##export PS1="\[\e]0;\w\a\]\n\[\e[0;92m\]\[\e[1;33m\]$TITLE$DYNAMIDE_SHOW_HOST_PS1 \[\e[1;95m\]\w\[\e[1;33m\]\$(parse_git_branch)\[\e[0m\]\n\$\033]0;$TITLE\007"
    ## The last bit, \033]0;$TITLE\007, exports the title to the shell for reporting in window titles, works with iterm2 if you check "let session report title."
}

setTitle
alias title='setTitle'
