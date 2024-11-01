# PPTP VPN Client Docker Setup

This repository provides a Docker-based solution for connecting to a PPTP VPN using Alpine Linux. The setup is designed to be lightweight and configurable, allowing users to connect to a PPTP VPN server with minimal effort.

You can get more info on https://wiki.archlinux.org/title/PPTP_Client

## Requirements

- Docker

**ON YOUR HOST MACHINE**

### Enable kernel modules

You need to:

```bash
sudo modprobe nf_conntrack_pptp
sudo modprobe nf_conntrack_proto_gre
```

see https://askubuntu.com/a/596225

### Enable GRE on Firewall

You need to enable the GRE protocol in your firewall

See https://discussion.fedoraproject.org/t/nf-conntrack-helper-is-missing-from-kernel-6-0-5/70248 to see how to do it on Fedora

### netfilter nf_conntrack_helper

If your system allows you to, run

```bash
sudo sysctl net.netfilter.nf_conntrack_helper=1
```

### Add iptables rule

Based on https://www.reddit.com/r/linuxadmin/comments/1agzsbm/missing_nf_conntrack_proto_greko_kernel_6612/, you need to execute this

```bash
iptables -t raw -A PREROUTING -p tcp --dport 1723 -j CT --helper pptp
```

## Installation and execution

Clone the repo with

```
git clone https://github.com/KrappRamiro/docker-pttp-vpn-client
cd docker-pttp-vpn-client
```

Create an `.env` file with the following values:

```env
VPN_SERVER=YOUR_VPN_IP_ADDRESS_HERE
VPN_USER=YOUR_VPN_USER_HERE
VPN_PASS=YOUR_VPN_PASSWORD_HERE
```

Run the container with `docker compose up -d`

## How to make other containers "use" the VPN

You can use `network_mode` to "mount" a container's network on another container's network

Use this example as base

```yml
services:
  pptp-vpn-client:
    cap_add:
      - NET_ADMIN # See https://stackoverflow.com/a/70968064/15965186
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      VPN_SERVER: ${VPN_SERVER}
      VPN_USER: ${VPN_USER}
      VPN_PASS: ${VPN_PASS}
    privileged: true

  another-container:
    image: YOUR_IMAGE_HERE
    network_mode: service:pptp-vpn-client # Attach this container to pptp-vpn-client network, see https://docs.docker.com/engine/network/#container-networks
```

## Troubleshooting

### I have in LCP Timeout!

If you have an, LCP Timeout, you can see more info on: https://pptpclient.sourceforge.net/howto-diagnosis.phtml#lcp_timeout
