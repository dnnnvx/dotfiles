# Android Studio on Tiling WM
set -U _JAVA_AWT_WM_NONREPARENTING 1

# Gradle
#export PATH=${PATH}:/opt/gradle/gradle-5.4.1/bin

# Flutter
set PATH "$PATH:/usr/local/lib/flutter/bin"

# Go
set PATH "$PATH:/usr/local/lib/go/bin:$HOME/go/bin"

# Brew
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
