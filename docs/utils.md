# Logging ([docs](https://docs.voidlinux.org/config/services/logging.html))

```console
$ sudo vpm install socklog-void
$ sudo ln -s /etc/sv/socklog-unix /var/service
$ sudo ln -s /etc/sv/nanoklogd /var/service
$ sudo usermod -a -G socklog $USER
$ sudo socklogtail
```

# Hardening ([src](https://vez.mrsk.me/linux-hardening.html))

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

# Secure SSH ([src](https://www.cyberciti.biz/tips/linux-unix-bsd-openssh-server-best-practices.html))

> You can edit the prompt modifying the file situated in /etc/issue. To test your config file, run `sudo sshd -t` or `sudo sshd -T` for extended test mode.

On `/etc/ssh/sshd_config`:

```sh
PermitEmptyPasswords no            # prevent empty passwords 
PermitRootLogin no                 # prevent the root user from crossing the network via SSH
AllowUsers {YOUR_USERNAME}         # whitelist specific user accounts (AllowGroups, DenyGroups)
DenyUsers root                     # just in case
Port 4719                          # run SSH on a non-standard port (ssh -p 4719 user@ip)
ClientAliveInterval 60             # the server send a message every 60 seconds
ClientAliveCountMax 3              # after 3 attempts, the connection drops
PasswordAuthentication no          # only via ssh key pair
AuthenticationMethods publickey    # use only pubkey authentication
PubkeyAuthentication yes           # enable pubkey authentication
HostbasedAuthentication no         # disable host-based auth
ChallengeResponseAuthentication no # it does not ask for a password
UsePAM no                          # Pluggable Auth Modules (ldap, fingerprint etc.)
IgnoreRhosts yes                   # don't read the user's ~/.rhosts and ~/.shosts file
AuthorizedKeysFile %h/.ssh/{file}  # allow only specific authorized key file
# Accept only some IPs:
# ListenAddress 192.168.1.5
# ListenAddress 192.1.1.5
```

> For SSH brute force attacks and security consider also [DenyHosts](https://www.cyberciti.biz/faq/block-ssh-attacks-with-denyhosts/) / [Fail2Ban](https://www.fail2ban.org/) / [sshguard](https://www.sshguard.net/) / [sshblock](https://www.freshports.org/security/sshblock/) / [IPQ BDB Filter](https://savannah.nongnu.org/projects/ipqbdb/)

Accept SSH only from specific IP with ufw:
```sh
$ sudo ufw allow from 192.168.1.100/29 to any port 22
```

## Rate limit with iptables
```bash
#!/bin/env bash

# The following example will drop incoming connections which make more than 5 connection attempts upon port 22 within 60 seconds:
inet_if=eth1
ssh_port=22
$IPT -I INPUT -p tcp --dport ${ssh_port} -i ${inet_if} -m state --state NEW -m recent  --set
$IPT -I INPUT -p tcp --dport ${ssh_port} -i ${inet_if} -m state --state NEW -m recent  --update --seconds 60 --hitcount 5 -j DROP
```
Another config:
```bash
$IPT -A INPUT  -i ${inet_if} -p tcp --dport ${ssh_port} -m state --state NEW -m limit --limit 3/min --limit-burst 3 -j ACCEPT
$IPT -A INPUT  -i ${inet_if} -p tcp --dport ${ssh_port} -m state --state ESTABLISHED -j ACCEPT
$IPT -A OUTPUT -o ${inet_if} -p tcp --sport ${ssh_port} -m state --state ESTABLISHED -j ACCEPT
# another one line example
# $IPT -A INPUT -i ${inet_if} -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 22 -m limit --limit 5/minute --limit-burst 5-j ACCEPT
```

## Port knocking
Port knocking is a method of externally opening ports on a firewall by generating a connection attempt on a set of prespecified closed ports. Once a correct sequence of connection attempts is received, the firewall rules are dynamically modified to allow the host which sent the connection attempts to connect to the specific port(s). A sample port Knocking example for ssh using iptables:

```sh
$IPT -N stage1
$IPT -A stage1 -m recent --remove --name knock
$IPT -A stage1 -p tcp --dport 3456 -m recent --set --name knock2
 
$IPT -N stage2
$IPT -A stage2 -m recent --remove --name knock2
$IPT -A stage2 -p tcp --dport 2345 -m recent --set --name heaven
 
$IPT -N door
$IPT -A door -m recent --rcheck --seconds 5 --name knock2 -j stage2
$IPT -A door -m recent --rcheck --seconds 5 --name knock -j stage1
$IPT -A door -p tcp --dport 1234 -m recent --set --name knock
 
$IPT -A INPUT -m --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A INPUT -p tcp --dport 22 -m recent --rcheck --seconds 5 --name heaven -j ACCEPT
$IPT -A INPUT -p tcp --syn -j door
```

## Generate SSH key and connect to the server

> DSA and RSA 1024 bit or lower ssh keys are considered weak. Avoid them. RSA keys are chosen over ECDSA keys when backward compatibility is a concern with ssh clients. All ssh keys are either ED25519 or RSA. Do not use any other type.

```sh
# command structure
$ ssh-keygen -t key_type -b bits -C "Comment"
# example 1
$ ssh-keygen -t ed25519 -C "Login to xyz server"
# example 2
$ ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_$(date +%Y-%m-%d) -C "key for xyz clients"
```

next, install the public key:

```sh
# basic
$ ssh-copy-id user@host
# custom folder
$ ssh-copy-id -i /path/to/public-key-file user@host
```

As a script for apps:
```bash
#!/usr/bin/env bash

openssl genrsa 2048 > ~/myapp/cert.key
chmod 400 ~/myapp/cert.key
openssl req -new -x509 -nodes -sha256 -days 365 -key ~/myapp/cert.key -out ~/myapp/cert.cert
```


# Firewall

## Iptables
Display the status of your firewall with `iptables -L -n -v` (`-L`: list rules, `-v` detailed info, `-n` display ip address and port in numeric format, not dns names). Add `--line-numbers` for a more user friendly list. To display input/output rules:
```sh
iptables -L INPUT -n -v
iptables -L OUTPUT -n -v --line-numbers
```

### Delete and reset chains
```sh
iptables -F                   # flush (delete) all rules
iptables -X                   # delete chain
iptables -t nat -F            # -t flush rules of a specific table (-t name)
iptables -t nat -X            # -t delete chain of a specific table (-t name)
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT      # -P sets the default policy (DROP, REJECT, ACCEPT)
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
```

### Delete a rule
```sh
# display the rules
iptables -L {INPUT/OUTPUT} -n --line-numbers | less/grep 'xxx.xxx.xxx.xxx'
# delete with -D and the rule number displayed with the command above
iptables -D INPUT 4
```

### Insert a rule
To insert (`-I`) rule between 1 and 2 (already existing), enter:
```sh
iptables -I INPUT 2 -s 202.54.1.2 -j DROP
# and save with
service iptables save
```

> You can restore the rules with `iptables-restore < /root/my.active.firewall.rules` or `service iptables restart`

> Add `IPTABLES_MODULES_UNLOAD = no` to `/etc/sysconfig/iptables-config` to prevent the system to drop established connections when the iptables is restarted
### Common rules

Drop all traffic:
```sh
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
iptables -L -v -n
```

Drop all incoming/forwarded packets, but allow outgoing traffic:
```sh
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -L -v -n
```

Drop private network address on public interface (ip spoofing):
```sh
# IPv4 Address Ranges For Private Networks (make sure you block them on public interface)
# 10.0.0.0/8 -j (A)
# 172.16.0.0/12 (B)
# 192.168.0.0/16 (C)
# 224.0.0.0/4 (MULTICAST D)
# 240.0.0.0/5 (E)
# 127.0.0.0/8 (LOOPBACK)
iptables -A INPUT -i eth1 -s 192.168.0.0/24 -j DROP
iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP
```

Block a specific ip address:
```sh
iptables -A INPUT -s 1.2.3.4 -j DROP
iptables -A INPUT -s 192.168.0.0/24 -j DROP
```

Block incoming port request:
```sh
# block all service requests on port 80
iptables -A INPUT -p tcp --dport 80 -j DROP
iptables -A INPUT -i eth1 -p tcp --dport 80 -j DROP
# block port 80 only for a specific ip address
iptables -A INPUT -p tcp -s 1.2.3.4 --dport 80 -j DROP
iptables -A INPUT -i eth1 -p tcp -s 192.168.1.0/24 --dport 80 -j DROP
```

Block outgoing traffic to a particular host:
```sh
# find the ip
host -t a www.notagood.site # output: www.notagood.site has address 1.2.3.4
# block it
iptables -A OUTPUT -d 1.2.3.4 -j DROP
# with a subnet
iptables -A OUTPUT -d 192.168.1.0/24 -j DROP
iptables -A OUTPUT -o eth1 -d 192.168.1.0/24 -j DROP

# with a cidr
host -t a www.notagood.site # output: www.notagood.site has address 1.2.3.4
whois 1.2.3.4 | grep CIDR # output: CIDR: 5.6.7.8/19
# prevent outgoing access
iptables -A OUTPUT -p tcp -d 5.6.7.8/19 -j DROP
#  prevent outgoing access with domain name (bad idea)
iptables -A OUTPUT -p tcp -d www.notagood.site -j DROP
iptables -A OUTPUT -p tcp -d notagood.site -j DROP
```

Log and drop packets ( log and block IP spoofing on public interface called eth1):
```sh
iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j LOG --log-prefix "IP_SPOOF A: "
iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP
# to log and drop spoofing per 5 minutes, in bursts of at most 7 entries:
iptables -A INPUT -i eth1 -s 10.0.0.0/8 -m limit --limit 5/m --limit-burst 7 -j LOG --log-prefix "IP_SPOOF A: "
iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP
```

Drop or accept traffic from a specific mac address:
```sh
iptables -A INPUT -m mac --mac-source 00:0F:EA:91:04:08 -j DROP
# only accept traffic for TCP port 8080 from mac 00:0F:EA:91:04:07
iptables -A INPUT -p tcp --destination-port 22 -m mac --mac-source 00:0F:EA:91:04:07 -j ACCEPT
```

Block/allow icmp ping request:
```sh
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -i eth1 -p icmp --icmp-type echo-request -j DROP
# or limit ping responses to certain networks/hosts
iptables -A INPUT -s 192.168.1.0/24 -p icmp --icmp-type echo-request -j ACCEPT
# The following only accepts limited type of ICMP requests (assumed that default INPUT policy set to DROP)
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
# all our server to respond to pings
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
```

Open range of ports:
```sh
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 7000:7010 -j ACCEPT
```

Open range of ip address:
```sh
# only accept connection to tcp port 80 if ip is between 192.168.1.100 and 192.168.1.200
iptables -A INPUT -p tcp --destination-port 80 -m iprange --src-range 192.168.1.100-192.168.1.200 -j ACCEPT
# nat example
iptables -t nat -A POSTROUTING -j SNAT --to-source 192.168.1.20-192.168.1.25
```

Restrict the number of parallel connections to a server per client ip:
```sh
# to allow 3 ssh connections per client host
iptables -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 -j REJECT
# set http requests to 20
iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 24 -j DROP

# --connlimit-above 3: Match if the number of existing connections is above 3
# --connlimit-mask 24: Group hosts using the prefix length. For IPv4 (number between -including- 0 and 32)
```

> Use the crit log level to send messages to a log file instead of console:
> `iptables -A INPUT -s 1.2.3.4 -p tcp --destination-port 80 -j LOG --log-level crit`

The following shows syntax for opening and closing common TCP and UDP ports:
```sh
Replace ACCEPT with DROP to block port:
## open port ssh tcp port 22 ##
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 22 -j ACCEPT
 
## open cups (printing service) udp/tcp port 631 for LAN users ##
iptables -A INPUT -s 192.168.1.0/24 -p udp -m udp --dport 631 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 631 -j ACCEPT
 
## allow time sync via NTP for lan users (open udp port 123) ##
iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p udp --dport 123 -j ACCEPT
 
## open tcp port 25 (smtp) for all ##
iptables -A INPUT -m state --state NEW -p tcp --dport 25 -j ACCEPT
 
# open dns server ports for all ##
iptables -A INPUT -m state --state NEW -p udp --dport 53 -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT
 
## open http/https (Apache) server port to all ##
iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT
 
## open tcp port 110 (pop3) for all ##
iptables -A INPUT -m state --state NEW -p tcp --dport 110 -j ACCEPT
 
## open tcp port 143 (imap) for all ##
iptables -A INPUT -m state --state NEW -p tcp --dport 143 -j ACCEPT
 
## open access to Samba file server for lan users only ##
iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 137 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 138 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 139 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 445 -j ACCEPT
 
## open access to proxy server for lan users only ##
iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 3128 -j ACCEPT
 
## open access to mysql server for lan users only ##
iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
```
#### NATs

List NAT rules:
```sh
iptables -t nat -L -n -v
iptables -t nat -v -L -n --line-number

iptables -t nat -v -L PREROUTING -n --line-number
iptables -t nat -v -L POSTROUTING -n --line-number
```

Delete NAT rule:
```sh
# delete prerouting rules
iptables -t nat -D PREROUTING {number-here}
# delete postrouting rules
iptables -t nat -D POSTROUTING {number-here}
```

Redirect port AA to BB:
```sh
iptables -t nat -A PREROUTING -i $interfaceName -p tcp --dport $srcPortNumber -j REDIRECT --to-port $dstPortNumbe
# eg. redirect all incoming traffic on port 80 redirect to port 8080
iptables -t nat -I PREROUTING --src 0/0 --dst 192.168.1.5 -p tcp --dport 80 -j REDIRECT --to-ports 8080
```

Reset packet counters:
```sh
# clear/reset the counters for all rules
iptables -Z
# reset the counters for INPUT chain only
iptables -Z INPUT
# reset the counters for rule # 13 in the INPUT chain only
iptables -Z INPUT 13
```

#### Testing
```sh
# check open port
netstat -tulpn
netstat -tulpn | grep ":80"
# check if is :80 is open
iptables -L INPUT -v -n | grep 80
# open it
iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
# check connection (ngrep, tcpdump, nmap, telnet)
telnet www.mycool.site 80
nmap -sS -p 80 www.mycool.site
```

## Ufw & AppArmor

```sh
$ sudo xbps-install -S ufw apparmor
```