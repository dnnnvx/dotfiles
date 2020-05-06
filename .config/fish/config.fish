#set -l tty (fgconsole)
if test -z $DISPLAY
  #and [ tty = 1 ]
  exec startx
end

source $HOME/.profile 
