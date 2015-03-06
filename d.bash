### Installation:
###   From .bash_profile, do this, which will in turn pull in this file and dependencies: 
###              source  .bash-menu/.bash_profile    #this sets DYNAMIDE_MENU

#============ Overridable Options ==============================================
DYNAMIDE_SPACES_LIST="$DYNAMIDE_MENU/spaces.list"  ## This gets overridden by sourcing, e.g. ~/.laramie/.bash_profile

DYNAMIDE_DIRLIST_DEFAULT="$DYNAMIDE_MENU/spaces/default/directories.list"

DYNAMIDE_MENU_LIST="$DYNAMIDE_MENU/spaces/default/menu.list"

DYNAMIDE_DEBUG_DIRLIST=f        ## bash-menu-log() control: f for normal, q for quiet, v for debugging.

DM_MENUOPTS_SHOWSPACE=t         ## always show space as menu item "s"

DM_MENU_BEFORE=
DM_MENU_AFTER=
#============ Calculated Options ==============================================
DM_MENU_SPACE_NAME=             ## Don't set this--it is calculated and available for you.
## You could, for example put it in your menu like so: 
##   DM_MENU_BEFORE=---------------$DM_MENU_SPACE_NAME---------------
#===============================================================================

if [ -f "$DYNAMIDE_MENU/space.index" ]; then
    read DYNAMIDE_MENU_SPACE_INDEX < "$DYNAMIDE_MENU/space.index"
fi


function bash-menu-d(){
    if [ "$DYNAMIDE_MENU_SPACE_INDEX" != "" ]; then
        space -q "$DYNAMIDE_MENU_SPACE_INDEX"
    else 
        echo "Using default space 0"
        space -q 0
    fi
    FILES_LIST=$DYNAMIDE_DIRLIST_LIST
    DYNAMIDE_DEBUG_DIRLIST=f
    local CHOICE=""
    while test $# -gt 0; do
#options: Command-Line
    case "$1" in
    -h|h|help|--help)
            shift
            bash-menu-doHelp $*
            return
            ;;
    -v|v)
            shift
            export DYNAMIDE_DEBUG_DIRLIST=v
            ;;
    -q|q)
            shift
            export DYNAMIDE_DEBUG_DIRLIST=q
            ;;
    -a|a|add)
            shift
            bash-menu-addToDirlist "$1" "$FILES_LIST"
            shift
            shift
            return
            ;;
    -c|c|connect|-s|s|space)
            shift
            space $*
            return
            ;;
    -e|e|-edit)
            shift
            echo "    Edit list: $FILES_LIST" 
            $EDITOR $FILES_LIST
            return
            ;;
    -em|em)
            shift
            echo "    Edit menu: $DYNAMIDE_MENU_LIST" 
            $EDITOR $DYNAMIDE_MENU_LIST
            return
            ;;
    -es|es)
            shift
            echo "    Edit spaces: $DYNAMIDE_SPACES_LIST" 
            $EDITOR $DYNAMIDE_SPACES_LIST
            return
            ;;
    -i|i|info)
            shift
            bash-menu-showInfo
            return
            ;;
    -l|l|list)
            shift
            bash-menu-log  "    Using list: $FILES_LIST" 
            bash-menu-showList $FILES_LIST
            return
            ;;
    -lm|lm)
            shift
            bash-menu-showList $DYNAMIDE_MENU_LIST
            return
            ;;
    -ls|ls)
            shift
            bash-menu-showList $DYNAMIDE_SPACES_LIST
            return
            ;;
    -m|m|menu)
            shift
            bash-menu-log "Using menu: $DYNAMIDE_MENU_LIST" 
            bash-menu-menu $*
            return
            ;;
    -ma|ma)
            shift
            bash-menu-ma $*
            return
            ;;
    -mx|mx)
            shift
            if [ "$1" != "" ]; then 
                bash-menu-deleteFromList $DYNAMIDE_MENU_LIST $1
                bash-menu-showList "$DYNAMIDE_MENU_LIST"
            else 
                bash-menu-showList "$DYNAMIDE_MENU_LIST"
                bash-menu-menu x
            fi
            return
            ;;
    -x|x|delete)
            DELINDEX=$2
            shift
            shift
            if [ "$DELINDEX" == "" ]; then
                bash-menu-showList $FILES_LIST
                bash-menu-promptAndDeleteFromDirlist
            else 
                bash-menu-deleteFromList $FILES_LIST $DELINDEX
                bash-menu-showList $FILES_LIST
            fi
            return
            ;;
    *)
            bash-menu-log "Selecting option: $1"
            CHOICE=$1
            shift
            break
            ;;
    esac
    done

    if [ "$CHOICE" == "" ] ; then
        bash-menu-showList $FILES_LIST
        while true ; do
            echo -ne "${DM_PROMPTSTART}choose dir>${DM_END} "
            read WHICHDIR
            if [ "$WHICHDIR" == "?" ]; then
               bash-menu-miniHelp 1
            else 
                break
            fi
        done
    #options: Directory Menu
        case "$WHICHDIR" in
        -c|c|connect|-s|s|space)
            space
            return
            ;;
        -e|e|edit)
            echo "    Edit directory list: $FILES_LIST" 
            $EDITOR $FILES_LIST
            return
            ;;
        -h|h|help)
            bash-menu-doHelp
            return
            ;;
        -i|i|info)
            bash-menu-showInfo
            return
            ;;
        -m|m|menu)
            bash-menu-menu
            return
            ;;
        -x|x|delete)
            bash-menu-promptAndDeleteFromDirlist
            return
            ;;
        '')
            return
            ;;
        *)
            bash-menu-chooseFromList $FILES_LIST $WHICHDIR
            return
            ;;
        esac
    else 
        bash-menu-showList $FILES_LIST $CHOICE
        bash-menu-chooseFromList $FILES_LIST $CHOICE
    fi
}   

############## Support Functions ################################

function bash-menu-miniHelp() {
    local DM_UNDERLINE_MENU='\033[04;m'
    local DM_BOLD='\033[01;m'
    local ST="${DM_NORMAL}${DM_BOLD}${DM_UNDERLINE_MENU}"
    local N="${DM_NORMAL}"
    local B="${DM_BOLD}${DM_UNDERLINE_MENU}"
    local SP=`bash-menu-showSpaceLine`
    local SPACE="${N}[$SP${N}]${DM_END}"
    case "$1" in
    1)    
        #directory
        echo -e "   ${ST}c${N}onnect  ${B}e${N}dit  ${B}h${N}elp  ${B}i${N}nfo  ${B}m${N}enu  ${ST}s${N}pace${SPACE}  ${ST}x${N}|${B}d${N}elete${DM_END}"
        return
        ;;
    2)    
        #menu
        echo -e "   ${ST}a${N}dd  ${ST}c${N}onnect  ${B}e${N}dit  ${B}h${N}elp  ${B}i${N}nfo  ${ST}l${N}ist  ${ST}s${N}pace${SPACE}  ${ST}x${N}|${B}d${N}elete${DM_END}"
        return
        ;;
    3)    
        #space
        echo -e "   ${B}e${N}dit  ${B}h${N}elp  ${B}i${N}nfo  ${ST}l${N}ist  ${B}m${N}enu ${DM_END}"
        return
        ;;
    '')
        return
        ;;
    esac
}

function bash-menu-doHelp() {
    if [ "$#" != "0" ]; then
    #options: Help Menu Sub-options
        case "$1" in
        -a|a|aliases)
            bash-menu-showAliases
            return
            ;;
        -i|i|info)
            bash-menu-showInfo
            return
            ;;
        -o|o|options)
            bash-menu-showOptions
            return
            ;;
        '')
            ;;
        *)
            echo "help option not found: '$1'. Showing help main topic."
        esac
    fi
    echo "Usage: "
    echo " Change to a directory in $FILES_LIST"
    echo " Run a command in $DYNAMIDE_MENU_LIST"
    echo " Choose a space in $DYNAMIDE_SPACES_LIST"
    echo 
    echo "Options: "
    echo "  d                   display the directory list for choice"
    echo "  d  {number}         cd to the numbered directory"
    echo "  d  -a  {dirname}    add a directory to the list"
    echo "  d  -c               connect to another space"
    echo "                          ALIASES: -c, c, connect, -s, s, space"
    echo "  d  -x               show the delete menu"
    echo "  d  -x  {number}     delete numbered directory"
    echo "  d  -e               edit the directory menu"
    echo "                          ALIASES: -e, e, edit"
    echo "  d  -em              edit the command menu"
    echo "  d  -es              edit the spaces menu"
    echo "  d  -i               information"
    echo "  d  -l               list the directory list"
    echo "  d  -lm              list the command menu list"
    echo "  d  -ls              list the spaces list"
    echo "  d  -m               show command menu"
    echo "  d  -ma              add the last shell command to menu"
    echo "  d  -ma  {command}   add a command line (spaces OK) to menu"
    echo "  d  -v ...           turn on debugging, exec other flags"
    echo "  d  -q ...           only print required information to stdout, exec other flags"
    echo "  d  -h [topic]       show help. Optional topics: info, options, aliases "
    echo "                          ALIASES: -h, h, help"
    echo 
    echo "  d help options      show more help on how to use options"
    echo "  d help aliases      show all option aliases"
    echo 
   echo "  Documentation: https://github.com/dynamide/bash-menu/blob/master/README.md"
    echo "  Homepage:      http://dynamide.org/bash-menu"
    echo "  Copyright:     (c) 2015 Laramie Crocker"
     
}

function bash-menu-showInfo(){
    echo "info - current config:"
    echo "    \$DYNAMIDE_MENU:             $DYNAMIDE_MENU"
    echo "    \$DYNAMIDE_MENU_SPACE_INDEX: $DYNAMIDE_MENU_SPACE_INDEX"
    echo "    \$DYNAMIDE_SPACES_LIST:      $DYNAMIDE_SPACES_LIST"
    echo "    \$DYNAMIDE_DIRLIST_DEFAULT:  $DYNAMIDE_DIRLIST_DEFAULT"
    echo "    \$DYNAMIDE_DIRLIST_LIST:     $DYNAMIDE_DIRLIST_LIST"
    echo "    ==>"
    echo "      Using files list:         $FILES_LIST" 
    echo "      Using menu list:          $DYNAMIDE_MENU_LIST"     
}

function bash-menu-showOptions() {
    echo "info - options and aliases"
    echo 
    echo "  Options can use the hyphenated, short, or long forms on the command-line:"
    echo "     d -h options"
    echo "     d h o"
    echo "     d help options"
    echo "     d m e            #Launches your EDITOR on the command menu list"
    echo "     d a /var/myDir   #Adds /var/myDir to the directory list"
    echo  "  and in sub-menus (here > means hit the ENTER key) :"
    echo "     d > m > e"
    echo "     d > h > o"
    echo 
    echo "  You can go back and forth from the m list to the s list to the l or m lists, and so on:"
    echo "     d > m > s > m > l"
    echo 
    echo "  To see all option aliases, type either of these: "
    echo "     d h a"
    echo "     d help aliases"
}

function bash-menu-showAliases() {
    echo "info - option aliases"
    echo 
    echo "  Synonyms: "
    echo "      connect = space"
    echo "      d = list"
    echo
    echo "  All option aliases are shown below, grepped from the source."
    echo "  Each option is separated from its aliases by the pipe character: |"
    echo 
    cat $DYNAMIDE_MENU/options-doco
}

function bash-menu-showSpaceLine() {
    local SHOWINDEX=$1
    local DM_BOLD='\033[01;m'
    local line=`bash-menu-getFromList $DYNAMIDE_SPACES_LIST $DYNAMIDE_MENU_SPACE_INDEX`
    regex=".*/spaces/(.*)"
    [[ $line =~ $regex ]]
    name="${BASH_REMATCH[1]}"
    local IDX=''
    local SPNUM=''
    if [ "$SHOWINDEX" == "t" ]; then
        IDX="   ${DM_ADDLINE}s: ${DM_END}"  
        SPNUM=" ${DM_BOLD}[$DYNAMIDE_MENU_SPACE_INDEX]${DM_END}"
        echo  -e "${IDX}${DM_BOLD}${name}${DM_END}${SPNUM}" 
    else 
        echo  -ne "${DM_BOLD}${name}${DM_END}" 
    fi
}

function bash-menu-log() {
    if [ "$DYNAMIDE_DEBUG_DIRLIST" == "v" ]; then 
        echo "$1"
    fi
}

function bash-menu-underlineMsg() {
    if [ "$1" == "-f" ];then
        shift
    else         
        if [ "$DYNAMIDE_DEBUG_DIRLIST" == "q" ]; then 
            return 
        fi
    fi
    echo -en "${DM_UNDERLINE}"
    echo "$1"
    echo -en "${DM_END}"
}

function bash-menu-showList() {
    DM_MENU_SPACE_NAME=`bash-menu-showSpaceLine`
    local BEFORE=`eval "echo $DM_MENU_BEFORE"`
    if [ -n "$BEFORE" ]; then 
        echo -e "$BEFORE"
    fi
    if [ "$DYNAMIDE_DEBUG_DIRLIST" == "q" ]; then 
        return  
    fi
    if [ "${DM_MENUOPTS_SHOWSPACE}" == "t"  ]; then 
        bash-menu-showSpaceLine t
    fi
    unset FILES[@]
    local FILES_LIST=$1
    local SHOW_INDEX=$2
    
    local i=0
    while read line; do 
        FILES[i]="$line" 
        ((i++))
    done < "$FILES_LIST"
    
    if [ "$SHOW_INDEX" == "LAST" ] ; then
        ((SHOW_INDEX=$i-1 ))  
    fi
    
    #first blank line: echo
    local COUNTER=0
    local L=0
    while [  $COUNTER -lt ${#FILES[@]} ]; do
        local file="${FILES[$COUNTER]}"
        if [ "$file" != "" ] ; then
            if [ "${file:0:3}" == "---" ] ; then
                if [ "${file:3}" != "" ] ; then
                    echo "NOOP" > /dev/null
                    echo  -e  "     ${DM_LINENUM}${file:3}${DM_END}"
                else
                    echo
                fi
            else 
                if [ "$COUNTER" == "$SHOW_INDEX" ] ; then
                    echo  -e "   ${DM_ADDLINE}$L: ${DM_ADDLINE_TEXT}$file ${DM_END}"
                else 
                    echo  -e  "   ${DM_LINENUM}$L: ${DM_LINETEXT}$file ${DM_END}"
                fi
                ((L++))
            fi
        else
            echo "    $COUNTER: WARNING: blank link in menu file: $FILES_LIST"
            ((L++))
        fi
        ((COUNTER++)) 
    done  
    
    if [ "$DM_MENU_AFTER" != "" ]; then 
        
        local AFTER=`eval "echo $DM_MENU_AFTER"`
        echo "$AFTER"
    fi
}

function bash-menu-chooseFromList() {
    local FILES_LIST=$1
    local SHOW_INDEX=$2
    local L=0
    while read file; do 
        if [ "$file" != "" ]; then
            if [ "${file:0:3}" != "---" ] ; then
                if [ "$L" == "$SHOW_INDEX" ] ; then
                    
                    local STR=`echo $file`
                    local filename=$(eval "echo $STR")
                    if [ "$file" != "$filename" ]; then
                        bash-menu-log "Expanding $file -> $filename"   
                    fi
                        
                    if [ -e "$filename" ] ; then 
                        bash-menu-underlineMsg "$filename"
                        if [ "$DYNAMIDE_DEBUG_DIRLIST" == "q" ]; then 
                            builtin cd "$filename" 
                        else 
                            bash-menu-log "Changing dir to $filename"   
                            cd "$filename" 
                        fi
                    else 
                        echo -n "File does not exist: "
                        bash-menu-underlineMsg -f "$filename"
                    fi
                    return
                fi
                ((L++))  
            fi
        fi
    done < "$FILES_LIST"
    echo
}

function bash-menu-addToDirlist() {
    NEWDIR=$1
    FILES_LIST=$2
    
    if [ "$NEWDIR" == "" ] || [ "$NEWDIR" == "." ]; then
        NEWDIR=`pwd`
    else
        if [ "${NEWDIR:0:3}" != "---" ]; then
            local FULLPATH=`echo -n "$(builtin cd "$(dirname "$NEWDIR")"; pwd)/$(basename "$NEWDIR")"`
            if [ -d "$FULLPATH" ]; then
                NEWDIR="$FULLPATH" 
            else 
                FULLPATH="`pwd`/$NEWDIR"
                if [ ! -d "$FULLPATH" ]; then
                    echo "WARNING: Adding directory without expansion: '$1'"
                else 
                    NEWDIR="$FULLLPATH"
                fi
            fi
        fi
    fi
    echo "$NEWDIR">>$FILES_LIST
    bash-menu-showList $FILES_LIST "LAST"
}

function bash-menu-promptAndDeleteFromDirlist() {
    echo -ne "${DM_PROMPTSTART}choose index to delete>${DM_END} "
    read DELINDEX
    bash-menu-deleteFromList $FILES_LIST $DELINDEX
    bash-menu-showList $FILES_LIST
}

function bash-menu-deleteFromList() {
    local DIRLIST=$1
    local DEL_INDEX=$2
    if [ "$DEL_INDEX" == "" ]; then
        bash-menu-log "NOT deleting, since index was not specified"  
        return
    fi
    local TS=`date +%H%M`
    cp  $DIRLIST  "$DIRLIST.bak.$TS"
    bash-menu-log "Backup file created: $DIRLIST.bak.$TS"
    local L=0
    while read line; do 
        if [ "$line" != "" ]; then
                if [ "$L" == "$DEL_INDEX" ] ; then
                     bash-menu-log "[$L]: removing $line"
                     ## removing $file by not writing it out here.
                     echo  -e "\n    ${DM_ADDLINE}$L: ${DM_ADDLINE_TEXT}$line ${DM_END}"
                else 
                     bash-menu-log "[$L]: preserving $line"
                     echo "$line" >> "$DIRLIST.tmp"
                fi
                if [ "${line:0:3}" != "---" ]; then
                    ((L++))
                fi
        fi
    done < "$DIRLIST"
    mv "$DIRLIST.tmp" "$DIRLIST"
}

function bash-menu-getFromList() {
    local DIRLIST=$1
    local FIND_INDEX=$2
    local BARE=$3
    if [ "$FIND_INDEX" == "" ]; then
        return 1
    fi
    local L=0
    while read line; do 
        if [ "$line" != "" ]; then
            if [ "${line:0:3}" != "---" ]; then
                if [ "$L" == "$FIND_INDEX" ] ; then
                    if [ "$BARE" == "bare" ]; then
                       echo "$line"
                    else
                       echo "[$L]: $line" 
                    fi
                fi
                ((L++))
            fi
        fi
    done < "$DIRLIST"
}


# arg1 : menu item index
# arg2 : command being run
function bash-menu-logCommandRun() {
    case "$DYNAMIDE_DEBUG_DIRLIST" in
    v)
        local iid=$1
        shift
        echo -n "Running menu item[$iid]: "; bash-menu-underlineMsg  "$*"
        ;;
    q)
        ;;
    f)
        shift
        bash-menu-underlineMsg  "$*"
        ;;
    esac
}

function bash-menu-ma() {
    local CDCMD=''
    echo "1: -$1- all: $* -"
    if [ "$1" == "-cd" ]; then
        shift
        CDCMD="cd `pwd`; "
        echo "CDCMD: $CDCMD"
    fi
    
    if [ "$1" == "" ]; then
        set -x
        set -o history
        var=$(history -p !-1)
        #set +o history
        echo " Adding to menu list: $CDCMD$var"
        echo "$CDCMD$var">>$DYNAMIDE_MENU_LIST
        set +x
        bash-menu-showList $DYNAMIDE_MENU_LIST "LAST"
        return
    fi
    local NEWCMD=$*
    local MMTMP=`echo "$NEWCMD" | xargs`     ##expand the command
    echo "$CDCMD$MMTMP">>$DYNAMIDE_MENU_LIST
    bash-menu-showList $DYNAMIDE_MENU_LIST "LAST"
}

function bash-menu-promptAdd() {
    echo -ne "${DM_PROMPTSTART}enter command to add>${DM_END} "
    read WHICHSPACE
    if [ "$WHICHSPACE" == "" ] ; then
        return;
    fi
    bash-menu-ma "$WHICHSPACE"
}

function bash-menu-menu() {
    local WHICHITEM
    
    if [ "$1" == "" ] ; then
        bash-menu-showList "$DYNAMIDE_MENU_LIST"
        while true ; do
            echo -ne "${DM_PROMPTSTART}choose command>${DM_END} "
            read WHICHITEM
            if [ "$WHICHITEM" == "?" ]; then
               bash-menu-miniHelp 2
            else 
                break
            fi
        done
        if [ "$WHICHITEM" == "" ] ; then
            return;
        fi
    else 
        WHICHITEM="$*"
        shift
    fi
    
    local CMD=$(echo  "$WHICHITEM" | awk '{ print $1 }')
    local ARGS=$(echo "$WHICHITEM" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}')    #print everything but the first arg, $1.
    #options: Command Menu
    case "$CMD" in
        -a|a|add)
            bash-menu-promptAdd
            return
            ;;
        -c|c|connect|-s|s|space)
            space "$ARGS"
            return 
            ;;
        -em|e|edit)
            echo "    Edit menu: $DYNAMIDE_MENU_LIST" 
            $EDITOR $DYNAMIDE_MENU_LIST
            return
            ;;
        -d|d|list|-l|l|list)
            bash-menu-d
            return    
            ;;
        -h|help)
            bash-menu-doHelp "$ARGS"
            return
            ;;
        -i|i|info)
            bash-menu-showInfo
            return
            ;;
        -x|x|delete)
            echo -ne "${DM_PROMPTSTART}choose index to delete>${DM_END} "
            read DELINDEX
            bash-menu-deleteFromList $DYNAMIDE_MENU_LIST $DELINDEX
            bash-menu-showList "$DYNAMIDE_MENU_LIST"
            return
            ;;
    esac
    
    if [[ $WHICHITEM =~ ^-?[0-9]+$ ]] ; then   # WHICH_ITEM is an integer.
        local L=0
        while read line; do 
            if [ "$line" != "" ] && [ "${line:0:3}" != "---" ] ; then
                if [ "$L" == "$WHICHITEM" ] ; then
                    bash-menu-logCommandRun $WHICHITEM $line $* 
                    history -s "$line $*"
                    eval "$line $*"
                    return
                fi
                ((L++))
            fi
        done < "$DYNAMIDE_MENU_LIST" 
    fi                                                                
}

function space() {
    bash-menu-log "DYNAMIDE_DIRLIST_LIST: $DYNAMIDE_DIRLIST_LIST"
    bash-menu-log "DYNAMIDE_SPACES_LIST:  $DYNAMIDE_SPACES_LIST"
    
    if [ "$1" == "-q" ]; then
        shift
    elif [ "$1" == "" ]; then  
        bash-menu-showList "$DYNAMIDE_SPACES_LIST" "$DYNAMIDE_MENU_SPACE_INDEX"
    fi
    
    if [ "$1" == "" ] ; then
        while true ; do
            echo -ne "${DM_PROMPTSTART}choose space>${DM_END} "
            read WHICHSPACE
            if [ "$WHICHSPACE" == "?" ]; then
               bash-menu-miniHelp 3
            else 
                break
            fi
        done
        if [ "$WHICHSPACE" == "" ] ; then
            return;
        fi
    else 
        WHICHSPACE=$1
    fi
    
    local CMD=$(echo "$WHICHSPACE" | awk '{ print $1 }')
    #local ARGS=$(echo "$WHICHSPACE" | awk '{$1=""; print $0}')    #print everything but the first arg, $1, but with a whitespace in front.
    local ARGS=$(echo "$*" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}')    #print everything but the first arg, $1.
    #options: Space Menu
    case "$CMD" in
        -h|h|help)
            bash-menu-doHelp "$ARGS"
            return
            ;;
        -es|e|edit)
            echo "    Edit space: $DYNAMIDE_SPACES_LIST" 
            $EDITOR $DYNAMIDE_SPACES_LIST
            return
            ;;
        -m|m|menu)
            bash-menu-menu "$ARGS"
            return
            ;;
        -d|d|list|-l|l|list)
            bash-menu-d
            return  
            ;;
        -i|i|info)
            bash-menu-showInfo
            return
            ;;
    esac
    
    if [[ $WHICHSPACE =~ ^-?[0-9]+$ ]] ; then   # WHICHSPACE is an integer.
        local L=0
        while read line; do 
            if [ "$line" != "" ] ; then
                if [ "${line:0:3}" == "---" ] ; then
                    bash-menu-log  "separator"
                else 
                    if [ "$L" == "$WHICHSPACE" ] ; then
                        local STR=`echo $line`
                        local filename=$(eval "echo $STR")
                        if [ "$line" != "$filename" ]; then
                            bash-menu-log "Expanding $line -> $filename"   
                        fi
                        if [ -e "$filename" ] ; then 
                            export DYNAMIDE_DIRLIST_LIST="$filename/directories.list"
                            export DYNAMIDE_MENU_LIST="$filename/menu.list"
                            bash-menu-log "Changing to space[$WHICHSPACE] $filename" 
                            echo "$WHICHSPACE" > "$DYNAMIDE_MENU/space.index"
                            export DYNAMIDE_MENU_SPACE_INDEX="$WHICHSPACE"
                            return
                        else
                            echo "Space file does not exist: $filename"
                        fi
                    fi
                    ((L++))
                fi
            fi
        done < "$DYNAMIDE_SPACES_LIST" 
    fi
}

