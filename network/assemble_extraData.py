#!/usr/bin/env python3
import os
import json
import argparse

def assemble_extra_data(signer_count):
    # signer 주소를 추가하는 부분
    signer_addresses = []
    for i in range(1, signer_count + 1): # 입력된 signer 수만큼 반복
        path = f"signers/signer{i}/keystore/"
        if not os.path.exists(path):
            print(f"Error: Path {path} does not exist.")
            return

        found_address = False
    
        for filename in os.listdir(path):
            if filename.startswith("UTC--2023"):
                file_path = os.path.join(path, filename)
                if not os.path.exists(file_path):
                    print(f"Error: File {file_path} does not exist.")
                    continue
                address = ""
                with open(file_path, 'r') as file:
                    keystore_data = json.load(file)
                    # keystore JSON 파일 내의 address 키에서 주소 가져오기
                    address = keystore_data['address']
                    signer_addresses.append(address)
                    found_address = True
                    # break
                
                secret_path = os.path.join(path, "address")
                with open(secret_path, 'w') as file:
                    file.write(address)
                    
                # Update genesis.json in each signer directory
                single_extra = generate_extra_data(address)
                update_genesis_extra_data(f"signers/signer{i}/genesis.json", address, single_extra)

        if not found_address:
            print(f"Error: No valid keystore file found in {path}.")

    # Update genesis.json in a whole directory
    extra_data = generate_extra_data(signer_addresses)
    return signer_addresses, extra_data

def generate_extra_data(signers):
    prefix = "0x" + "0" * 64  # 32바이트 접두사
    suffix = "0" * 130  # 32바이트 접미사 + 65바이트 봉인자 서명

    # 서명자 주소를 연결
    signers_data = ''.join(signers)

    return prefix + signers_data + suffix

# common genesis.json
def update_genesis_extra_data(genesis_path, signer_addresses, extra_data):
    with open(genesis_path, 'r') as file:
        genesis_data = json.load(file)

    # extraData 필드 업데이트
    genesis_data['extradata'] = extra_data

    if isinstance(signer_addresses, str):
        genesis_data["alloc"] = {}
        genesis_data["alloc"][signer_addresses] = {"balance": "9999999999999999999"}
    else:
        genesis_data["alloc"] = {}
        for address in signer_addresses:
            genesis_data["alloc"][address] = {"balance": "9999999999999999999"}

    with open(genesis_path, 'w') as file:
        json.dump(genesis_data, file, indent=4)


# argparse를 사용하여 커맨드 라인 인자 처리
parser = argparse.ArgumentParser(description='Assemble extraData field for Ethereum PoA Clique network.')
parser.add_argument('signer_count', type=int, help='Number of signers in the network.')

args = parser.parse_args()
signer_count = args.signer_count

signer_addresses, extra_data_field = assemble_extra_data(signer_count)

if extra_data_field:
    print(extra_data_field)

update_genesis_extra_data("./genesis.json", signer_addresses, extra_data_field)
