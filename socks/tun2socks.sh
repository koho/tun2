#!/bin/sh
badvpn-tun2socks --loglevel 3 --tundev proxy --netif-ipaddr 240.0.0.2 --netif-netmask 240.0.0.0 --socks-server-addr $1 --socks5-udp &

sleep 3

# Setup proxy interface
ip addr add 240.0.0.1/4 dev proxy
ifconfig proxy up

# Setup default route for non-proxy network
GW=$(ip route | awk '/default/ { print $3 }')
ip route flush scope global
i=1
for arg; do
    [ $i -gt 1 ] && ip route add $arg via $GW
    i=$((i + 1))
done

# Route all other traffics to the proxy interface
ip route add default via $GW metric 1
ip route add default via 240.0.0.2 metric 0
