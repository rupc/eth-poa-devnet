# Ethereum PoA Clique Network 
The purpose of this repository is to provide developers with an **EASY SETUP WITHOUT ANY EFFORTS** of Clique network comprised of *any number of signers* and *benchmark environment* with Hyperledger Caliper (v0.5.0). 
Optionally, it also supports running geth in a Docker environment.



# How to Run
### Establish PoA Clique Network
```console
$ export NUM_NODES=8 # Configure the number of signers
$ ./init-genesis.sh # Initialize the genesis configs.
$ ./assemble_extraData.py ${NUM_NODES} # Assemble Extra Data field in each of the genesis.json
$ ./run-local-geth.py --num_nodes ${NUM_NODES} # Launch PoA Clique Network with NUM_NODES signers
```

### Benchmark the network
I setup a pre-defined network for local benchmark. 
The necessary network configurations are defined in networkconfigX.json
```console
$ cd caliper-benchmarks
$ ./run-caliper-ethereum.py ${NUM_NODES} # The results are recorded in logs. 
```
