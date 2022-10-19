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

cd /etc/shadowsocks

if [ "$UPDATE" == "true" ] || [ ! -f config.json ]; then
  set -u
  : ${URL}
  set +u
  # Download proxy config
  wget $URL -O config.json
fi

[ -z "$NAME" ] && FILTER='.[0]' || FILTER='first(.[] | select(.name == env.NAME))'
jq -r "$FILTER" config.json > /tmp/config.json

cd /tmp

[ -s config.json ] || { echo "[shadowsocks] proxy item not found"; exit 1; }

# Resolve proxy server address to IPv4 address
REMOTE=$(jq -r '.server // empty' config.json)
[ -z "$REMOTE" ] && { echo "[shadowsocks] empty proxy server"; exit 1; }
SERVER_IP=$(getent ahostsv4 $REMOTE | awk 'NR==1{ print $1 }')
[ -z "$SERVER_IP" ] && { echo "[shadowsocks] fail to resolve proxy server address '$REMOTE'"; exit 1; }

# Rewrite proxy address
jq --arg ip "$SERVER_IP" '.server = $ip | .local_address = "127.0.0.1" | .local_port = 10809' config.json > config.json.tmp && mv config.json.tmp config.json
SOCKS_LOCAL=$(jq -r '(.local_address) + ":" + (.local_port | tostring)' config.json)

# Proxy config is ready now
TITLE=$(jq -r '.remarks + "(" + .name + ")"' config.json)
echo "[shadowsocks] using proxy '$TITLE' at $SERVER_IP"

# Start proxy client
ss-local -c config.json &

# Start tun2socks
source /usr/bin/tun2socks.sh $SOCKS_LOCAL $SERVER_IP $SUBNET

echo "[shadowsocks] startup completed"

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
