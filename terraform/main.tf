variable "cloudinit_template_name" {
    type = string 
}

variable "proxmox_node" {
    type = string
}

variable "ssh_key" {
    type = string 
    sensitive = true
}

variable "cloudinit_template_name" {
    type = string 
}

variable "proxmox_node" {
    type = string
}

variable "ssh_public_key_file" {
  type = string
  sensitive = true
}

resource "proxmox_vm_qemu" "odin10" {
  count = 3
  name = "odin10${count.index + 1}"
  target_node = var.proxmox_node
  clone = var.cloudinit_template_name
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "x86-64-v2-AES"
  memory = 16384
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "128G"
    type = "scsi"
    storage = "TrueNAS"
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
    tag = 3
  }
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.3.12${count.index + 1}/24,gw=192.168.3.1"
  nameserver = "192.168.3.1"

}