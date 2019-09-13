#!/bin/bash
# 20190905,09
# single-node
# run as root

# start with:
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common containerd

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

systemctl restart containerd

kubeadm init
# ...
#Your Kubernetes control-plane has initialized successfully!
#
#To start using your cluster, you need to run the following as a regular user:
#
#  mkdir -p $HOME/.kube
#  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#  sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
#You should now deploy a pod network to the cluster.
#Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#  https://kubernetes.io/docs/concepts/cluster-administration/addons/
#
#Then you can join any number of worker nodes by running the following on each as root:
#
#kubeadm join 10.0.0.78:6443 --token yn98tp.4z7arx6tjk5btd9b \
#    --discovery-token-ca-cert-hash sha256:55b7abf73b35569ed470ca61b7fd89c7d44ddc784f70bbdf8dc9bf8830165430
#...
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# remove the NoSchedule taint or join worker node
kubectl taint node $HOSTNAME node-role.kubernetes.io/master:NoSchedule-
#kubeadm join 10.0.0.78:6443 --token yn98tp.4z7arx6tjk5btd9b --discovery-token-ca-cert-hash sha256:55b7abf73b35569ed470ca61b7fd89c7d44ddc784f70bbdf8dc9bf8830165430 --cri-socket /var/run/containerd/containerd.sock