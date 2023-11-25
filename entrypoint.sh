#!/bin/sh

UNLOCK_KEY=
if [ -z "$UNLOCK_KEY" ]; then
    echo "UNLOCK_KEY must be provided!"
    exit 1
fi

if [ -z "$BOOTNODE" ]; then
    echo "BOOTNODE address must be provided!"
    exit 1
fi

if [[ "$NODE_TYPE" = "signer" ]]; then
  echo "Bootstrapping signer node"
  echo -ne '\n\n' | DAG_SIGNER="false" geth --datadir signers/signer1 --unlock f0dfc2f12368d4f88dd5791f21cc4f29a685fc09 --password="" --mine --miner.etherbase f0dfc2f12368d4f88dd5791f21cc4f29a685fc09 --networkid 42342 --bootnodes enode://0a13916723b1ba1950f89e8358e2ee773e8eeff14089820e7db606c66950c007cc087121ff06ffca08e4bdb56214fe2b7215acaac91d96ab4a4d191b21680806@127.0.0.1:0?discport=30305 --miner.gasprice 0 --vmodule miner/*=6 --metrics --metrics.addr "0.0.0.0" --metrics.port "6060"

elif [[ "$NODE_TYPE" = "normal" ]]; then
  echo "Bootstrapping tx node"
else
  echo "Unknown provided value for parameter: NODE_TYPE=$NODE_TYPE"
  exit 1
fi
