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
