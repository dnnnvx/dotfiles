# Logging ([docs](https://docs.voidlinux.org/config/services/logging.html))

```console
$ sudo vpm install socklog-void
$ sudo ln -s /etc/sv/socklog-unix /var/service
$ sudo ln -s /etc/sv/nanoklogd /var/service
$ sudo usermod -a -G socklog $USER
$ sudo socklogtail
```

# Hardening ([src](https://vez.mrsk.me/linux-hardening.html)) & helpers

- In `/etc/sudoers`:

```
Defaults env_reset
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Defaults umask=0022
Defaults umask_override

root ALL=(ALL:ALL) ALL

Cmnd_Alias VPM = /bin/vpm
Cmnd_Alias REBOOT = /sbin/reboot ""
Cmnd_Alias SHUTDOWN = /sbin/poweroff ""

bh ALL=(root) NOPASSWD: VPM
bh ALL=(root) NOPASSWD: REBOOT
bh ALL=(root) NOPASSWD: SHUTDOWN
```

- In `/etc/fstab`:
```
#user's ~/.cache directory in tmpfs to reduce disk writes
tmpfs /home/bh/.cache tmpfs rw,size=250M,noexec,noatime,nodev,uid=bh,gid=bh,mode=700 0 0
```

- Sysctl `/etc/sysctl.d/98-misc.conf` (apply with `sysctl -p /etc/sysctl.d/99-sysctl.conf`):

```
net.ipv4.tcp_congestion_control=bbr
vm.swappiness=10
```

> Linux supports multiple TCP congestion control algorithms. The BBR algorithm gives more consistent network throughput than the default in my experience, especially for transatlantic file transfers. It may help a lot, or it may not make a difference at all, depending on the use case.

> The "swappiness" value controls how aggressively the kernel will swap out memory pages to disk. The default value of 60 is way too high for me, so I turn it down to 10 to prevent so much swapping.

- In `/etc/mkinitcpio.conf` (if not usind `dracut`):

```
[...]
COMPRESSION="xz"
COMPRESSION_OPTIONS=(-0 -T 0)
```

## Audio

- In `/home/user/.config/pulse/daemon.conf`:

```
avoid-resampling = true
flat-volumes = no
resample-method = speex-float-10
avoid-resampling = yes
## These next options should be tailored to your use case and hardware. I mainly play files in 44100 and 96000 bit rate through headphones.
default-sample-format = float32le
default-sample-rate = 44100
alternate-sample-rate = 96000
```

### Autologin on startup
See: [docs](https://wiki.voidlinux.org/Automatic_Login_to_Graphical_Environment)
```console
$ sudo cp -R /etc/sv/agetty-tty1 /etc/sv/agetty-autologin-tty1
$ sudo echo >> /etc/sv/agetty-autologin-tty1/conf "GETTY_ARGS=\"--autologin $USER --noclear\"
  BAUD_RATE=38400
  TERM_NAME=linux"
```
Logout, login, and:
```console
$ sudo rm /var/service/agetty-tty1
$ sudo ln -s /etc/sv/agetty-autologin-tty1 /var/service
```

### Auto xinit w/ fish
In `~/.config/fish/config.fish`:
```
#set -l tty (fgconsole)
if test -z $DISPLAY
  #and [ tty = 1 ]
  exec startx
end
```

> In general, use `~/.config/fish/config.fish` for any ".profile" configuration

### Create Pulseaudio module for OBS
(Assume that with listing `short links` 3 is the null one and 2 is the default)
```console
$ pactl load-module module-null-sink
$ pactl list short sinks
$ pactl load-module module-combine-sink sink_name=OBScombine slaves=3,2
```
