#set -l tty (fgconsole)
if test -z $DISPLAY
  #and [ tty = 1 ]
  exec startx
end

# Android Studio on Tiling WM
set -U _JAVA_AWT_WM_NONREPARENTING 1

# Brew
if test /home/linuxbrew/.linuxbrew/bin/brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Go
if test /usr/local/lib/go/bin
  #and type -q go # Check if command exists
  set GOPATH "$HOME/go"
  set PATH "$PATH:/usr/local/lib/go/bin:$GOPATH/bin"
end

# Flutter
if test /usr/local/flutter/bin
  set PATH "$PATH:/usr/local/flutter/bin"
end
