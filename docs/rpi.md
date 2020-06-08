# Enter the (Pi) Void

[Doc](https://wiki.voidlinux.org/Raspberry_Pi) | [General Hints](https://elinux.org/RPi_Hub) | [Nice Post](https://blog.kevindirect.com/post/20191109_nine-steps-to-void-linux-on-rpi/)

## Preparing the SD Card

```console
$ sudo parted /dev/sda
(parted) mktable msdos
(parted) mkpart primary fat32 2048s 256MB
(parted) toggle 1 boot
(parted) mkpart primary ext4 256MB -1
(parted) quit
$ sudo mkfs.vfat /dev/sda1
$ sudo mkfs.ext4 -O '^has_journal' /dev/sda2
```

## Preparing target rootfs directory

```console
$ mkdir rootfs
# mount /dev/sda2 rootfs/
# mkdir rootfs/boot
# mount /dev/sda1 rootfs/boot
# tar xvfJp ~/Downloads/void-rpi*-PLATFORMFS-%DATE.tar.xz -C rootfs
# sync
# echo '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> rootfs/etc/fstab
```

## First Boot

### Setup

```console
$ bash # for mental health's sake
$ passwd # change root password
$ useradd -m -s /bin/bash -g users -G wheel,network,audio,video <USER>
$ passwd <USER>
$ echo <HOSTNAME> > /etc/hostname
```

> Uncomment `# %wheel ALL=(ALL) ALL` in `/etc/sudoers` to give permissions

### Connection Setup

```console
$ cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
$ sudo wpa_passphrase <SSID> <PASS> >> /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
$ sudo cat >>/etc/dhcpcd.conf <<EOL
> interface wlan0
> static ip_address=192.168.1.190/24
> static routers=192.168.1.1
> static domain_name_servers=192.168.1.1 8.8.8.8
> EOL
```

### Services

```console
$ sudo ln -s /etc/sv/ntpd /var/service
$ sudo ln -s /etc/sv/dhcpcd /var/service
$ sudo ln -s /etc/sv/wpa_supplicant /var/service
$ sudo ln -s /etc/sv/sshd /var/service
$ sudo xbps-reconfigure -f chrony # for ntpd
```

> Remove unused TTY with `sudo rm /var/service/agetty-tty{N}` and `sudo touch /etc/sv/agetty-tty{N}/down`

### Tweaks

- On `/boot/cmdline.txt`

```console
# echo " bcm2708.vc_i2c_override=1" > /boot/cmdline.txt # i2c
```

- On `/boot/config.txt`

```console
# echo -e "\ndtparam=i2c_arm=on" > /boot/config.txt # i2c
```

### Others

- Modify the kbd layout and other options in `/etc/rc.conf`
- Create `/etc/modules-load.d/i2c.conf` and add `echo i2c-dev >> /etc/modules-load.d/i2c.conf`
- Reboot! `sudo reboot`

## Second Boot

### Update & install
```console
$ sudo xbps-install -Su
$ sudo xbps-install -Oo
$ sudo xbps-install vim git htop vpm i2c-tools
$ ssh-keygen # create a key pair
```

### Golang (with [periph.io](https://periph.io/))

```console
$ sudo vpm install gcc go htop
$ echo "export PATH=$PATH:~/go/bin" > .profile # with -e "\n..." if not empty
$ go get periph.io/x/periph/cmd/...
$ sudo periph-info
```

Disconnect the HDMI, mouse and keyboard from the Raspberry. Now, on your laptop:

```console
$ ssh <USER>@192.168.1.190 # Ready to go! We can do things!
```
