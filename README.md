# tun2

A combination of [badvpn-tun2socks](https://github.com/ambrop72/badvpn) and other proxy clients.

Available Docker images:

| Image            | Note                                                                       |
|------------------|----------------------------------------------------------------------------|
| tun2/socks       | Just `badvpn-tun2socks`.                                                   |
| tun2/shadowsocks | Use [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev). |
| tun2/trojan      | Use [trojan-go](https://github.com/p4gefau1t/trojan-go).                   |

## How it works

1. Create a [TUN](https://en.wikipedia.org/wiki/TUN/TAP) device like a VPN software.
2. Modify the routing table and route all traffic to the TUN device.
3. The software `tun2socks` will forward traffic (TCP and UDP) from TUN device to the SOCKS server of proxy client.
4. The proxy client forwards traffic to remote proxy server.

## Usage

```shell
docker pull tun2/shadowsocks
```

You must run this container in `--privileged` mode. See [Run](#Run).

### Shadowsocks

| Environment variable | Description                                           | Required |
|----------------------|-------------------------------------------------------|----------|
| URL                  | Shadowsocks subscription link.                        | No       |
| SUBNET               | Subnet (CIDR) traffic that goes into tunnel.          | Yes      |
| NAME                 | Use the specific named proxy in subscription.         | No       |
| UPDATE               | If "true", update config file from subscription link. | No       |

If you don't use subscription link, mount the local config file to the container
using `-v /etc/ss/config.json:/subs.json`.

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

### Trojan

| Environment variable | Description                                           | Required |
|----------------------|-------------------------------------------------------|----------|
| SUBNET               | Subnet (CIDR) traffic that goes into tunnel.          | Yes      |

You must mount the local config file to the container using `-v /etc/trojan-go/config.json:/config.json`.

### Run

For examples, your local subnet is `192.168.0.0/16`.

#### Use subscription link

```shell
docker run --privileged -e URL=https://example.com/ -e SUBNET=192.168.0.0/16 tun2/shadowsocks
```

#### Use local config file

```shell
docker run --privileged -v /etc/ss/config.json:/subs.json -e SUBNET=192.168.0.0/16 tun2/shadowsocks
```

### Change gateway

Change the default gateway of your host to the container IP. The traffic of your host should go through the Shadowsocks
tunnel in the container now.

## Use cases

- OpenWrt
- RouterOS
