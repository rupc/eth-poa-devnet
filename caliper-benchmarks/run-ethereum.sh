#!/bin/bash

# (cd /home/jyr/go/src/github.com/rupc/eth-poa-devnet; bash ./node1-start.sh)
# (cd /home/jyr/go/src/github.com/rupc/eth-poa-devnet; printf "\n" | bash ./start-signer.sh)
# exit
# pkill -f geth

# (cd /home/jyr/go/src/github.com/rupc/eth-poa-devnet; bash ./init-genesis.sh)


# echo "start signer"
# (cd /home/jyr/go/src/github.com/rupc/eth-poa-devnet; printf "\n" | bash ./start-signer.sh > /dev/null 2>&1 &)
# sleep 2

# echo "start node1"
# (cd /home/jyr/go/src/github.com/rupc/eth-poa-devnet; bash ./node1-start.sh > /dev/null 2>&1 &)

# echo "start node2"
# (cd /home/jyr/go/src/github.com/rupc/eth-poa-devnet; bash ./node2-start.sh > /dev/null 2>&1 &)

# sleep 8
caliper launch manager \
    --caliper-bind-sut ethereum \
    --caliper-bind-sdk 1.11.7 \
    --caliper-benchconfig ./benchmarks/scenario/simple/config.yaml \
    --caliper-networkconfig ./networks/ethereum/1node-clique/networkconfig1.json &

caliper launch manager \
    --caliper-bind-sut ethereum \
    --caliper-bind-sdk 1.11.7 \
    --caliper-benchconfig ./benchmarks/scenario/simple/config.yaml \
    --caliper-networkconfig ./networks/ethereum/1node-clique/networkconfig2.json
