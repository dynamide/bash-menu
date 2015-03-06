export DYNAMIDE_MENU=~/.bash-menu

source  $DYNAMIDE_MENU/colors.bash
source  $DYNAMIDE_MENU/functions.bash
source  $DYNAMIDE_MENU/aliases
source  $DYNAMIDE_MENU/d.bash
source  $DYNAMIDE_MENU/ps1.bash


#===========================================================
#  You can customize bash-menu by overriding these here,
#   or in your own .bash_profile *after* sourcing this file.
#===========================================================

#You can insert a blank line before your menus with this:
DM_MENU_BEFORE=' '
#You can insert a blank line after your menus with this:
DM_MENU_AFTER=' '
#You can also define a line of text for before and after.  (note: \n won't work).
DM_MENU_BEFORE='----------------------------------$DM_MENU_SPACE_NAME------------'
DM_MENU_AFTER='---------------------------------------------------'
#You can override both by setting to null:
DM_MENU_BEFORE=
DM_MENU_AFTER=

#Show the current space as the first item in the menu ( =t to show, =f to override)
DM_MENUOPTS_SHOWSPACE=f


