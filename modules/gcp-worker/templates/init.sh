#!/bin/bash

apt-get update
apt-get -qq -y upgrade
apt-get install \
  --no-install-recommends -qq -y \
  containerd \
  runc \
  ca-certificates \
  curl \
  wget \
  git-core

echo "Configuring host network parameters" \
  && modprobe br_netfilter \
  && sysctl -w net.netfilter.nf_conntrack_max=1000000 \
  && echo "net.netfilter.nf_conntrack_max=1000000" >> /etc/sysctl.conf \
  && sysctl -w net.bridge.bridge-nf-call-iptables=1 \
  && echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf \
  && sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.d/99-sysctl.conf \
  && sysctl --quiet --system

echo "Configuring host DNS" \
  && systemctl disable systemd-resolved.service \
  && systemctl stop systemd-resolved \
  && rm -rf /etc/resolv.conf \
  && ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

echo "Installing CRI tools" \
  && wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v${cri_tools_version}/crictl-v${cri_tools_version}-linux-amd64.tar.gz -O cri-tools.tar.gz \
  && tar -C /usr/local/bin -xf cri-tools.tar.gz \
  && rm cri-tools.tar.gz

echo "Installing CNI plugins" \
  && mkdir -p /opt/cni/bin \
  && wget https://github.com/containernetworking/plugins/releases/download/v${cni_plugins_version}/cni-plugins-linux-amd64-v${cni_plugins_version}.tgz -O cni.tgz \
  && tar -C /opt/cni/bin -xf cni.tgz \
  && rm cni.tgz

echo "Installing oneinfra" \
  && wget https://github.com/oneinfra/oneinfra/releases/download/${oneinfra_version}/oi-linux-amd64-${oneinfra_version} -O /usr/local/bin/oi \
  && chmod +x /usr/local/bin/oi

echo "Configuring containerd" \
  && mkdir -p /etc/cni/net.d \
  && mkdir -p /etc/containerd \
  && containerd config default  > /etc/containerd/config.toml

echo "Cleaning up instance" \
  && apt-get clean -y \
  && rm -rf /var/cache/debconf/* \
            /var/lib/apt/lists/* \
            /var/log/* \
            /tmp/* \
            /var/tmp/* \
            /usr/share/doc/* \
            /usr/share/man/* \
            /usr/share/local/*

mkdir -p /var/log/pods
mkdir -p /var/log/pods
systemctl enable containerd
systemctl restart containerd

echo "Joining the worker"

cat <<CA > /tmp/ca.crt
${ca_crt}
CA

/usr/local/bin/oi node join \
  --nodename $(hostname -f) \
  --container-runtime-endpoint unix:///run/containerd/containerd.sock \
  --image-service-endpoint unix:///run/containerd/containerd.sock \
  --apiserver-endpoint ${apiserver_endpoint} \
  --apiserver-ca-cert-file /tmp/ca.crt \
  --join-token ${join_token}
