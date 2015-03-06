# bash-menu

<img src="http://dynamide.org/bash-menu/img/prompt-2.png" />

<a href="#introduction">Introduction</a>
<a href="#getting-the-source">Getting the source</a>
<a href="#optional-installation-locations">Optional installation locations</a>
<a href="#help-in-bash-menu">Help in bash-menu</a>
<a href="#using-bash-menu">Using bash-menu</a>
<a href="#sub-commands">Sub-commands</a>
<a href="#editing">Editing</a>
<a href="#using-the-title-command">Using the _title_ command</a>
<a href="#examples">Examples</a>

## Introduction
**dynamide** [bash-menu](http://dynamide.org/bash-menu) is a menu system for bash which keeps lists of
- directories you wish to navigate to
- command lines you wish to execute
- spaces, which group directories and commands by project

You use the menu to select from these lists.  Selecting a directory from a menu changes to that directory.  Selecting a command from a command menu executes that command.  You can use the menu or the command line to add to, remove from, and edit these lists.

A fancy bash-prompt is also provided, which give you options to display on one line the title, user, host, pwd, and git-status.  See [Using the *title* command](#using-the-title-command).

After you install bash-menu and log in, you'll have a custom prompt, and some new commands:
-   **d**        directory changer
-   **da**       add a directory to the list
-   **m**        menu of executable command-lines
-   **ma**        add a command to the list
-   **catall**   cat all text files in current directory with a colored line between each.
-   **title**    set the title, user, or hostname in a multi-line, colored PS1 bash prompt.

## Getting the source

On [GitHub](https://github.com/dynamide/bash-menu), mash on the "Download ZIP" button, and extract to `~/.bash-menu`, or use wget or curl:

     cd ~
     curl -o master.zip  https://codeload.github.com/dynamide/bash-menu/zip/master
     unzip master.zip
     mv bash-menu-master/ ~/.bash-menu/

Or, checkout bash-menu from GitHub:

     cd ~
     git clone https://github.com/dynamide/bash-menu.git .bash-menu

or

     cd ~
     git clone git@github.com:dynamide/bash-menu.git .bash-menu

Then pull in the bash-menu from your bash profile, by sourcing in the bash menu, e.g.

| _~/.bash_profile_  |
| :------------- |
| source ~/.bash-menu/.bash_profile |

You can source with  `.` or `source`.

All of the shell aliases created by bash-menu are defined in `~/.bash-menu/aliases` (or `$DYNAMIDE_MENU/aliases`).  Please review these aliases before launching.

The next time you log in, you'll have a custom prompt, and some new commands. Try the main command `d` for example.

Here is a sample bash prompt on two lines with current working directory, and git status:

<img src="http://dynamide.org/bash-menu/img/prompt-1.png" />

## Optional Installation Locations

By default, the above check-out will leave you with a new, hidden directory in your home directory, that is, `~/.bash-menu`, or something like `/home/laramie/.bash-menu/`.  **bash-menu** knows about this because it sets DYNAMIDE_MENU in `~/.bash-menu/.bash_profile`.

If you checked out to some directory other than `~/.bash-menu`, for example `~/.my-menu/` then you need to do two things to connect **bash-menu** to your shell.

1) Edit this file, on the line where it sets DYNAMIDE_MENU (by default it is `DYNAMIDE_MENU=~/.bash-menu`), so that **bash-menu** will know where its home directory is.

| _~/.my-menu/.bash_profile_  |
| :------------- |
| DYNAMIDE_MENU=~/.my-menu |
| ... |


2) Then, in your ~/.bash_profile source in the **bash-menu** control file we just edited:

| _~/.bash_profile_  |
| :------------- |
| source ~/.my-menu/.bash_profile |


## Help in bash-menu
To see help, run with `-h` or `h` which will dump out usage.

`d -h`

To see help on options:

`d h options`

To see all the options and their alternate spellings, see:

`d h aliases`

To see the current configuration, see:

`d h info`

## Using bash-menu

To get started, just type `d` at your new prompt.  From there you can choose a listed item by typing it's number.

Here is the dynamide bash-menu being used to change to directory 6 on the menu:

<img src="http://dynamide.org/bash-menu/img/menu-1.png" />

Note that it shows you the directory you chose, "/Users/vcrocla/src/dynamide/build/resource_root", and then a quick "ls" of that directory, then it changes to that directory.  You can tell because the fancy bash prompt has changed and now shows the current working directory as /Users/vcrocla/src/dynamide/build/resource_root, and the git status in that directory is (master) which means we are on git branch "master" with no pending pulls or pushes.

From a menus such as the directory menu, you can type another menu option.  You can type `?` to see the mini-help of sub-commands at this menu.

<img  src="http://dynamide.ORG/bash-menu/img/miniHelp.png" />

## Sub-commands

You can choose options on the command line, and skip the menus.  You can also choose some options after you have launched bash-menu and are sitting in a menu, where you are prompted for a choice.  If you type a number from the list of choices, you will get that choice.  But there are also sub-commands at these menus.  These mirror options available on the command line.  So you could, for example, launch right into your command menu like this:

`d -m`

Or, you could launch the directory menu, then change to the command menu with this sequence:
```
d
    m
```

This represents typing `d` at your bash prompt, then typing `m` at the **choose dir>** prompt.

The `edit` sub-command is context-sensitive, and will launch your EDITOR or VISUAL editor to let you edit the correct menu.

Here is an actual example:

<img width="474" src="http://dynamide.org/bash-menu/img/sub-commands.png" />

The sub-commands take an option form: `-h`, a single-letter form: `h`, and a word form:  `help`.

Here are all the sub-command options and their equivalents (-c and -s are completely equivalent):


| option  | cmd | cmd | context |
| ------------- | ------------- | ------------- | ------------- |
| -a  | a | add |directory, command|
| -c  | c | connect |directory, command|
| -d  | d | list  |command, space|
| -e  | e  | edit |*|
| -h  | h | help |*|
| -i  | i | info |*|
| -l  | l | list |command, space |
| -m  | m | menu |directory, space|
| -s  | s | space |directory, command|
| -x  | x | delete |directory, command|
| -o  | o | options |help|
| -a  | a | aliases |help|
| -i  | i | info |help|


Options or _cmd_ may be used on the command line.

Options or _cmd_ may be used as sub-commands.

Help takes subcommands `options`, `aliases`, and `info`, or their alternate names listed above.  For example:

```
d h info
```

On the command line, these options could look like these examples:
```
d a          # Add to your directory list

d e          # Edit your directory list

d m          # Show your command menu
d -m

d m e        # Edit your command menu
d m -e
d m edit

d s e        # Edit your spaces menu
d s -e
d -s edit
d -s -e
d s edit
```
And so on.

## Using the *title* command

bash-menu comes with a custom PS1 bash prompt.  This prompt can show you:
- title
- user
- host
- pwd
- git-status

To see all the options, type

`title -h`

Here is a sample of what setting various options does to your prompt:

<img src="http://dynamide.ORG/bash-menu/img/title-examples.png"></img>

In these examples, my user name is "vcrocla", my host is "SFCAML-G2XFD56", which I override with the fake hostname "myhost".

The title (appears at left of the first line) is any placeholder that reminds you of what this shell was for.  If you use -w, or -window, the title is also sent to the shell window's title bar.

My directory "~/src/tagonomy" is a git repository, and its git status in that directory is (master) which means we are on git branch "master" with no pending pulls or pushes.  My directory "~/src/dynamide" is also a git repository, and also is on branch "master".

You'll also see the numbers of commits ahead/behind if you are not up-to-date. (Thanks to the authors who wrote `git-branch-status`, listed in our <a href="https://github.com/dynamide/bash-menu/blob/master/NOTICE">NOTICE</a> file.)

Here is what it looks like when you are ahead:

<img src="http://dynamide.ORG/bash-menu/img/git-ahead.png"></img>

If you type `git status` you'll see why:

<img src="http://dynamide.ORG/bash-menu/img/git-ahead-status.png"></img>

Here is what it looks like when you are ahead and behind:

<img src="http://dynamide.ORG/bash-menu/img/git-ahead-behind.png"></img>

If you type `git status`  (I have it aliased to `st`) you'll see why:

<img src="http://dynamide.ORG/bash-menu/img/git-ahead-behind-status.png"></img>

To customize your prompt, call `title` in your ~/.bash_profile *after* you source in ~/.bash-menu/.bash_profile:

| _~/.bash_profile_  |
| :------------- |
| source ~/.bash-menu/.bash_profile |
| source ~/.laramie/.bash_profile |

| _~/.laramie/.bash_profile_  |
| :------------- |
| DYNAMIDE_SPACES_LIST=~/.laramie/spaces.laramie.list |
| title -user -nohost -title Lappy -window |

## Editing

You can edit your menus in two ways:
- 1. using the command-line args or sub-commands in menus, and
- 2. using your console editor such as `vi` or `emacs`.

For case (2), bash-menu will launch your EDITOR or VISUAL editor on the appropriate file.  Just edit, then save normally.  Files contain non-blank lines or separators.  Separators are three hyphens alone on one line, like this:
```
/some/directory/on/dirlist
---
/other/dirs
/other/dirs/bin
```

| _Sub-commands:_  ||
| :------------- | :------------- |
|d x       | launches the delete menu for directory lists|
|d x 3     | deletes directory list item 3|
|d mx      | launches the delete menu for commands|
|d mx 3    | deletes command menu item 3|
|d m x     | launches the delete menu for commands, using submenu|
|d ma      | add to the command menu, using command-line|
|d m a     | add to the command menu, using submenu|
|d e       | launch EDITOR for directory lists|
|d m e     | launch EDITOR for the command menu|
|d s       | launch the space chooser|


##Examples

**Show your directory menu**

    d

**Show your command menu**

    m

**put shell history item 467 (expanded) into your menu**

    d -ma !467

**put a command into your menu using the alias `ma` (installed in ~/.bash-menu/aliases)**

    ma find . -iname '*my-file.*'

**chose menu item 2 and execute it**

    d -m 2

**chose menu item 2 and execute it**

    m 2

**put a separator into your menu using the special string ---**

    ma ---

**Add ~/zanzibar (expanded) to your directory list**

    d -a ~/zanzibar

**Add ~/zanzibar (NOT expanded) to your directory list**

    d -a '~/zanzibar'

**Add $JAVA_HOME (NOT expanded) to your directory list**

    d -a '$JAVA_HOME'

**Add $JAVA_HOME (expanded) to your directory list**

    d -a $JAVA_HOME

**Choose directory 2 from your directory list**

    d 2

**Add . (expanded using \`pwd\`) to your directory list**

    d -a .

**Add `foo` in current directory (expanded using `pwd`/foo) to your directory list**

    d -a foo

**Add /var/log (full path, unexpanded) to your directory list**

    d -a /var/log

**Add a frequently used Maven (mvn) command to the menu and use the menu to run it.  The command is
`mvn -DskipTests -o install`  and we are adding the whole thing using the ma command.**

<img  width="424" src="http://dynamide.org/bash-menu/img/menu-add.png" />

`mvn` is a popular build tool.  You can see where it begins to run with the line "[INFO] Scanning for projects...

**Re-run that command without looking at the menu, now that you know the number**

<img width="303" src="http://dynamide.org/bash-menu/img/menu-2.png" />

*You could also run the command in your shell, then use the `ma` command to capture the command to your command list in your current space.  The ma command will take a command-line as its arguments.  With no arguments, the ma command grabs the last item on your history.  Note that you need to read the output of the ma command to see the index of the new command, in this case, the number `4`.*

```
mvn -DskipTests -o install
ma
m 4
```

<img width="450" src="http://dynamide.org/bash-menu/img/ma.png" />
