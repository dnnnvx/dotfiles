# Kubernetes on Void Linux

- Cidr: `192.168.1.0/24`
- Master node: `192.168.1.150`
- Worker node: `192.168.1.151`

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
KUBERNETES_SERVICE_HOST=192.168.1.150
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
$ KUBERNETES_SERVICE_PORT=443 && KUBERNETES_SERVICE_HOST=192.168.1.150
$ kubeadm join 192.168.1.150:6443 --token <TOKEN> --discovery-token-ca-cert-hash <HASH>
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

#### Get Logs ¯\_(ツ)_/¯

```console
$ kubectl logs -n kube-system <POD_NAME>
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
