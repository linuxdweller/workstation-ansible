output "proxmox_id" {
  value       = module.workstation.id
  description = "Proxmox ID of the created machine."
}

output "ssh_ip" {
  value       = module.workstation.ip
  description = "IP of the created virtual machine."
}

output "ssh_user" {
  value       = module.workstation.user
  description = "Name of user created by Cloud Init."
}
