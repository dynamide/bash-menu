# bash-menu

<img src="http://dynamide.org/bash-menu/img/prompt-2.png" />

<a href="#introduction">Introduction</a>  
<a href="#philosophy--workflow">Philosophy / Workflow</a>  
<a href="#getting-the-source">Getting the source</a>  
<a href="#optional-installation-locations">Optional installation locations</a>  
<a href="#help-in-bash-menu">Help in bash-menu</a>  
<a href="#using-bash-menu">Using bash-menu</a>  
<a href="#sub-commands">Sub-commands</a>  
<a href="#editing">Editing</a>
<a href="#using-the-title-command">Using the _title_ command</a>  
<a href="#scripting">Scripting</a>  
<a href="#examples">Examples</a>  

## Introduction
**dynamide** [bash-menu](http://dynamide.org/bash-menu) is a menu system for bash which keeps lists of 
- directories you wish to navigate to
- command lines you wish to execute
- spaces, which group directories and commands by project
 
Here's a screenshot showing launching the directory menu, then switching to the command menu:

<img width="350" src="http://dynamide.org/bash-menu/img/sub-commands.png" />

You use the menu to select from these lists.  Selecting a directory from a menu changes to that directory.  Selecting a command from a command menu executes that command.  You can use the menu or the command line to add to, remove from, and edit these lists.

A fancy bash-prompt is also provided, which gives you options to display on one line the title, user, host, pwd, and git-status.  See [Using the *title* command](#using-the-title-command).

After you install **bash-menu** and log in, you'll have a custom prompt, and some new commands:
-   **d**        directory changer
-   **da**       add a directory to the list
-   **m**        menu of executable command-lines
-   **ma**        add a command to the list
-   **catall**   cat all text files in current directory with a colored line between each.
-   **title**    set the title, user, or hostname in a multi-line, colored PS1 bash prompt.
 
## Philosophy / Workflow

#### Why do you want a bash menu?  
- You are a whiz at `history`, tab-completion, expansion, reverse-search... but you still have to ask: what am I doing here, how did I get here, and what do I do next?
- you work on several projects, and having them all together in one history list doesn't help
- you work in multiple terminals simultaneously, and synchronizing the histories doesn't help
- you prefer command-line tools for their configurable options, but so many options to remember!
- you hate typing long paths or aliasing everything
- you run multiple, complicated command lines repeatedly, but they aren't quite ready for putting into scripts yet.

#### Prototyping Workflow

**Scenario 1**  
Execute command-by-command at the command-line, until you get one that does just what you want it to do.
Add that last command by executing `ma` which grabs the last item from your history and adds it to the command menu.

**Scenario 2**  
You have completed a prototyping session locally, and would like to write a script to capture all the steps you did.
List your history, then cherry-pick the commands you want using `ma <command-line>`.

```
history
473 cd /src/myproject
474 ./ant
475 cd /var/log/foobar
476 dir
477 rm /var/log/foobar/*
478 /usr/local/bin/restartdb
```

Now just grab the ones you want, then bring up the command list in EDITOR:

```
ma !477
ma !473
ma !474
ma !478
d m e
```

#### Spelunking Workflow

You work in many directories, and often use paths like `./exec-foo`.  To use your history, you need to know which directory you were in.  If you `cd` or `pushd` incrementally, your history is not much help here.  If you use **bash-menu** to store the path and the command together, you have a re-useable item that is quicker to create than a script, but more reliable than using `history`.

```
cd ~/bin
dir
cd tomcat7.dm
dir
cd conf
vi server.xml
cd ..
bin/startup.sh
ma -cd
```

Now when you type `m` you'll see something like this item at the bottom of your command menu:

    7: cd /Users/laramie/bin/tomcat7.dm ; bin/startup.sh

How did that work?  Well, the `ma` command has a built-in option `-cd` to add the `cd ...;` for you.  It automatically uses the last item on your history if you specify nothing. It is effectively doing this (which you can also type in if you want): 

```
ma cd `pwd` \; !!
```

Now, any time you want to start tomcat, just do 

```
m 7
```

#### Polyglot Workflow

Set up each project with scripts and buildfiles in the appropriate directories.  Mark these scripts and directories using **bash-menu** in one *space*, using menu <a href="#separators">separators</a> to group commands by area.  The menus serve to remind you where the key build directories are, and the commands you'll need once you are there.  

#### Contractor Workflow

You work on multiple projects, and have many command-lines, scripts, directories, and builds to remember.  Store each project under a `space`, and switch between spaces using **bash-menu**. the command `d s` brings up the space menu from the command-line, and from a **bash-menu** directory or command menu prompt, you can just type `s`.  When you change spaces, your directory list and your command menu change.  When you are in another terminal or another project, just navigate to the space you want.

## Getting the source

On [GitHub](https://github.com/dynamide/bash-menu), mash on the "Download ZIP" button, and extract to `~/.bash-menu`, or use wget or curl:

     cd ~
     curl -o master.zip  https://codeload.github.com/dynamide/bash-menu/zip/master
     unzip master.zip
     mv bash-menu-master/ ~/.bash-menu/

Or, checkout **bash-menu** from GitHub: 

     cd ~
     git clone https://github.com/dynamide/bash-menu.git .bash-menu

or

     cd ~
     git clone git@github.com:dynamide/bash-menu.git .bash-menu

Then pull in the **bash-menu** from your bash profile, by sourcing in the bash menu, e.g.

| _~/.bash_profile_  |
| :------------- |
| source ~/.bash-menu/.bash_profile |

You can source with  `.` or `source`.

All of the shell aliases created by bash-menu are defined in `~/.bash-menu/aliases` (or `$DYNAMIDE_MENU/aliases`).  Please review these aliases before launching.

The next time you log in, you'll have a custom prompt, and some new commands. Try the main command `d` for example.

Here is a sample bash prompt on two lines with current working directory, and git status:

<img src="http://dynamide.org/bash-menu/img/prompt-1.png" />

## Optional Installation Locations

By default, the above check-out will leave you with a new, hidden directory in your home directory, that is,
```
~/.bash-menu
```

or something like `/home/laramie/.bash-menu/`.  **bash-menu** knows about this because it sets DYNAMIDE_MENU in `~/.bash-menu/.bash_profile`.

| _~/.bash-menu/.bash_profile_  |
| :------------- |
| DYNAMIDE_MENU=~/.bash-menu |
| ... |

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

Here is the dynamide **bash-menu** being used to change to directory 6 on the menu:

<img src="http://dynamide.org/bash-menu/img/menu-1.png" />

Note that it shows you the directory you chose, "/Users/vcrocla/src/dynamide/build/resource_root", and then a quick "ls" of that directory, then it changes to that directory.  You can tell because the fancy bash prompt has changed and now shows the current working directory as /Users/vcrocla/src/dynamide/build/resource_root, and the git status in that directory is (master) which means we are on git branch "master" with no pending pulls or pushes.

## Sub-commands

From menus such as the directory menu, you can type another menu option.  You can type `?` to see the mini-help of sub-commands at this menu.

<img  src="http://dynamide.ORG/bash-menu/img/miniHelp.png" />

You can choose options on the command line, and skip the menus.  You can also choose some options after you have launched **bash-menu** and are sitting in a menu, where you are prompted for a choice.  If you type a number from the list of choices, you will get that choice.  But there are also sub-commands at these menus.  These mirror options available on the command line.  So you could, for example, launch right into your command menu like this:

`d -m`

Or, you could launch the directory menu, then change to the command menu with this sequence: 

`d` `Enter` `m` `Enter`

that is, typing `d` at your bash prompt, then the `Enter` key (or `Return` key) then typing `m` at the **choose dir>** prompt, then `Enter` again.

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


The _option_ form or the _cmd_ form may be used on the command line, or as sub-commands.

Help takes subcommands `options`, `aliases`, and `info`, or their alternate names listed above.  For example: 

```
d h info
```

The `edit` sub-command is context-sensitive, and will launch your EDITOR or VISUAL editor to let you edit the correct menu.

On the command line, using these options could look like these examples below.  Eeach group of commands is equivalent, so `d m` is the same as `d -m`:
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

`d -ma` takes a special option flag, `-cd` that adds a `cd` to the current directory before the command you are adding. 

    d -ma -cd        #adds the last shell command to your command menu with a cd `pwd` before it.
    d -ma -cd !!     #adds the last shell command to your command menu with a cd `pwd` before it.
    d -ma -cd !480   #adds shell history command number 480 to your command menu with a cd `pwd` before it.
    d -ma -cd bin/make     #adds 'bin/make' to your command menu with a cd `pwd` before it.

This works with the alias `ma` like so: 

    ma -cd
    ma -cd bin/make

NOTE: *There is no alias for -cd, so you can* **NOT** *do this without the hyphen on -cd:* ~~d -ma cd /bin/mycommand~~.   
In other words: 

LEGAL----> `d -ma -cd /bin/mycommand`

ILLEGAL--> `d -ma cd /bin/mycommand`

## Using the *title* command

**bash-menu** comes with a custom PS1 bash prompt.  This prompt can show you:
- title 
- user 
- host 
- pwd 
- git-status
 
To see all the options, type 

`title -h`

Here is a sample of what setting various options does to your prompt:

<img width="500" src="http://dynamide.ORG/bash-menu/img/title-examples.png"></img>

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
 
For case (2), **bash-menu** will launch your EDITOR or VISUAL editor on the appropriate file.  Just edit, then save normally.  Files contain non-blank lines or <a href="#separators">separators</a>.  


| _Sub-commands:_  |Editing Action|
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
|d s e     | launch the space editor|

### Separators

Separators are three hyphens alone on one line, like this:
```
/some/directory/on/dirlist
---
/bin/probe
---
/other/dirs
/other/dirs/bin
```
Separators display in your menus as blank lines.  So the above menu renders as: 

<img width="320" src="http://dynamide.ORG/bash-menu/img/separators-plain.png"></img>

You can also put line-separating labels in, which will be displayed in your menu in highlight color, minus the leading `---`.  You can use more `-` characters on that line, or any other printable character.  Here I'm using `=` characters to help visually break up the menu.
```
/some/directory/on/dirlist
---=== Area 51 ===
/bin/probe
---=== Area 52 ===
/other/dirs
/other/dirs/bin
```
<img width="300" src="http://dynamide.ORG/bash-menu/img/separators.png"></img>


##Scripting

In case you want to use **bash-menu** in a script itself, you'll want to use the quiet option: `-q` which suppresses all but the most essential output.  The opposite is `-v` which gives debugging info.

To keep things simple, you may wish to avoid aliases in your scripts and use the full names of things, e.g. instead of calling `d`, call `bash-menu-d` which is the name of the main bash function that `d` is aliased to.

Remember that all `d` and `m` commands are relative to the current *space*, so you should change to your space first, or set it using DYNAMIDE_SPACES_LIST. You can programmatically set your space, e.g. by calling `d s 0` to select space `0` or `d s 1` to select space `1`.  (NOTE: $DYNAMIDE_MENU/space.index is written out for you.  However, you can overwrite it with the zero-based index of the space you want to use in DYNAMIDE_SPACES_LIST.  Usually, `d s 0` is the preferred way.)

After you call to set the space, e.g. `d s 0`, the following values are exported to your shell:
```
DYNAMIDE_DIRLIST_LIST
DYNAMIDE_MENU_LIST
DYNAMIDE_MENU_SPACE_INDEX
```

Here is how to set the env var to point to a specific space list, e.g. 
`DYNAMIDE_SPACES_LIST=~/.laramie/spaces.laramie.list`

Here is how to programmatically get the menu line for an item in a file:

```
line=`bash-menu-getFromList $DYNAMIDE_SPACES_LIST $DYNAMIDE_MENU_SPACE_INDEX`
```

will output:
```
[1]: /Users/vcrocla/.laramie/spaces/pearson
```

Here is how to programmatically get the bare menu line for an item in a file without the index being displayed:

```
line=`bash-menu-getFromList $DYNAMIDE_SPACES_LIST $DYNAMIDE_MENU_SPACE_INDEX bare`
```

This technique can be used to read a line from any of the files: directories.list, menu.list, spaces.list, by passing the list name, and the zero-based index of non-separator lines.  (Blank lines are not allowed in the list files.)  For example, get the 3rd item (index 2) from your directory list: 

```
line=`bash-menu-getFromList $DYNAMIDE_DIRLIST_LIST 2 bare`
```

For example, get the 4th item (index 3) from your menu list: 

```
line=`bash-menu-getFromList $DYNAMIDE_MENU_LIST 3 bare`
```


##Examples


###Show your directory menu

    d     

###Show your command menu

    m 

###put shell history item 467 (expanded) into your menu

    d -ma !467     

###put a command into your menu using the alias `ma` (installed in ~/.bash-menu/aliases)

    ma find . -iname '*my-file.*'     

###chose menu item 2 and execute it

    d -m 2         

###chose menu item 2 and execute it

    m 2   
###put a separator into your menu using the special string ---

    ma ---    

###put a separating label into your menu using the special string ---

    ma ---Build RestReplay

Everything after the `---` is treated as the label.  Note that you don't need quotes around "Build RestReplay" because the ma command just grabs everything: `---Build RestReplay` is put into your menu on a line by itself.

  *Use separating labels help to organize and document groups in one list.  Consider using the space feature, with the `d s` command, for working on other servers, or organizing by projects.* 

###Add ~/zanzibar (expanded) to your directory list

    d -a ~/zanzibar

###Add ~/zanzibar (NOT expanded) to your directory list

    d -a '~/zanzibar'

###Add $JAVA_HOME (NOT expanded) to your directory list

    d -a '$JAVA_HOME'

###Add $JAVA_HOME (expanded) to your directory list

    d -a $JAVA_HOME

###Choose directory 2 from your directory list

    d 2

###Add . (expanded using \`pwd\`) to your directory list

    d -a .

###Add `foo` in current directory (expanded using `pwd`/foo) to your directory list

    d -a foo

###Add /var/log (full path, unexpanded) to your directory list

    d -a /var/log

###Add a frequently used Maven (mvn) command to the menu and use the menu to run it.  

The command is `mvn -DskipTests -o install`  and we are adding the whole thing using the `ma` command.

<img  width="424" src="http://dynamide.org/bash-menu/img/menu-add.png" />

`mvn` is a popular build tool.  You can see where it begins to run with the line "[INFO] Scanning for projects...

###Re-run that command without looking at the menu, now that you know the number

<img width="303" src="http://dynamide.org/bash-menu/img/menu-2.png" />

*You could also run the command in your shell, then use the `ma` command to capture the command to your command list in your current space.  The ma command will take a command-line as its arguments.  With no arguments, the ma command grabs the last item on your history.  Note that you need to read the output of the ma command to see the index of the new command, in this case, the number `4`.*

```
mvn -DskipTests -o install
ma
m 4
```

<img width="450" src="http://dynamide.org/bash-menu/img/ma.png" />

