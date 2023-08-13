terraform {
  required_version = ">= 1.1"
}

resource "random_uuid" "machine_name" {}

module "workstation" {
  source = "github.com/LKummer/terraform-proxmox//modules/machine?ref=2.0.1"

  proxmox_api_url     = var.proxmox_api_url
  proxmox_target_node = var.proxmox_target_node
  proxmox_template    = "debian-12.1.0-1"

  name                   = "workstation-${random_uuid.machine_name.result}"
  description            = "Dynamically cloned workstation."
  on_boot                = true
  memory                 = 8192
  cores                  = 8
  disk_pool              = "local-lvm"
  disk_size              = "32G"
  cloud_init_public_keys = var.cloud_init_public_keys
}
