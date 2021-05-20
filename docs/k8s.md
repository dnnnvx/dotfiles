# Kubernetes on Void Linux

- Cidr: `192.168.1.0/24`
- Master node: `192.168.1.101`
- Worker node: `192.168.1.102`

#### Requirements (master & worker)

Golang, [Docker](https://wiki.voidlinux.org/Docker) and [K8S](https://wiki.voidlinux.org/Kubernetes):

```console
$ sudo xbps-install -S go docker kubernetes gcc conntrack-tools socat
$ cd /var/service
$ ln -s /etc/sv/docker .
$ ln -sf /etc/sv/kube* .
$ sudo usermod -aG docker $USER
$ sudo sv stop kubelet kube-controller-manager kube-proxy kube-scheduler kube-apiserver
```

Also make sure to have these variables in every node:
```console
# cat >> /etc/profile <<EOL
KUBECONFIG=/etc/kubernetes/admin.conf
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_HOST=192.168.1.101
EOL
```

Container Network Plugin (CNI) requirements:

- Make sure to have `--network-plugin=cni` in the kubelet flags.
- Remember to use `kube-controller-manager` with `--allocate-node-cidrs`, it seems that `/etc/sv/kube-controller-manager/run` use `$KUBE_CONTROLLER_MANAGER_ARGS`, so you can add them to `/etc/profile`:

```console
# echo 'export KUBE_CONTROLLER_MANAGER_ARGS="--allocate-node-cidrs"' >> /etc/profile
```

#### Master Node

```console
$ sudo kubeadm init --pod-network-cidr=192.168.1.0/24
```

When stuck on:
```
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
```

... start `kubelet` ([issue](https://github.com/kubernetes/kubeadm/issues/1295#issuecomment-603582361)), the flags are the same as the [systemd conf file](https://github.com/kubernetes/release/blob/master/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf), on a second SSH session:

```console
$ sudo sv start kubelet kube-controller-manager kube-proxy kube-scheduler kube-apiserver
```

The kubelet should start like this (edit the `/etc/sv/kubelet/run`):

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

And finally, as the output suggested:

```console
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

#### Reset

If something went wrong, remember to run `sudo kubeadm reset` before trying again. It should be enoguh, but make sure to delete everything manually 'cause kubelet must be stopped manually here.

```console
# sv stop kubelet
# kubeadm reset
$ cd ~ && rm -r .kube/
# rm -rf /var/lib/kubelet/* /var/lib/dockershim/* /var/run/kubernetes/* /var/lib/cni/* /etc/cni/net.d/*
# rm /etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf
```

#### Worker Node

Install the same requirements as the master node, and join the cluster with the given token/certs:

```console
$ KUBERNETES_SERVICE_PORT=443 && KUBERNETES_SERVICE_HOST=192.168.1.101
$ kubeadm join 192.168.1.101:6443 --token <TOKEN> --discovery-token-ca-cert-hash <HASH>
```

Remember to stop and init manually the `kubelet` like in the master node.

#### Kube-Router as CNI

It seems that the nodes must have the kubeconfig in kube-router lib directory, in the node we can do a symlink.
Kube-Router create an empty directory if it's not found and it gives you a CrashLoopError.

```console
# mkdir /var/lib/kube-router && ln -s ~/.kube/config /var/lib/kube-router/kubeconfig
```

In the node just copy-paste it or pass it via sftp (for now).

Add kube-router to the cluster with: `$ kubectl apply -f ` one of [these](https://github.com/cloudnativelabs/kube-router/tree/master/daemonset).

#### Kube-Router error: Failed to get pod CIDR
```
Failed to get pod CIDR from node spec. kube-router relies on kube-controller-manager to allocate pod CIDR for the node or an annotation `kube-router.io/pod-cidr`. Error: node.Spec.PodCIDR not set for node: nuc2
```

Fixed by launching (from the master):

```console
$ kubectl patch node <NODE_NAME> -p '{"spec":{"podCIDR":"192.168.1.0/24"}}'
```

#### Install [Helm](https://helm.sh/docs/intro/install/) on master node

```console
$ cd ~
$ curl -O https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz
$ tar -zxvf helm-v3.2.1-linux-amd64.tar.gz
$ sudo mv ./linux-amd64/helm /usr/local/bin/helm
$ rm helm-v3.2.1-linux-amd64.tar.gz
$ rm -rf ./linux-amd64
$ sudo helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

#### Validators and security utilities

- [Polaris](https://github.com/FairwindsOps/polaris): validation of best practices in your Kubernetes clusters.
- [kubeval](https://github.com/instrumenta/kubeval): Kubernetes configuration files validator.
- [kube-score](https://github.com/zegl/kube-score): object analysis with recommendations for improved reliability and security.
- [kube-bench](https://github.com/aquasecurity/kube-bench): checks whether Kubernetes is deployed according to security best practices.
- [kube-hunter](https://github.com/aquasecurity/kube-hunter): hunt for security weaknesses in Kubernetes clusters.

#### Next steps:

- [Metallb](https://metallb.universe.tf/installation/): a network load-balancer implementation.
- [Istio](https://istio.io/latest/docs/): service mesh / ingress /gateway.
- [Kubeless](https://kubeless.io/docs/quick-start/): Kubernetes Native Serverless Framework.
- [Ipfs](https://cluster.ipfs.io/documentation/guides/k8s/): a peer-to-peer hypermedia protocol.
- [Minio](https://docs.min.io/docs/deploy-minio-on-kubernetes.html): Kubernetes Native Object Storage (S3 compatible).
- [Drone.io](https://docs.drone.io/runner/kubernetes/overview/): a Continuous Delivery platform.
- [Longhorn](https://github.com/longhorn/longhorn) (or [Rook/Ceph](https://rook.io/docs/rook/v1.3/ceph-storage.html), [UtahFS](https://github.com/cloudflare/utahfs)): cloud storage solutions. 
- [Cadvisor](https://github.com/google/cadvisor): get usage and performance characteristics of running containers.
- [Kustomize](https://kubernetes-sigs.github.io/kustomize/guides/offtheshelf/) + [Kpt](https://googlecontainertools.github.io/kpt/guides/ecosystem/): configurations management.

# Kubernetes with Debian 10 (from mini.iso) on Intel NUC (5005) with Containerd instead of Docker

```sh
# add non-free firmware
vim /etc/apt/sources.list # add non-free
apt update && sudo apt upgrade
apt install vim git htop firmware-iwlwifi firmware-realtek
modprobe -r iwlwifi ; sudo modprobe iwlwifi

# enable wifi
su -l -c "<SSID> <PWD>" > /etc/wpa_supplicant/wpa_supplicant.conf
systemctl reenable wpa_supplicant.service
systemctl restart wpa_supplicant.service
vim /etc/network/interfaces
ifup wlo2
ifdown eno1

# disable swap (for persistence comment the swap line in /etc/fstab)
swapoff -a

# enable modules for bridge network
modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# install dependencies and containerd
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install containerd
apt update && sudo apt-get install -y apt-transport-https curl
update-alternatives --config iptables
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update && sudo apt install -y kubelet kubeadm kubectl

# generate config file
containerd config default > /etc/containerd/config.toml
vim /etc/containerd/config.toml # enable systemd cgroup editing the corresponding line

# create a symlink, it seems that kubelet needs it in /usr/local/bin/
ln -s /usr/bin/containerd-shim-runc-v2 /usr/local/bin/
systemctl enable containerd
systemctl restart containerd
systemctl enable kubelet
systemctl restart kubelet
apt-mark hold kubelet kubeadm kubectl

# define kubeadm config
cat <<EOF | sudo tee /etc/kubernetes/kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta2
kubernetesVersion: v1.21.0
controlPlaneEndpoint: "nuc-101:6443"
networking:
  podSubnet: "192.168.1.0/24"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF

# setup other kubeadm extra args (for containerd) used in systemd service file
export KUBELET_EXTRA_ARGS="--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock --cgroup-driver=systemd"

# create cluster
kubeadm init --config /etc/kubernetes/kubeadm-config.yaml | tee kubeadm.out
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# verify bpf is on
mount | grep /sys/fs/bpf

# install helm and cilium/hubble
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt install helm
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.9.7 --namespace cilium --set etcd.enabled=true --set etcd.managed=true --set etcd.k8sService=true
helm upgrade cilium cilium/cilium --version 1.9.7 --namespace cilium --reuse-values --set hubble.listenAddress=":4244" \
  --set hubble.relay.enabled=true --set hubble.ui.enabled=true

  # install longhorn
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-dashboard | awk '{print $1}')
apt install open-iscsi nfs-common jq

# check longhorn dependencies and requirements
curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.1.1/scripts/environment_check.sh | bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
kubectl create namespace longhorn-system
helm install longhorn longhorn/longhorn --namespace longhorn-system
kubectl port-forward -n longhorn-system svc/longhorn-frontend 8001:80 # access the UI

# install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# to use the web UI from an external IP without port-forward (kubectl port-forward svc/argocd-server -n argocd 8080:443)
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
# download the cli and authenticate and add the cluster
brew install argocd && argocd
argocd cluster add --insecure <CLUSTER_NAME> # the same name as the ~/.kube/config cluster name
```
