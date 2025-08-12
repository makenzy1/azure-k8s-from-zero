#!/usr/bin/env bash
set -euxo pipefail
cat >/root/kubeadm-config.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
kubernetesVersion: 1.31.0
networking:
  podSubnet: "192.168.0.0/16"
EOF
kubeadm init --config /root/kubeadm-config.yaml
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
