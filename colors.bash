# \033[ATTRIBUTE;TEXT;BACKGROUNDm
export DM_END='\033[0m'
export DM_PROMPTSTART='\033[1;m'
export DM_UNDERLINE='\033[04;35m'
export DM_ADDLINE='\033[1;34m'
export DM_ADDLINE_TEXT='\033[01;34m'
export DM_LINENUM='\033[1;32m'
export DM_LINETEXT='\033[1;33m'
export DM_REVERSE='\033[07;33m'
export DM_BOLD='\033[01;33m'
export DM_NORMAL='\033[00;33m'
        
        



########################## bash color codes ####################################
# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed 
# 
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# 
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
# 
# In the example above, me used the ANSI escape sequence 
#            \e[attribute code;text color codem 
# to display a blue text. Therefore, we have to use -e option in calling echo to escape the input. 
# Note that the color effect had to be ended by 
#       \e[0m 
# 
# To have a background, we must use the background color codes. 
# The sequence then becomes \e[attribute code;text color code;background color codem. 

