output "public_ips" {
  description = "Ephemeral public IPs for the workers"
  value       = google_compute_instance.oneinfra_worker.*.network_interface.0.access_config.0.nat_ip
}

output "network_tags" {
  description = "Network tags assigned to the instances. Useful to open new firewall rules (cni)"
  value       = local.oneinfra_worker_tags
}

output "ssh_user" {
  description = "SSH User needed to access the workers. Use this value with your private key"
  value       = local.oneinfra_ssh_user
}
