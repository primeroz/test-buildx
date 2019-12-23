#!/usr/bin/env bash
set -e

TESTNET=${TESTNET_ENABLED:-'false'}
REGTEST=${REGTEST_ENABLED:-'false'}

BITCOIN_CONF=$BITCOIN_DATA/bitcoin.conf


setup_connect_addnode() {
  # PLACEHOLDER
  printf "\n##############################################################" >> $BITCOIN_CONF
  printf "\n##            Quick Primer on addnode vs connect            ##" >> $BITCOIN_CONF
  printf "\n##  Let's say for instance you use addnode=4.2.2.4          ##" >> $BITCOIN_CONF
  printf "\n##  addnode will connect you to and tell you about the      ##" >> $BITCOIN_CONF
  printf "\n##    nodes connected to 4.2.2.4.  In addition it will tell ##" >> $BITCOIN_CONF
  printf "\n##    the other nodes connected to it that you exist so     ##" >> $BITCOIN_CONF
  printf "\n##    they can connect to you.                              ##" >> $BITCOIN_CONF
  printf "\n##  connect will not do the above when you 'connect' to it. ##" >> $BITCOIN_CONF
  printf "\n##    It will *only* connect you to 4.2.2.4 and no one else.##" >> $BITCOIN_CONF
  printf "\n##                                                          ##" >> $BITCOIN_CONF
  printf "\n##  So if you're behind a firewall, or have other problems  ##" >> $BITCOIN_CONF
  printf "\n##  finding nodes, add some using 'addnode'.                ##" >> $BITCOIN_CONF
  printf "\n##                                                          ##" >> $BITCOIN_CONF
  printf "\n##  If you want to stay private, use 'connect' to only      ##" >> $BITCOIN_CONF
  printf "\n##  connect to "trusted" nodes.                             ##" >> $BITCOIN_CONF
  printf "\n##                                                          ##" >> $BITCOIN_CONF
  printf "\n##  If you run multiple nodes on a LAN, there's no need for ##" >> $BITCOIN_CONF
  printf "\n##  all of them to open lots of connections.  Instead       ##" >> $BITCOIN_CONF
  printf "\n##  'connect' them all to one node that is port forwarded   ##" >> $BITCOIN_CONF
  printf "\n##  and has lots of connections.                            ##" >> $BITCOIN_CONF
  printf "\n##       Thanks goes to [Noodle] on Freenode.               ##" >> $BITCOIN_CONF
  printf "\n##############################################################" >> $BITCOIN_CONF
  printf "\n" >> $BITCOIN_CONF
  printf "\n# Use as many addnode= settings as you like to connect to specific peers" >> $BITCOIN_CONF
  printf "\n#addnode=69.164.218.197" >> $BITCOIN_CONF
  printf "\n#addnode=10.0.0.2:8333" >> $BITCOIN_CONF
  printf "\n" >> $BITCOIN_CONF
  printf "\n# Alternatively use as many connect= settings as you like to connect ONLY to specific peers" >> $BITCOIN_CONF
  printf "\n#connect=69.164.218.197" >> $BITCOIN_CONF
  printf "\n#connect=10.0.0.1:8333" >> $BITCOIN_CONF
  printf "\n" >> $BITCOIN_CONF
}

setup_rpc_config() {
  printf "\n# JSON-RPC options (for controlling a running Bitcoin/bitcoind process)" >> $BITCOIN_CONF
  printf "\n#server=0" >> $BITCOIN_CONF
  printf "\n#rpcbind=<addr>" >> $BITCOIN_CONF
  printf "\n#rpcport=8332" >> $BITCOIN_CONF
  printf "\n#rpccookie" >> $BITCOIN_CONF
  printf "\n#rpcclienttimeout=30" >> $BITCOIN_CONF
  printf "\n#rpcallowip=10.1.1.34/255.255.255.0" >> $BITCOIN_CONF
  printf "\n#rpcallowip=1.2.3.4/24" >> $BITCOIN_CONF
  printf "\n# Multiple rpcauth" >> $BITCOIN_CONF
  printf "\n# rpcauth=alic:b2dd077cb54591a2f3139e69a897ac$4e71f08d48b4347cf8eff3815c0e25ae2e9a4340474079f55705f40574f4ec99" >> $BITCOIN_CONF
  printf "\n# rpcauth=bob:b2dd077cb54591a2f3139e69a897ac$4e71f08d48b4347cf8eff3815c0e25ae2e9a4340474079f55705f40574f4ec99" >> $BITCOIN_CONF
  printf "\n" >> $BITCOIN_CONF
}

setup_onion_config() {
  printf "\n#Onion Configs" >> $BITCOIN_CONF
  printf "\ndebug=tor" >> $BITCOIN_CONF
  printf "\n#TOR Control enabled with listenonion=1" >> $BITCOIN_CONF
  printf "\nlistenonion=1" >> $BITCOIN_CONF
# TOR
# proxy=tor:9050
# onion=tor:9050
# externalip=q4xu2o53ug5kh5eg.onion
# # disable tor control
# listenonion=0
  printf "\n" >> $BITCOIN_CONF
}



### Config 
if [[ -d "$BITCOIN_DATA" ]]; then

  cat >$BITCOIN_CONF <<EOF

##
## bitcoin.conf configuration file. Lines beginning with # are comments.
##
# Network-related settings:

EOF

  if [[ "x${TESTNET}" == "xtrue" ]]; then
    printf "\ntestnet=1" >> $BITCOIN_CONF
  elif [[ "x${REGTEST}" == "xtrue" ]]; then
    printf "\nregtest=1" >> $BITCOIN_CONF
  fi
  
  if [[ ! "x${SOCKSPROXY}" == "x" ]]; then
    printf "\n# Connect via a SOCKS5 proxy" >> $BITCOIN_CONF
    printf "\nproxy=${SOCKSPROXY}" >> $BITCOIN_CONF
  fi
  
  printf "\n# Bind to given address and always listen on it. Use [host]:port notation for IPv6" >> $BITCOIN_CONF
  printf "\nbind=${BINDADDR:-127.0.0.1}" >> $BITCOIN_CONF
  printf "\nport=${BINDPORT:-8333}" >> $BITCOIN_CONF
  # Bind to given address and whitelist peers connecting to it. Use [host]:port notation for IPv6
  #whitebind=<addr>
  
  printf "\n# ZeroMQ" >> $BITCOIN_CONF
  printf "\nzmqpubrawblock=tcp://127.0.0.1:28332" >> $BITCOIN_CONF
  printf "\nzmqpubrawtx=tcp://127.0.0.1:28333" >> $BITCOIN_CONF
  
  setup_connect_addnode
  setup_rpc_config
  #setup_rest_config
  setup_onion_config
  
  
  printf "\n# Listening mode, enabled by default except when 'connect' is being used" >> $BITCOIN_CONF
  printf "\nlisten=1" >> $BITCOIN_CONF
  
  printf "\n# Maximum number of inbound+outbound connections." >> $BITCOIN_CONF
  printf "\nmaxconnections=${MAXCONNECTIONS:-40}" >> $BITCOIN_CONF
  printf "\n# Other performance settings" >> $BITCOIN_CONF
  printf "\nmaxuploadtarget=${MAXUPLOADTARGET:-5000}" >> $BITCOIN_CONF
  # Ideally bigger dbcache during sync # Raise with bitcoin-cli command at runtime?
  printf "\ndbcache=${DBCACHE:-100}" >> $BITCOIN_CONF
  printf "\nmaxorphantx=${MAXORPHANTX:-10}" >> $BITCOIN_CONF
  printf "\nmaxmempool=${MAXMEMPOOL:-50}" >> $BITCOIN_CONF
  
  printf "\n\n# Misc Settings" >> $BITCOIN_CONF
  printf "\nprinttoconsole=1" >> $BITCOIN_CONF
  printf "\ntxindex=${TXINDEX:-1}" >> $BITCOIN_CONF
  
  printf "\n\n# END of config\n" >> $BITCOIN_CONF

  chown bitcoin:bitcoin $BITCOIN_CONF
  chmod 500 $BITCOIN_CONF

fi
