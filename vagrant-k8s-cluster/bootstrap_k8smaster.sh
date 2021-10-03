#!/bin/bash

echo "[TASK 11] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 12] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.100.100 --pod-network-cidr=10.96.0.0/16 >> /root/kubeinit.log 2>/dev/null

echo "[TASK 13] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 14] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 15] Create .kube/config"
mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown -R $USER:$GROUP $HOME/.kube
