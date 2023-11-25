#! env sh
echo -ne '\n\n' | DAG_SIGNER="false" geth --datadir signers/signer1 --unlock f0dfc2f12368d4f88dd5791f21cc4f29a685fc09 --password="" --mine --miner.etherbase f0dfc2f12368d4f88dd5791f21cc4f29a685fc09 --networkid 42342 --bootnodes enode://0a13916723b1ba1950f89e8358e2ee773e8eeff14089820e7db606c66950c007cc087121ff06ffca08e4bdb56214fe2b7215acaac91d96ab4a4d191b21680806@127.0.0.1:0?discport=30305 --miner.gasprice 0 --vmodule miner/*=6 --metrics --metrics.addr "0.0.0.0" --metrics.port "6060" --ipcdisable


