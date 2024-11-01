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

## Installation

git clone <repository-url>
cd <repository-directory>

## Troubleshooting

### I have in LCP Timeout!

If you have an, LCP Timeout, you can see more info on: https://pptpclient.sourceforge.net/howto-diagnosis.phtml#lcp_timeout
