variable "proxmox_api_url" {
  description = "Proxmox VE API server URL."
  type        = string
}

variable "proxmox_target_node" {
  description = "Proxmox node the machine will be created on."
  type        = string
}

variable "authorized_keys" {
  description = "SSH public keys to add with Cloud Init."
  type        = list(string)
}
