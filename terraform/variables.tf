variable "proxmox_api_url" {
  description = "Proxmox VE API server URL."
  type        = string
}

variable "proxmox_target_node" {
  description = "Proxmox node the machine will be created on."
  type        = string
}

variable "cloud_init_public_keys" {
  description = "SSH public keys to add with Cloud Init."
  type        = string
  default     = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmTzPVmwo0Q7txYnDkD2ubmRxLUBP1MB5x5j8+v0hK8 lior-workstation
EOF
}
