# Void Desktop Setup

Dot 👽 Dot 🦎

#### xbps-install
```console
dnnnvx@void:~$ sudo xbps-install -Su
dnnnvx@void:~$ sudo xbps-install xorg-minimal xinit xf86-video-amdgpu
dnnnvx@void:~$ sudo xbps-install base-devel git dbus jq ncdu obs vscode alacritty telegram-desktop pulseaudio pcmanfm lmms tig p7zip docker pfetch neofetch chromium firefox fontconfig noto-fonts-ttf noto-fonts-emoji blender android-studio cava parted fish-shell gimp audacity godot htop powertop synfigstudio picom vlc aws-cli tree shellcheck papirus-icon-theme font-iosevka
dnnnvx@void:~$ sudo usermod -aG input,video,docker,kvm $USER
dnnnvx@void:~$ sudo xbps-remove -Oo
```

#### Git:
- [bashtop](https://github.com/aristocratos/bashtop)
- [bspwm](https://github.com/baskerville/bspwm)
- [sxhkd](https://github.com/baskerville/sxhkd)

#### Others:
- [Go](https://golang.org/dl/)
- [Brew](https://brew.sh/)
- [Flutter/Dart](https://flutter.dev/docs/get-started/install/linux)
- [Fisher](https://github.com/jorgebucaran/fisher)
- [Fish-nvm](https://github.com/jorgebucaran/fish-nvm)
- [Kripton Theme](https://www.gnome-look.org/p/1365372/)
- [JetBrains Mono Font](https://www.jetbrains.com/lp/mono/)
- [Remixicon Icon Font](https://github.com/Remix-Design/RemixIcon/tree/master/fonts)

#### Go
- [duf](https://github.com/muesli/duf)
- [fzf](https://github.com/junegunn/fzf)

### Utilities

#### Autologin on startup
See: [docs](https://wiki.voidlinux.org/Automatic_Login_to_Graphical_Environment)
```console
dnnnvx@void:~$ sudo cp -R /etc/sv/agetty-tty1 /etc/sv/agetty-autologin-tty1
dnnnvx@void:~$ sudo echo >> /etc/sv/agetty-autologin-tty1/conf "GETTY_ARGS=\"--autologin $USER --noclear\"
  BAUD_RATE=38400
  TERM_NAME=linux"
```
Logout, login, and:
```console
dnnnvx@void:~$ sudo rm /var/service/agetty-tty1
dnnnvx@void:~$ sudo ln -s /etc/sv/agetty-autologin-tty1 /var/service
```

#### Auto xinit w/ fish
In `~/.config/fish/config.fish` there's:
```
#set -l tty (fgconsole)
if test -z $DISPLAY
  #and [ tty = 1 ]
  exec startx
end
```

> In general, use `~/.config/fish/config.fish` for any ".profile" configuration

#### Create Pulseaudio module for OBS
(Assume that with listing `short links` 3 is the null one and 2 is the default)
```console
dnnnvx@void:~$ pactl load-module module-null-sink
dnnnvx@void:~$ pactl list short sinks
dnnnvx@void:~$ pactl load-module module-combine-sink sink_name=OBScombine slaves=3,2
```
