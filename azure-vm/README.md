# Phase 1 — Manual Azure VM

```bash
RESOURCE_GROUP=rg-k8s-zero
LOCATION=eastus
VM_NAME=vm-web-01
ADMIN_USER=deployer
DNS_LABEL=myfastapi$RANDOM

az group create -n $RESOURCE_GROUP -l $LOCATION
az vm create -g $RESOURCE_GROUP -n $VM_NAME --image Ubuntu2204 --size Standard_B2s   --admin-username $ADMIN_USER --generate-ssh-keys   --public-ip-sku Standard --public-ip-address-dns-name $DNS_LABEL   --custom-data @cloud-init.yaml

az vm open-port -g $RESOURCE_GROUP -n $VM_NAME --port 80
az vm open-port -g $RESOURCE_GROUP -n $VM_NAME --port 443
```

SSH to VM, copy app, install systemd unit (provided), set up nginx and Certbot as described.
