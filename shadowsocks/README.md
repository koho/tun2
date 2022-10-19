# Shadowsocks

Supported environment variable:

| Environment variable | Description                                           | Required |
|----------------------|-------------------------------------------------------|----------|
| SUBNET               | Subnet (CIDR) traffic that goes into tunnel.          | Yes      |
| URL                  | Shadowsocks subscription link.                        | No       |
| NAME                 | Use the specific named proxy in subscription.         | No       |
| UPDATE               | If "true", update config file from subscription link. | No       |

If you don't use subscription link, mount the local config file to the container
using `-v /etc/ss/config.json:/etc/shadowsocks/config.json`.

The subscription link should download a JSON file that contains an array of proxy object.

```json
[
  {
    "name": "server1",
    "remarks": "My Server",
    "server": "example.com",
    "server_port": 2345,
    "method": "aes-256-gcm",
    "password": "test",
    "use_syslog": false,
    "ipv6_first": false,
    "fast_open": false,
    "reuse_port": false,
    "no_delay": false,
    "mode": "tcp_and_udp"
  }
]
```
