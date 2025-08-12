# Phase 3 — kubeadm on Azure VMs

Provision 1 control-plane + 2 workers (Ubuntu 22.04). Open NSG ports 22, 6443, 10250, and optionally 30000–32767 for NodePort.

On each VM:
```bash
sudo -i
bash 00-prereqs.sh
```

Control-plane:
```bash
bash 10-controlplane.sh
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/calico.yaml
```
Workers:
```bash
bash 20-worker.sh
# paste 'kubeadm join ...' from init output
```

Copy `/root/.kube/config` to your laptop and use `kubectl`.
