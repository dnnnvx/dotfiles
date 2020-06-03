# Kubernetes on Void Linux

## Requirements

Golang, Docker ([docs](https://wiki.voidlinux.org/Docker)) and k8s ([docs](https://wiki.voidlinux.org/Kubernetes)):

```console
dnnnvx@void:~$ sudo xbps-install -S go docker kubernetes
dnnnvx@void:~$ cd /var/service
dnnnvx@void:~$ ln -s /etc/sv/docker .
dnnnvx@void:~$ ln -sf /etc/sv/kube* .
dnnnvx@void:~$ sudo usermod -aG docker $USER
dnnnvx@void:~$ sudo sv stop kubelet kube-scheduler kube-proxy kube-controller-manager kube-apiserver
```

CNI and CNI Plugins (`gcc` is also required for `go get`):
```console
dnnnvx@void:~$ sudo xbps-install -S gcc
dnnnvx@void:~$ go get -u github.com/containernetworking/cni/...
dnnnvx@void:~$ go get -u github.com/containernetworking/plugins/...
```

## master node

```console
dnnnvx@void:~$ sudo kubeadm init --skip-phases mark-control-plane --pod-network-cidr=192.168.1.0/24 --apiserver-advertise-address=192.168.1.150
```

- `--skip-phases mark-control-plane` 'cause we want to run pods on master node, too.
- `--pod-network-cidr=192.168.1.0/24` our homelab network cidr (usually `192.168.*.*`).
- `--apiserver-advertise-address=192.168.1.150` our master node IP address.

When stuck on:
```
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
```

...start `kubelet` ([issue](https://github.com/kubernetes/kubeadm/issues/1295#issuecomment-603582361)), the flags are the same as the [systemd conf file](https://github.com/kubernetes/release/blob/master/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf):
```console
dnnnvx@void:~$ sudo kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --network-plugin=cni
```

Finish up:
```console
dnnnvx@void:~$ mkdir -p $HOME/.kube
dnnnvx@void:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
dnnnvx@void:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Other nodes

Install the requirements as above, and join the cluster with the given token/certs:

```console
dnnnvx@void:~$ kubeadm join 192.168.1.150:6443 --token <TOKEN> --discovery-token-ca-cert-hash <HASH>
```
