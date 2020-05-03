terraform {
  required_version = "> 0.12.0"
  required_providers {
    google   = ">= 3.19"
    template = ">= 2.1"
  }
}

locals {
  oneinfra_worker_tags   = ["oneinfra-worker"]
  oneinfra_worker_prefix = "oneinfra-worker-"
  oneinfra_os_image      = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
  oneinfra_ssh_user      = "oneinfra"
}

data "template_file" "oneinfra_worker" {
  template = file("${path.module}/templates/init.sh")
  vars = {
    cri_tools_version   = var.cri_tools_version
    cni_plugins_version = var.cni_plugins_version
    oneinfra_version    = var.oneinfra_version
    ca_crt              = base64decode(var.ca_crt)
    apiserver_endpoint  = var.apiserver_endpoint
    join_token          = var.join_token
  }
}

resource "google_compute_instance" "oneinfra_worker" {
  count          = var.workers
  name           = "${local.oneinfra_worker_prefix}${count.index}"
  machine_type   = var.machine_type
  can_ip_forward = true
  zone           = var.zone

  tags = local.oneinfra_worker_tags

  boot_disk {
    initialize_params {
      size  = var.disk_size
      image = local.oneinfra_os_image
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
    }
  }

  metadata_startup_script = data.template_file.oneinfra_worker.rendered

  metadata = {
    ssh-keys = <<EOT
${local.oneinfra_ssh_user}:${var.ssh_key}
EOT
  }
}

resource "google_compute_firewall" "oneinfra_worker_ssh" {
  name          = "${local.oneinfra_worker_prefix}ssh"
  network       = var.network
  direction     = "INGRESS"
  source_ranges = var.ssh_from

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = local.oneinfra_worker_tags
}
