# Kubernetes on Debian 10 (mini.iso) with Containerd

- Two nodes (x2 Intel NUC with Pentium J5005, 8GB RAM, 120GB SSD)
- Cidr: `192.168.0.0/16`
- Control Plane: `192.168.0.100`
- Worker node: `192.168.1.100`

## Preparation

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
```

## Containerd, kubelet & kubectl

```sh
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
  podSubnet: "192.168.0.0/16"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF

# setup other kubeadm extra args (for containerd) used in systemd service file
export KUBELET_EXTRA_ARGS="--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock --cgroup-driver=systemd"
```

## Cluster setup

```sh
# create cluster
kubeadm init --config /etc/kubernetes/kubeadm-config.yaml | tee kubeadm.out
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
```

## Cilium (CNI)

```sh
# verify bpf is on
mount | grep /sys/fs/bpf

# install helm and cilium/hubble
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt install helm
helm repo add cilium https://helm.cilium.io/
kubectl create ns cilium
helm install cilium cilium/cilium --version 1.10.0 --namespace cilium
helm upgrade cilium cilium/cilium --version 1.10.0 \
  --namespace cilium \
  --reuse-values \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true
```

## Longhorn (persistence storage)
```sh
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
```

## Argo (GitOps)

```sh
# install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# to use the web UI from an external IP without port-forward (kubectl port-forward svc/argocd-server -n argocd 8080:443)
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
# Get the initial password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# download the cli and authenticate and add the cluster (optional)
brew install argocd && argocd
```

### Next steps:

- Scylla
- Cadvisor
- Kaniko ([tips with Tekton](https://developer.ibm.com/devpractices/devops/tutorials/build-and-deploy-a-docker-image-on-kubernetes-using-tekton-pipelines/))
- Kustomize
- Keptn
- Ko (Go on k8s)
- Tekton
- Knative
- Kubeflow + Feast

### Validation, authorization and security:

- RBAC
- Open policy Agent

- [Polaris](https://github.com/FairwindsOps/polaris): validation of best practices in your Kubernetes clusters.
- [kube-score](https://github.com/zegl/kube-score): object analysis with recommendations for improved reliability and security.
- [kube-bench](https://github.com/aquasecurity/kube-bench): checks whether Kubernetes is deployed according to security best practices.
- [kube-hunter](https://github.com/aquasecurity/kube-hunter): hunt for security weaknesses in Kubernetes clusters.