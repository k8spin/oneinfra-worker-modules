# GCP Workers

This module create `workers` google cloud instances (auto)joining them to the specified control-plane.
Worker instances uses `ubuntu-os-cloud/ubuntu-minimal-1804-lts` as boot disk image.

## Providers

| Name     | Version |
|----------|---------|
| google   | >= 3.19 |
| template | >= 2.1  |

## Inputs

| Name                  | Description                                                                                                                                         | Type           | Default             | Required |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|----------------|---------------------|:--------:|
| apiserver\_endpoint   | oneinfra APIServer endpoint                                                                                                                         | `string`       | n/a                 |   yes    |
| ca\_crt               | Base64 encoded ca of the oneinfra control-plane                                                                                                     | `string`       | n/a                 |   yes    |
| cni\_plugins\_version | Version of the CNI plugins to be installed along with containerd                                                                                    | `string`       | `"0.8.5"`           |    no    |
| cri\_tools\_version   | Version of the CLI and validation tools for Kubelet Container Runtime Interface (CRI)                                                               | `string`       | `"1.18.0"`          |    no    |
| disk\_size            | The size of the image in gigabytes. If not specified, it will inherit the size of its base image                                                    | `number`       | `20`                |    no    |
| join\_token           | oneinfra APIServer join token                                                                                                                       | `string`       | n/a                 |   yes    |
| machine\_type         | The machine type to create                                                                                                                          | `string`       | `"n1-standard-1"`   |    no    |
| network               | The name or self\_link of the network to attach this interface to                                                                                   | `string`       | `"default"`         |    no    |
| oneinfra\_version     | oneinfra binaries version                                                                                                                           | `string`       | `"20.05.0-alpha10"` |    no    |
| ssh\_from             | The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format                   | `list(string)` | n/a                 |   yes    |
| ssh\_key              | SSH Key to access machines using the oneinfra username                                                                                              | `string`       | n/a                 |   yes    |
| subnetwork            | The name or self\_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in | `string`       | `"default"`         |    no    |
| workers               | Number of machines to create as workers                                                                                                             | `number`       | `1`                 |    no    |
| zone                  | The zone that the machine should be created in                                                                                                      | `string`       | n/a                 |   yes    |

## Outputs

| Name          | Description                                                                     |
|---------------|---------------------------------------------------------------------------------|
| network\_tags | Network tags assigned to the instances. Useful to open new firewall rules (cni) |
| public\_ips   | Ephemeral public IPs for the workers                                            |
| ssh\_user     | SSH User needed to access the workers. Use this value with your private key     |

