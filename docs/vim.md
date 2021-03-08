## (N)VIM

From `uwu` to `owo` ([Source](https://thevaluable.dev/vim-advanced/))

### Basic
```
:help               # send help pls
:wq!                # write | quit | overwrite
:e <path>           # edit a file

hjkl                # Left Bottom Top Right

esc or CTRL-c       # back to normal mode

u                   # undo
CTRL-r              # redo
```

### Insert Mode
```
i                   # insert before current character
a                   # insert after current character
A                   # insert to the end of the line
o                   # insert in a new line below the current
O                   # open a new line in the current one
```

### Move (horizontally)
```
w                   # move forward to the next word
b                   # move back to the previous word

0                   # move to the beginning of the current line
$                   # move to the end of the current line
^                   # move to the first non-blank character on the current line
%                   # move to the matching bracket when the cursor is already on a bracket

f<character>        # find a character after your cursor
F<character>        # find a character before your cursor
```

### Move (vertically)
```

G                   # move to the last line of the file
gg                  # move to first line of the file (same as 1G)
<line_num>G         # move at the beginning of the selected line

# Scroll
CTRL-e              # scroll downward
CTRL-e              # move upward half a screen
CTRL-d              # move downward half a screen
```

### Search
```
/<substring>        # search (n-N as next-prev)
```

### Operators
```
d                   # delete
D                   # delete from cursor to the end of the line (same as d$)
dgg                 # delete from cursor to the beginning of the file
ggdG                # delete everything

c                   # change

y                   # yank (copy)
p                   # put (paste)

diw                 # delete inside the word (delete current word under the cursor)
ciw                 # change inside the word (change current word under the cursor)
dip                 # delete inside the paragraph
```

### The g keystroke

#### In --NORMAL-- mode
```
gf                  # edit the file located at the filepath under your cursor (to open in a new window: CTRL+W CTRLF)
gx                  # open the file/url located under your cursor (with the default app, eg. a browser for urls)
gi                  # move to the last insertion you did and swith to INSERT mode
gv                  # start VISUAL mode and use the selection made during the last VISUAL mode
gn                  # select the match of the latest search
gI                  # insert text at the beginning of the line
```

### Range
Separated by commas `,`, the most usefull are:
- `<number>`: a line number;
- `.`: the current line;
- `$`: the last line of the current bufer;
- `%`: the entire file (same as `1,$`);
- `*`: the last selection made during the last VISUAL mode;
```
:1,40d              # Delete line 1 to 40 included
:2,$d               # Delete every line from the second one till the end of the file
:.,$d               # Delete every line from the current one till the end of the file
:%d                 # Delete every line

.,.+10              # if the current line is 60, it will be equivalent to the range 60,70
```
Switching to COMMAND-LINE mode after doing some selection in VISUAL mode, it will appears `:'<,'>`. This is a range too, where `'<` is the first line selected and `'>` is the last one.
`:'<,'>` and `*` are synonyms, but with the first one you can do eg. `'<,$` (execute a command from the first line you’ve selected till the end of the file).

### Jump
Each time we use a jump motion, the position of the cursor before the jump is saved in the jump list.
```
CTRL-o              # jump to the previous cursor positions
CTRL-i              # jump to the next cursor positions

[m                  # move to the start of a method (they should have a java's similar syntax in order to work)
]m                  # move to the end of a method (they should have a java's similar syntax in order to work)
```

### Change List
Each time you insert something (using INSERT mode), the position of your cursor is saved in the change list.
```
g;                  # jump to the next change
g,                  # jump to the previous change
```

### Repeat
```
.                   # repeat the last change
@:                  # repeat the command executed
```

### Macro
Record series of keystrokes and repeat them in order.
```
q<lowercase_letter> # begin recording keystrokes
q                   # stop the recording
@<lowercase_letter> # execute the recorded keystrokes
```

### Buffers
A buffer can be active (displayed in a window), hidden (not displayed but the file is open),
and inactive (not displayed and not linked to a file).
with `:buffers` we can see the buffer list, which idicate:
- buffer ID;
- info (`a` active, `h` hidden, ` ` inactive, The `%` before the state means it's the current one);
- the name (usually the filepath);
- the line number where the cursor is.
```
:buffers            # display the buffer list

:buffers! or ls!    # display unlisted buffers (with a 'u' after the ID)

:buffer <id/name>   # move to the buffer by given ID or name
:bn :bnext          # move to the next buffer
:bp :bprevious      # move to the previous buffer
:bf :bfirst         # move to the first buffer
:bl :last           # move to the last buffer
CTRL-^              # switch to the alternate buffer (indicated with '#')
<ID>CTRL-^          # switch to a specific buffer id (eg. 3CTRL-^)

:bufdo <command>    # apply a command to all buffers

:badd <filename>    # add <filename> to the buffer list
:bdelete <id/name>  # delete buffer(s), separated with spaces if more than one
:1,10bdelete        # delete buffers from 1 to 10 included
:%bdelete           # delete all buffers
```

### Windows
A window in Vim is nothing more than a space you can use to display the content of a buffer.
Don’t forget: when you close the window, the buffer stays open.
```
:new                # create a new window

CTRL-W s            # split the current window horizontally
CTRL-W v            # split the current window vertically
CTRL-W n            # split the current window horizontally and edit a new file
CTRL-W ^            # split the current window with the alternate file (the '#' one)
<buf_id>CTRL-W ^    # split windows with the buffer with the given ID

CTRL-W <Down>       # or CTRL-W j (move the cursor from one window to another)
CTRL-W <Up>         # or CTRL-W k (move the cursor from one window to another)
CTRL-W <Left>       # or CTRL-W h (move the cursor from one window to another)
CTRL-W <Right>      # or CTRL-W l (move the cursor from one window to another)

CTRL-W r            # rotate the window
CTRL-W x            # exchange with the next window

CTRL-W =            # resize windows to fit on the screen equally
CTRL-W -            # decrease window's height
CTRL-W +            # increase window's height
CTRL-W <            # decrease window's width
CTRL-W >            # increase window's width

:q                  # quit the current window
:q                  # quit the current window event if with an unsaved buffer
```

### Tabs
Tabs are a container for a bunch of windows.
```
:tabnew   or :tabe  # open a new tab
:tabclose or :tabc  # close the current tab
:tabonly  or :tabo  # close every other tab except the current one

1gT									# go the first tab (tabs are indexed from 1)
```

### Argument List
Arglist is a subset of the buffer list: every file in the arglist will be in the buffer list, and some buffers in the buffer list won’t be in the arglist.
The arglist can be useful to isolate some files from the buffer list to do some operations on them.
The files you want to open when you run Vim (such as executing `vim file1 file2 file3`) will be automatically added to the arglist and to the buffer list.
```
:args               # display the arglist
:argadd             # add file to the arglist
:argdo              # execute a command on every file in the arglist

:next               # move to the next file in the arglist
:prev               # move to the previous file in the arglist
:first              # move to the first file in the arglist
```


### Options
```
:set no<opt>        # unset the option
:set <opt>!         # toggle the option
:set <opt>?         # return the option value
:set <opt>=<v>      # set a value (string or number)
:set <opt>+=<v>     # add/append a value (string or number)
```

### Mapping
You should set a leader key in order to not change the default vim mapping:
-  `:let mapleader = "<space>"`
-  `nnoremap <leader>bn :bn<cr> ;buffer next`  (you need to add `<cr>` at the end exactly like you would type ENTER, carriage return, to execute the command)
```
:nmap               # create a new mapping for normal mode
:imap               # create a new mapping for insert mode
:xmap               # create a new mapping for visual mode

:nnoremap               # create a new mapping for normal mode (non recursive)
:inoremap               # create a new mapping for insert mode (non recursive)
:vnoremap               # create a new mapping for visual mode (non recursive)

:nnoremap <space> w     # map space to w (to see the complete list: :help key-notation)
```

### History
```
q:                  # open command line history
q/ or q?            # open search history
CTRL+f              # open command line history while in command line mode
```

### Undo Tree
In your `.vimrc` file:
```
" save undo trees in files
set undofile
set undodir=~/.vim/undo

" number of undo saved
set undolevels=10000
```
It saves the complete undo tree with branches, for example:
```
@
|
| o -> third change
| |
| o -> second change 
|/
o -> first change
|
o
```