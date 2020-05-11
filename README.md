## xbps-install
ncdu
obs
vscode
alacritty
telegram-desktop
pulseaudio
pulseeffects
pcmanfm
lmms
tig
p7zip
docker
pfetch
neofetch
chromium
firefox
fontconfig
noto-fonts-ttf
noto-fonts-emoji
blender
android-studio
cava
parted
fish-shell
gimp
yarn
nodejs
audacity
godot
htop
powertop
synfigstudio
picom
vlc
aws-cli
tree
shellcheck

## Git:
- [bashtop](https://github.com/aristocratos/bashtop)
- [bspwm](https://github.com/baskerville/bspwm)
- [sxhkd](https://github.com/baskerville/sxhkd)

# Go
- [gotop](https://github.com/cjbassi/gotop)
- [gops](https://github.com/google/gops)
- [fzf](https://github.com/junegunn/fzf)

## Others:
- [Go](https://golang.org/dl/)
- [Brew](https://brew.sh/)
- [Flutter/Dart](https://flutter.dev/docs/get-started/install/linux)
- [fisher](https://github.com/jorgebucaran/fisher)
- [fish-nvm](https://github.com/jorgebucaran/fish-nvm)

# Utilities

## Create Pulseaudio module for OBS
```
pactl load-module module-null-sink
pactl list short sinks
pactl load-module module-combine-sink sink_name=OBScombine slaves=3,2
```
