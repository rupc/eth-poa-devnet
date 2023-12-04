#! env bash

# if [ -d ./data ]; then
#     echo "removing the existing blockchain data directory"
#     rm ./data -rf
# fi

if [ ! -f genesis.json ]; then
    echo "genesis.json must be provided"
    exit 1
fi


# if [ -d ./signer/geth ]; then
#     echo "signer/geth removed"
#     rm ./signer/geth -R
# fi

# if [ -d ./node1/geth ]; then
#     echo "node1/geth removed"
#     rm ./node1/geth -R
# fi

# if [ -d ./node2/geth ]; then
#     echo "node2/geth removed"
#     rm ./node2/geth -R
# fi


# echo "Initializing signer node directory"
# geth init --datadir ./signer genesis.json

# echo "Initializing Member node(node1,node2) directory"
# geth init --datadir ./node1 genesis.json
# geth init --datadir ./node2 genesis.json

# Scaling PoA Nodes
# numNodes=2
# numNodes=16
DAPOA_MODE="DAG"

if [ -z "${NUM_NODES}" ]; then
    exit "NUM_NODES must be given"
fi


for (( i=1; i<=${NUM_NODES}; i++ ))
do
    if [ -d ./signers/signer${i}/geth ]; then
        echo "signer${i}/geth removed"
        # rm ./signers/signer${i} -R
        sudo rm ./signers/signer${i}/geth -R
    fi
    echo "Initializing signer${i} node directory"

    if [ "$DAPOA_MODE" == "Clique" ]; then
        # 공통된 genesis.json 으로 초기화
        cp genesis.json ./signers/signer${i}/
        geth init --datadir ./signers/signer${i} ./genesis.json > /dev/null 2>&1
    else
        # 독립적 genesis.json 으로 초기화
        geth init --datadir ./signers/signer${i} ./signers/signer${i}/genesis.json > /dev/null 2>&1
    fi


    # 각자 genesis.json 만들기.
    # geth init --datadir ./signers/signer${i} ./signers/signer${i}/genesis.json > /dev/null
    # geth init --datadir ./signers/signer${i} ./signers/signer${i}/genesis.json
    
    
    # echo -ne '\n\n' | geth account new --datadir ./signers/signer${i} &

    # if [ -d ./members/member${i}/geth ]; then
    #     echo "signer$i/geth removed"
    #     # rm ./members/member${i} -R
    #     rm ./members/member${i}/geth -R
    # fi
    # echo "Initializing member${i} node directory"
    # geth init --datadir ./members/member${i} ./members/member${i}/genesis.json
    # cp genesis.json ./members/member${i}/
    # echo -ne '\n\n' | geth account new --datadir ./members/member${i} &
done
