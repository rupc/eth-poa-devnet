#!/usr/bin/env python3
import subprocess
import argparse
import os
import shutil
import threading

def run_geth_node(index):
    base_port=50000
    datadir = f"./signers/signer{index}"
    keystore_path = f"{datadir}/keystore/address"
    print(keystore_path)
    # keystore 파일에서 주소 읽기
    with open(keystore_path, 'r') as file:
        address = file.read().strip()
        

    # Geth 명령어 구성
    geth_cmd = (
        # f"echo -ne '\\n\\n' "
        # f"| DAG_SIGNER='false' " 
        f"export DAG_SIGNER=false; " 
        f"geth --datadir {datadir} "
        f" --unlock {address} "
        f"--password='password' " 
        f"--mine "
        f"--miner.etherbase {address} "
        f"--networkid 42342 "
        f"--bootnodes 'enode://0a13916723b1ba1950f89e8358e2ee773e8eeff14089820e7db606c66950c007cc087121ff06ffca08e4bdb56214fe2b7215acaac91d96ab4a4d191b21680806@127.0.0.1:0?discport=30305' "
        f"--miner.gasprice 0 "
        f"--ipcdisable "
        f"--http "
        f"--http.api 'eth,net,web3,personal' "
        f"--http.addr 0.0.0.0 "
        f"--http.port {base_port + index} "
        f"--ws "
        f"--ws.addr 0.0.0.0 "
        f"--ws.port {8000 + index-1} "
        f"--ws.origins '*' "
        f"--ws.api 'eth,net,web3,personal' "
        f"--allow-insecure-unlock "
        f"--log.debug "
        f"--rpc.enabledeprecatedpersonal "
        f"--authrpc.port={base_port + 200 + index} "
        f"--port {40500 + index} "
        f"| tee logs/clique_node_{index}.log "
    )
    # tmux 세션에서 Geth 노드 실행
    cmd = f"tmux new-session -d -s geth_node_{index} \"{geth_cmd}\""
    print(cmd)

    subprocess.run(cmd, shell=True)

def main(num_nodes):
    threads = []
    for i in range(1, num_nodes + 1):
        thread = threading.Thread(target=run_geth_node, args=(i,))
        threads.append(thread)
        thread.start()
        print("씨발 인덱스", i)

    # 모든 스레드가 완료될 때까지 기다림
    for thread in threads:
        thread.join()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run multiple Geth nodes in tmux sessions.")
    parser.add_argument("--num_nodes", type=int, required=True, help="Number of Geth nodes to run")

    args = parser.parse_args()
    
    log_dir = "./logs"
    if os.path.exists(log_dir):
        shutil.rmtree(log_dir)    
    os.makedirs(log_dir)
    
    main(args.num_nodes)
