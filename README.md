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
pfetch / neofetch
chromium / firefox
fontconfig
noto / noto-fonts-emoji
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
gotop / htop
powertop
synfigstudio
picom
vlc
aws-cli

## Git:
bashtop
bspwm
sxhkd
bashtop

## Others:
Brew
Go
Flutter / Dart

# Utilities

## Create Pulseaudio module for OBS
```
pactl load-module module-null-sink
pactl list short sinks
pactl load-module module-combine-sink sink_name=OBScombine slaves=3,2
```