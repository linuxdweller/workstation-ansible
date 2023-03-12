terraform {
  required_version = ">= 1.1"
}

module "workstation" {
  source = "github.com/LKummer/terraform-proxmox//modules/machine?ref=2.0.1"

  proxmox_api_url     = var.proxmox_api_url
  proxmox_target_node = var.proxmox_target_node
  proxmox_template    = "debian-11.6.0-1"

  name                   = "lior-workstation"
  description            = "Dynamically cloned workstation."
  on_boot                = true
  memory                 = 4096
  cores                  = 4
  disk_pool              = "local-lvm"
  disk_size              = "32G"
  cloud_init_public_keys = var.cloud_init_public_keys
}
