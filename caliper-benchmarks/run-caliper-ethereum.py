#!/bin/env python3
import subprocess
import threading
import argparse
import os
import json
import signal
import shutil
import time

caliper_template = """
{
    "caliper": {
        "blockchain": "ethereum",
        "command" : {
            "start": "",
            "end" : ""
          }
    },
    "ethereum": {
        "url": "ws://0.0.0.0:8001",
        "contractDeployerAddress": "0x06e79e186441d5189b9cb2460c6ff727a06b2105",
        "contractDeployerAddressPassword": "",
        "fromAddress": "0x06e79e186441d5189b9cb2460c6ff727a06b2105",
        "fromAddressPassword": "",
        "transactionConfirmationBlocks": 2,
        "contracts": {
            "simple": {
                "path": "./src/ethereum/simple/simple.json",
                "estimateGas": true,
                "gas": {
                    "query": 100000,
                    "transfer": 70000
                }
            }
        }
    }
}
"""

def update_caliper_config(index):
    config = "/home/jyr/go/src/github.com/rupc/eth-poa-devnet/signers"
    portStart = 8000
    for i in range (1, index+1):
        file_path = os.path.join(config, "signer{}".format(i), "keystore", "address")
        address = ""
        jsondata = {}
        with open(file_path, 'r') as file:
            address = file.read()
            jsondata = json.loads(caliper_template)
            jsondata["ethereum"]["url"] = "ws://0.0.0.0:" + str(portStart + i - 1)
            jsondata["ethereum"]["contractDeployerAddress"] = address
            jsondata["ethereum"]["fromAddress"] = address
            
        with open("./networkconfig{}.json".format(i), 'w') as file:
            json.dump(jsondata, file, indent=4)

def signal_handler(sig, frame):
    print("Ctrl+C가 감지되었습니다. 모든 tmux 세션을 종료합니다.")
    for i in range(1, number_of_nodes + 1):
        subprocess.run(f"tmux kill-session -t session_{i}", shell=True)
    os._exit(0)
    
def run_command(index):

    
    cmd = (
        f"tmux new-session -d -s session_{index} 'caliper launch manager "
        f"--caliper-bind-sut ethereum "
        f"--caliper-bind-sdk 1.11.7 "
        f"--caliper-benchconfig ./benchmarks/scenario/simple/config.yaml "
        f"--caliper-networkconfig ./networkconfig{index}.json "
        f"| tee logs/caliper_{index}.log'"
    )
    print(cmd)
    subprocess.run(cmd, shell=True)
    
def kill():
    return 'tmux kill-server'

def main(number_of_nodes):
    update_caliper_config(number_of_nodes)
    log_dir = "./logs"
    if os.path.exists(log_dir):
        shutil.rmtree(log_dir)    
    os.makedirs(log_dir)
    # # 각 인덱스에 대해 별도의 스레드에서 커맨드 실행
    threads = []
    for i in range(1, number_of_nodes+1):
        thread = threading.Thread(target=run_command, args=(i,))
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()
        
    time.sleep(60)
    kill()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run commands in parallel tmux sessions.")
    parser.add_argument("number_of_nodes", type=int, help="Number of nodes (and thus the maximum index)")
    args = parser.parse_args()

    signal.signal(signal.SIGINT, signal_handler)
    number_of_nodes = args.number_of_nodes  # 전역 변수로 사용

    main(args.number_of_nodes)
    
