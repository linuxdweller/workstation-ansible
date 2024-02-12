terraform {
  required_version = ">= 1.1"
}

resource "random_uuid" "machine_name" {}

module "workstation" {
  source = "github.com/LKummer/terraform-proxmox//modules/machine?ref=4.0.1"

  proxmox_api_url  = var.proxmox_api_url
  proxmox_template = "debian-12.4.0-2"

  name            = "workstation-${random_uuid.machine_name.result}"
  description     = "Dynamically cloned workstation."
  on_boot         = true
  memory          = 8192
  cores           = 8
  disk_pool       = "lvm-nvme-1n1"
  disk_size       = 32
  authorized_keys = var.authorized_keys
}
