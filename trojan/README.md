# Trojan

Supported environment variable:

| Environment variable | Description                                           | Required |
|----------------------|-------------------------------------------------------|----------|
| SUBNET               | Subnet (CIDR) traffic that goes into tunnel.          | Yes      |

You must mount the local config file to the container using `-v /etc/ss/config.json:/config.json`.
