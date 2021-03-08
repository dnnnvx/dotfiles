## Tmux

```
tmux                           # it will create a session, a window and a pane
tmux kill-server               # kill'em all

tmux list-sessions             # list current tmux sessions
tmux new-session -s "hi"       # create a new session with a given name
tmux kill-session -t "hi"      # delete the session with the given name

prefix -> :                    # open command prompt (vim-like)
```
### Panes
```
prefix -> "                    # create a new pane (same as prefix -> :split-window)
prefix -> arrow key            # navigate panes
prefix -> alt + arrow key      # resize pane
```

### Config (~/.tmux.conf)

#### Change prefix
```
unbind C-b                     # unbind the default prefix key (ctrl+b, C-b in tmux)
set -g prefix C-Space          # set the new prefix (-g stand for global, eg. -w for only windows)
```

#### Reload config shortcut
```
unbind r
bind r source-file ~/.tmux.conf \; display "Reloaded ~/.tmux.conf" # reload tmux config
```

#### Enable mouse
```
set -g mouse on                # enable mouse (for selecting/resizing panes, selecting/scrolling windows, copy text)
```

#### Split window shortcut
```
unbind v
unbind h
unbind %      # default split vertically
unbind '"'    # default split horizontally
bind v split-window -h -c "#{pane_current_path}"
bind h split-window -v -c "#{pane_current_path}"
```

#### Navigate through panes
```
# the flag -n means that these binding don’t use the prefix key
bind -n C-h select-pane -L # navigate left pane (vim-like)
bind -n C-j select-pane -D # navigate bottom pane (vim-like)
bind -n C-k select-pane -U # navigate upper pane (vim-like)
bind -n C-l select-pane -R # navigate right pane (vim-like)
```

#### Move through windows
```
unbind n  # default: move to next window
unbind w  # default: change current window interactively

bind n command-prompt "rename-window '%%'"
bind w new-window -c "#{pane_current_path}"

bind -n M-k next-window       # alt+k move to the next window
bind -n M-j previous-window   # alt+j move to the previous window
```

#### More history
```
set -g history-limit 100000 # more history
```

#### start indexing form 1 instead of 0
```
set -g base-index 1
set-window-option -g pane-base-index 1
```

#### vim-like syntax
```
set-window-option -g mode-keys vi # ctrl-u to scroll up, ctrl-d to scroll down, / to Search
```

#### Using the system clipboard to copy paste
```
unbind -T copy-mode-vi Space; # default for begin-selection
unbind -T copy-mode-vi Enter; # default for copy-selection
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xsel --clipboard"
# bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"`
```

#### Smart pane switching with awareness of Vim splits
```
is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
bind -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
```

#### Colors
```
# default statusbar colors
set-option -g status-style fg=yellow,bg=black #yellow and base02

# default window title colors
set-window-option -g window-status-style fg=brightblue,bg=default #base0 and default
#set-window-option -g window-status-style dim

# active window title colors
set-window-option -g window-status-current-style fg=brightred,bg=default #orange and default
#set-window-option -g window-status-current-style bright

# pane border
set-option -g pane-border-style fg=black #base02
set-option -g pane-active-border-style fg=brightgreen #base01

# message text
set-option -g message-style fg=brightred,bg=black #orange and base01

# pane number display
set-option -g display-panes-active-colour blue #blue
set-option -g display-panes-colour brightred #orange

# clock
set-window-option -g clock-mode-colour green #green

# bell
set-window-option -g window-status-bell-style fg=black,bg=red #base02, red
```