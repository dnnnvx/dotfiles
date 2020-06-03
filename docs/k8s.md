# Kubernetes on Void Linux

## Installation

### Requirements

Golang, Docker ([docs](https://wiki.voidlinux.org/Docker)) and k8s ([docs](https://wiki.voidlinux.org/Kubernetes)):

```console
dnnnvx@void:~$ sudo xbps-install -S go docker kubernetes gcc conntrack-tools socat
dnnnvx@void:~$ cd /var/service
dnnnvx@void:~$ ln -s /etc/sv/docker .
dnnnvx@void:~$ ln -sf /etc/sv/kube* .
dnnnvx@void:~$ sudo usermod -aG docker $USER
dnnnvx@void:~$ sudo sv stop kubelet kube-scheduler kube-proxy kube-controller-manager kube-apiserver
```

CNI and CNI Plugins:

```console
dnnnvx@void:~$ go get -u github.com/containernetworking/cni/...
dnnnvx@void:~$ go get -u github.com/containernetworking/plugins/...
```
Cilium requirements ([docs](https://docs.cilium.io/en/stable/kubernetes/requirements/#k8s-requirements))

Mount `BPF` (on all nodes):
```console
dnnnvx@void:~$ sudo mount bpffs /sys/fs/bpf -t bpf
```
> For persistence add `bpffs /sys/fs/bpf bpf defaults 0 0` to `/etc/fstab`.

> Remember to use `kube-controller-manager` with `--allocate-node-cidrs` ([recommended](https://docs.cilium.io/en/stable/kubernetes/requirements/#enable-automatic-node-cidr-allocation-recommended)).

### master node

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

... start `kubelet` ([issue](https://github.com/kubernetes/kubeadm/issues/1295#issuecomment-603582361)), the flags are the same as the [systemd conf file](https://github.com/kubernetes/release/blob/master/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf) on a second SSH session:

```console
dnnnvx@void:~$ sudo kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --network-plugin=cni
```
> You can add these flags to `/etc/sv/kubelet/run` (?).

> If something went wrong, remember to run `sudo kubeadm reset` before trying again.


Finish up:

```console
dnnnvx@void:~$ mkdir -p $HOME/.kube
dnnnvx@void:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
dnnnvx@void:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Worker node

Install the same requirements as the master node, and join the cluster with the given token/certs:

```console
dnnnvx@void:~$ kubeadm join 192.168.1.150:6443 --token <TOKEN> --discovery-token-ca-cert-hash <HASH>
```

Remember to stop and init manually the `kubelet`.

## Post Install

### Master node: install Helm ([doc](https://helm.sh/docs/intro/install/))

```console
dnnnvx@void:~$ cd ~
dnnnvx@void:~$ curl -O https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz
dnnnvx@void:~$ tar -zxvf helm-v3.2.1-linux-amd64.tar.gz
dnnnvx@void:~$ sudo mv ./linux-amd64/helm /usr/local/bin/helm
dnnnvx@void:~$ rm helm-v3.2.1-linux-amd64.tar.gz
dnnnvx@void:~$ rm -r ./linux-amd64
dnnnvx@void:~$ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

### Add Cilium ([doc](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-etcd-operator/#installation-with-managed-etcd))

```console
dnnnvx@void:~$ helm repo add cilium https://helm.cilium.io/
dnnnvx@void:~$ helm repo update
dnnnvx@void:~$ sudo helm install cilium cilium/cilium --version 1.7.4 \
   --namespace kube-system \
   --set global.etcd.enabled=true \
   --set global.etcd.managed=true
```

Validate the installation (running pods) with:
```console
dnnnvx@void:~$ kubectl -n kube-system get pods --watch
```

