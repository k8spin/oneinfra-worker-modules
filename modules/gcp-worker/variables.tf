variable "workers" {
  description = "Number of machines to create as workers"
  type        = number
  default     = 1
}

variable "cri_tools_version" {
  description = "Version of the CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  type        = string
  default     = "1.18.0"
}

variable "cni_plugins_version" {
  description = "Version of the CNI plugins to be installed along with containerd"
  type        = string
  default     = "0.8.5"
}

variable "oneinfra_version" {
  description = "oneinfra binaries version"
  type        = string
  default     = "20.05.0-alpha10"
}

variable "machine_type" {
  description = "The machine type to create"
  type        = string
  default     = "n1-standard-1"
}

variable "ssh_key" {
  description = "SSH Key to access machines using the oneinfra username"
  type        = string
}

variable "zone" {
  description = "The zone that the machine should be created in"
  type        = string
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to"
  default     = "default"
  type        = string
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in"
  default     = "default"
  type        = string
}

variable "disk_size" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image"
  type        = number
  default     = 20
}

variable "ssh_from" {
  type        = list(string)
  description = "The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format"
}

variable "ca_crt" {
  type        = string
  description = "Base64 encoded ca of the oneinfra control-plane"
}

variable "apiserver_endpoint" {
  type        = string
  description = "oneinfra APIServer endpoint"
}

variable "join_token" {
  type        = string
  description = "oneinfra APIServer join token"
}
