locals {
  network    = "default"
  subnetwork = "default"
}

module "k8spin_oneinfra_workers" {
  source = "github.com/k8spin/oneinfra-worker-modules//modules/gcp-worker"

  # Software
  cri_tools_version   = "1.18.0"          # Default value. Optional
  cni_plugins_version = "0.8.5"           # Default value. Optional
  oneinfra_version    = "20.05.0-alpha10" # Default value. Optional
  # Infrastructure
  workers      = 1               # Default value. Optional
  machine_type = "n1-standard-1" # Default value. Optional
  ssh_key      = file("/home/angel/.ssh/id_rsa.pub")
  zone         = "europe-west3-a"
  network      = local.network    # Default value. Optional
  subnetwork   = local.subnetwork # Default value. Optional
  disk_size    = 20               # Default value. Optional
  ssh_from     = ["0.0.0.0/0"]    # Make sure to put just your IP
  # Kubernetes Cluster
  ca_crt             = "PUT_HERE_YOUR_BASE64_CA_CRT"
  apiserver_endpoint = "PUT_HERE_YOUR_APISERVER_ENDPOINT"
  join_token         = "PUT_HERE_YOUR_TOKEN_HERE"
}

resource "google_compute_firewall" "k8spin_oneinfra_cni" {
  name          = "k8spin-oneinfra-cni"
  network       = local.network
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"] # Don't do it in production environments
  allow {
    protocol = "udp"
    ports    = ["8472"] # Flannel vxlan port
  }
  target_tags = module.k8spin_oneinfra_workers.network_tags
}

output "worker_ips" {
  description = "My worker IPs"
  value       = module.k8spin_oneinfra_workers.public_ips
}
