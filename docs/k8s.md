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
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
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
vim /etc/containerd/config.toml # add SystemdCgroup = true in [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]

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
kubernetesVersion: v1.22.3
controlPlaneEndpoint: "nuc-101:6443"
networking:
  podSubnet: "192.168.0.0/16"
apiServer:
  extraArgs:
    feature-gates: EphemeralContainers=true
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
# to add nodes in the future: create a token and paste the command in the node cli
kubeadm token create --print-join-command
```

## Helm

```sh
# install helm and cilium/hubble
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt install helm
```

## Cilium as CNI ([docs](https://docs.cilium.io/en/stable/))

```sh
# verify bpf is on
mount | grep /sys/fs/bpf

# install helm and cilium/hubble
helm repo add cilium https://helm.cilium.io/
kubectl create ns cilium
helm install cilium cilium/cilium --version 1.10.5 --namespace cilium
helm upgrade cilium cilium/cilium --version 1.10.5 \
  --namespace cilium \
  --reuse-values \
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true
```

## Kube-Vip as in-cluster on-prem Load Balancer ([docs](https://kube-vip.io/usage/on-prem/))
```sh
kubectl apply -f https://raw.githubusercontent.com/kube-vip/kube-vip-cloud-provider/main/manifest/kube-vip-cloud-controller.yaml
kubectl create configmap --namespace kube-system kubevip --from-literal cidr-global=192.168.0.0/16
```

## Longhorn (persistenceVolume PV and storageClass SC)
```sh
apt install open-iscsi nfs-common jq # with the iscsid daemon running
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.2/deploy/longhorn.yaml
kubectl get pods -n longhorn-system -w # watch finishing the installation
kubectl port-forward -n longhorn-system svc/longhorn-frontend 8001:80 # access the UI
```

## Tekton
```sh
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl create configmap config-artifact-pvc \
  --from-literal=size=10Gi \
  --from-literal=storageClassName=longhorn \
  -o yaml -n tekton-pipelines \
  --dry-run=client | kubectl replace -f -
# enable and access the the dashboard
kubectl apply --filename https://github.com/tektoncd/dashboard/releases/latest/download/tekton-dashboard-release.yaml
kubectl --namespace tekton-pipelines port-forward svc/tekton-dashboard 9097:9097
```

### Next steps:

#### Development:
- App development with Kustomize + Kpt (and Ko (Go on k8s))
- Cadvisor for containers' usage and performance

#### CI/CD:
- Flux
- Kaniko for building container images on k8s ([tips with Tekton](https://developer.ibm.com/devpractices/devops/tutorials/build-and-deploy-a-docker-image-on-kubernetes-using-tekton-pipelines/))

#### DApp development:
- [geth](https://artifacthub.io/packages/helm/vulcanlink/geth) nodes on k8s (manual [statefulSet](https://messari.io/article/running-an-ethereum-node-on-kubernetes-is-easy))
- [prysm](https://github.com/prysmaticlabs/prysm) as Ethereum L2 solution

#### Storage:
- [SeaweedFS](https://github.com/chrislusf/seaweedfs) with the [operator](https://github.com/seaweedfs/seaweedfs-operator) and [rclone](https://github.com/rclone/rclone) (alternative to Minio for S3 compatible API)

#### Validation, authorization and security:
- Kubernetes builtin RBAC
- Open policy Agent with Rego Rules (or Kyverno)

- [kubescape](https://github.com/armosec/kubescape): testing if Kubernetes is deployed securely according to DevSecOps best practices.
- [polaris](https://github.com/FairwindsOps/polaris): validation of best practices in your Kubernetes clusters.
- [kube-score](https://github.com/zegl/kube-score): object analysis with recommendations for improved reliability and security.
- [kube-bench](https://github.com/aquasecurity/kube-bench): checks whether Kubernetes is deployed according to security best practices.
- [kube-hunter](https://github.com/aquasecurity/kube-hunter): hunt for security weaknesses in Kubernetes clusters.

#### Serverless:
- Serverless Functions on k8s with [Knative](https://knative.dev/docs/)

#### Additional features:
- AI/ML with Kubeflow + Feast
