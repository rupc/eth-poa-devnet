#! env sh

echo -ne '\n\n' | DAG_SIGNER="false" geth --datadir signers/signer2 --unlock 06e79e186441d5189b9cb2460c6ff727a06b2105 --password="" --mine --miner.etherbase 06e79e186441d5189b9cb2460c6ff727a06b2105 --networkid 42342 --bootnodes enode://0a13916723b1ba1950f89e8358e2ee773e8eeff14089820e7db606c66950c007cc087121ff06ffca08e4bdb56214fe2b7215acaac91d96ab4a4d191b21680806@127.0.0.1:0?discport=30305 --miner.gasprice 0 --vmodule miner/*=6 --ipcdisable --http.port 8544 --port 30302 --ws.port 30002 --authrpc.port=8001

