#!/bin/bash

echo "centos template started..."

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "downloading latest cloud img..."
cd /root/
wget -r https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2

echo "customizing img..."
virt-customize -a CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 --install qemu-guest-agent
virt-customize -a CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 --root-password file:/root/ansible_ssh_key.txt
virt-customize -a CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 --run-command "useradd -m -s /bin/bash sanidin"
virt-customize -a CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 --password sanidin:file:/root/ansible_ssh_key.txt
virt-customize -a CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 --ssh-inject sanidin:file:/root/ansible_ssh_key.txt

echo "creating template..."
qm create 9001 --name "centos-template" --memory 2048 --net0 virtio,bridge=vmbr0,tag=3
qm importdisk 9001 /root/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 TrueNAS
qm set 9001 --scsihw virtio-scsi-pci -scsi0 TrueNAS:vm-9001-disk-0
qm set 9001 --boot c --bootdisk scsi0
qm set 9001 --ide2 TrueNAS:cloudinit
qm set 9001 --serial0 socket --vga serial0
qm set 9001 -agent 1
qm template 9001

echo "centos template completed."