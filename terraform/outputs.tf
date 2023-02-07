output "ssh_ip" {
  value       = module.workstation.ssh_ip
  description = "IP of the created virtual machine."
}

output "ssh_user" {
  value       = module.workstation.user
  description = "Name of user created by Cloud Init."
}
