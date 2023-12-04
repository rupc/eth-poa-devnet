#!/bin/bash
set -x
if [ -z "${SIGNER_ID}" ]; then
    echo "SIGNER_ID address must be provided!"
    exit 1
fi
SIGNER_ID=${SIGNER_ID}
SIGNER_NAME=signer${SIGNER_ID}
METRIC_PORT=6060

echo "SIGNER_ID: $SIGNER_ID"
echo "SIGNER_NAME: $SIGNER_NAME"
echo "METRIC_PORT: $METRIC_PORT"
echo "NETWORK_ID $NETWORKD_ID"
echo "NODE_TYPE $NODE_TYPE"
echo "UNLOCK_KEY: $UNLOCK_KEY"


if [ -z "${UNLOCK_KEY}" ]; then
    echo "UNLOCK_KEY must be provided!"
    if [ -z "/signers/${SIGNER_NAME}/keystore/address" ]; then
      echo "keystore/address is empty!" 
      exit
    fi

    export UNLOCK_KEY=$(cat /signers/${SIGNER_NAME}/keystore/address)
    echo "FOUND UNLOCK_KEY: ${UNLOCK_KEY}"
fi


if [ -z "${BOOTNODE}" ]; then
    echo "BOOTNODE address is empty?"
fi

if [ -z "${NETWORKD_ID}" ]; then
    echo "SIGNER_NAME address must be provided!"
    exit 1
fi


if [[ "$NODE_TYPE" = "signer" ]]; then
  echo "Bootstrapping signer node"
  export DAG_SIGNER="true"
  # export BOOTNODE="enode://0a13916723b1ba1950f89e8358e2ee773e8eeff14089820e7db606c66950c007cc087121ff06ffca08e4bdb56214fe2b7215acaac91d96ab4a4d191b21680806@127.0.0.1:0?discport=30305"
  # echo -ne '\n\n' |  geth --datadir /signers/${SIGNER_NAME} --unlock ${UNLOCK_KEY} --password="" --mine --miner.etherbase ${UNLOCK_KEY} --networkid ${NETWORKD_ID} --bootnodes ${BOOTNODE} --miner.gasprice 0 --vmodule miner/*=6 --metrics --metrics.addr "0.0.0.0" --metrics.port "6060"

  echo -ne '\n\n' | geth --datadir /signers/${SIGNER_NAME} --unlock ${UNLOCK_KEY} --password="" --mine --miner.etherbase ${UNLOCK_KEY} --networkid ${NETWORKD_ID} --miner.gasprice 0 --vmodule miner/*=6 --metrics --metrics.addr "0.0.0.0" --metrics.port ${METRIC_PORT} --ipcdisable --http --http.api "eth,net,web3,personal" --http.addr 0.0.0.0 --http.port 40000 --ws --ws.addr 0.0.0.0 --ws.port 40001 --ws.origins "*" --ws.api "eth,net,web3,personal" --allow-insecure-unlock --rpc.enabledeprecatedpersonal
  # echo -ne '\n\n' | geth --datadir /signers/${SIGNER_NAME} --unlock ${UNLOCK_KEY} --password="" --mine --miner.etherbase ${UNLOCK_KEY} --networkid ${NETWORKD_ID} --bootnodes ${BOOTNODE} --miner.gasprice 0 --vmodule miner/*=6 --metrics --metrics.addr "0.0.0.0" --metrics.port ${METRIC_PORT} --ipcdisable --http --http.api "eth,net,web3,personal" --http.addr 0.0.0.0 --http.port 40000 --ws --ws.addr 0.0.0.0 --ws.port 40001 --ws.origins "*" --ws.api "eth,net,web3,personal" --allow-insecure-unlock --rpc.enabledeprecatedpersonal
elif [[ "$NODE_TYPE" = "normal" ]]; then
  echo "Bootstrapping tx node"
else
  echo "Unknown provided value for parameter: NODE_TYPE=$NODE_TYPE"
  exit 1
fi

