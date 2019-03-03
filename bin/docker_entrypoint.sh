#!/bin/bash

set -euo pipefail

COIN_DIR=/root/.${COINNAME}
COIN_CONF=${COIN_DIR}/${COINNAME}.conf
DAEMON=${COINNAME}d

# If config doesn't exist, initialize with sane defaults for running a
# non-mining node.

if [ ! -e "${COIN_CONF}" ]; then
  tee -a >${COIN_CONF} <<EOF

# For documentation on the config file, see
#
# the bitcoin source:
#   https://github.com/bitcoin/bitcoin/blob/master/share/examples/bitcoin.conf
# the wiki:
#   https://en.bitcoin.it/wiki/Running_Bitcoin

# server=1 tells Bitcoin-Qt and bitcoind to accept JSON-RPC commands
server=1

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
rpcuser=${RPCUSER:-${COINNAME}}
rpcpassword=${RPCPASSWORD:-changemeplz}

# How many seconds bitcoin will wait for a complete RPC HTTP request.
# after the HTTP connection is established.
rpcclienttimeout=${RPCCLIENTTIMEOUT:-30}

rpcallowip=${RPCALLOWIP:-::/0}

# Listen for RPC connections on this TCP port:
rpcport=${RPCPORT:-8332}

# Print to console (stdout) so that "docker logs bitcoind" prints useful
# information.
printtoconsole=${PRINTTOCONSOLE:-1}

# We probably don't want a wallet.
disablewallet=${DISABLEWALLET:-0}

# Enable an on-disk txn index. Allows use of getrawtransaction for txns not in
# mempool.
txindex=${TXINDEX:-1}

# Run on the test network instead of the real bitcoin network.
testnet=${TESTNET:-1}

# Set database cache size in MiB
dbcache=${DBCACHE:-512}

# ZeroMQ notification options:
zmqpubrawblock=${ZMQPUBRAWBLOCK:-tcp://0.0.0.0:28333}
zmqpubrawtx=${ZMQPUBRAWTX:-tcp://0.0.0.0:28333}
zmqpubhashtx=${ZMQPUBHASHTX:-tcp://0.0.0.0:28333}
zmqpubhashblock=${ZMQPUBHASHBLOCK:-tcp://0.0.0.0:28333}

EOF
fi

if [ $# -eq 0 ]; then
  exec ${DAEMON} -datadir=${COIN_DIR} -conf=${COIN_CONF}
else
  exec "$@"
fi
