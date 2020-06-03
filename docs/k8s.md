# Kubernetes on Void Linux

## Installation

### Requirements

Golang, Docker ([docs](https://wiki.voidlinux.org/Docker)) and k8s ([docs](https://wiki.voidlinux.org/Kubernetes)):

```console
$ sudo xbps-install -S go docker kubernetes gcc conntrack-tools socat
$ cd /var/service
$ ln -s /etc/sv/docker .
$ ln -sf /etc/sv/kube* .
$ sudo usermod -aG docker $USER
$ sudo sv start kube-scheduler kube-apiserver kube-proxy
$ sudo sv stop kubelet kube-controller-manager
```

Cilium requirements ([docs](https://docs.cilium.io/en/stable/kubernetes/requirements/#k8s-requirements)):

CNI, Container Network plugin:
Make sure to have `--network-plugin=cni` in the kubelet flags.

Mount `BPF` (on all nodes):
```console
$ sudo mount bpffs /sys/fs/bpf -t bpf
```
> For persistence add `bpffs /sys/fs/bpf bpf defaults 0 0` to `/etc/fstab`.

Remember to use `kube-controller-manager` with `--allocate-node-cidrs` ([recommended](https://docs.cilium.io/en/stable/kubernetes/requirements/#enable-automatic-node-cidr-allocation-recommended)), it seems that `/etc/sv/kube-controller-manager/run` use `$KUBE_CONTROLLER_MANAGER_ARGS`, so you can add them to `/etc/profile`:

```console
# echo 'export KUBE_CONTROLLER_MANAGER_ARGS="--allocate-node-cidrs"' >> /etc/profile
```

### master node

```console
$ sudo kubeadm init --skip-phases mark-control-plane --pod-network-cidr=192.168.1.0/24 --apiserver-advertise-address=192.168.1.150
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
$ sudo sv start kubelet kube-controller-manager
```

If you've added the flags in `/etc/sv/kubelet/run`, otherwise:

```console
$ sudo kubelet \
   --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf \
   --kubeconfig=/etc/kubernetes/kubelet.conf \
   --config=/var/lib/kubelet/config.yaml \
   --cni-conf-dir=/etc/cni/net.d \
   --cni-bin-dir=/opt/cni/bin \
   --cert-dir=/var/lib/kubelet/pki \
   --network-plugin=cni
```
> If something went wrong, remember to run `sudo kubeadm reset` before trying again.

And finally, as the output suggested:

```console
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Worker node

Install the same requirements as the master node, and join the cluster with the given token/certs:

```console
$ kubeadm join 192.168.1.150:6443 --token <TOKEN> --discovery-token-ca-cert-hash <HASH>
```

Remember to stop and init manually the `kubelet` like in the master node.

## Post Install

### Master node: install Helm ([doc](https://helm.sh/docs/intro/install/))

```console
$ cd ~
$ curl -O https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz
$ tar -zxvf helm-v3.2.1-linux-amd64.tar.gz
$ sudo mv ./linux-amd64/helm /usr/local/bin/helm
$ rm helm-v3.2.1-linux-amd64.tar.gz
$ rm -rf ./linux-amd64
$ sudo helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

### Add Cilium ([doc](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-etcd-operator/#installation-with-managed-etcd))

```console
$ helm repo add cilium https://helm.cilium.io/
$ helm repo update
$ sudo helm install cilium cilium/cilium --version 1.7.4 \
   --namespace kube-system \
   --set global.etcd.enabled=true \
   --set global.etcd.managed=true
```

Validate the installation (running pods) with:
```console
$ kubectl --all-namespaces get pods --watch
```
