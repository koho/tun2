#!/bin/sh
set -e
set -o pipefail
set -u

# Required parameters
: ${SUBNET}
set +u

# System config
sysctl -w net.ipv4.ip_forward=1
ulimit -n $(ulimit -n -H)

cd /etc/trojan-go

# Resolve proxy server address to IPv4 address
REMOTE=$(jq -r '.remote_addr // empty' config.json)
[ -z "$REMOTE" ] && { echo "[trojan-go] empty remote address"; exit 1; }

SERVER_IP=$(getent ahostsv4 $REMOTE | awk '{ print $1 }' | sort | uniq | paste -s -d " ")
[ -z "$SERVER_IP" ] && { echo "[trojan-go] fail to resolve remote address '$REMOTE'"; exit 1; }
DNS_IP=$(cat /etc/resolv.conf | grep -i '^nameserver'| head -n1 | cut -d ' ' -f2)

SOCKS_LOCAL=$(jq -r '(.local_addr) + ":" + (.local_port | tostring)' config.json)

# Start proxy client
/usr/local/bin/trojan-go -config config.json &

# Start tun2socks
source /usr/bin/tun2socks.sh $SOCKS_LOCAL $SERVER_IP $DNS_IP $SUBNET

echo "[trojan-go] startup completed"

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
