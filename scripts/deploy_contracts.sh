#!/usr/bin/env bash

source x.sh

MODE=$1
ETH_ADDR1=$2
ETH_ADDR2=$3
ETH_ADDR3=$4


CURRENT_PATH=$(pwd)
ACCOUNT_PATH="${CURRENT_PATH}/docker/quick_start"
CONTRACT_PATH="${CURRENT_PATH}/example"

function deploy_contracts() {

   print_blue "Deploy Contract in ethereum1"
   print_blue "Deploy broker_data contract"
   goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/broker_data.sol "["0x20f7fac801c5fc3f7e20cfbadaa1cdb33d818fa3"]^1" >"$CONTRACT_PATH/brokerDataAddr"
   broker_data_address=$(grep Deployed <"$CONTRACT_PATH/brokerDataAddr" | grep -o '0x.\{40\}')
   print_green "broker_data1 contract address: $broker_data_address"


   print_blue "Deploy broker contract"
   goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/broker.sol "1356^ethappchain1^["0xc7F999b83Af6DF9e67d0a37Ee7e900bF38b3D013","0x79a1215469FaB6f9c63c1816b45183AD3624bE34","0x97c8B516D19edBf575D72a172Af7F418BE498C37","0xc0Ff2e0b3189132D815b8eb325bE17285AC898f8"]^1^["0x20f7fac801c5fc3f7e20cfbadaa1cdb33d818fa3"]^1^$broker_data_address" >"$CONTRACT_PATH/brokerAddr"
   broker_address=$(grep Deployed <"$CONTRACT_PATH/brokerAddr" | grep -o '0x.\{40\}')
   print_green "broker1 contract address: $broker_address"

   print_blue "aduit contract"
   goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker_data.abi --address $ETH_ADDR1 $broker_data_address audit "$broker_address^1"
   print_green "aduit contract aduit:successful"

   print_blue "Deploy Entry contract"
   goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/Entry.sol "$broker_address^true" >"$CONTRACT_PATH/EntryAddr"
   entryAddr=$(grep Deployed <"$CONTRACT_PATH/EntryAddr" | grep -o '0x.\{40\}')
   print_green "Entry contract address: $entryAddr"

   print_blue "aduit contract"
   goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker.abi --address $ETH_ADDR1 $broker_address audit "$entryAddr^1"
   print_green "aduit contract aduit:successful"

  # print_blue "Deploy transfer contract"
  # goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/transfer.sol "$broker_address^true" >"$CONTRACT_PATH/transferAddr"
  # transfer_address=$(grep Deployed <"$CONTRACT_PATH/transferAddr" | grep -o '0x.\{40\}')
  # print_green "transfer1 contract address: $transfer_address"

  # print_blue "aduit contract"
  # goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker.abi --address $ETH_ADDR1 $broker_address audit "$transfer_address^1"
  # print_green "aduit contract aduit:successful"

  # print_blue "Deploy dataswap contract"
  #  goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/data_swapper.sol "$broker_address^true" >"$CONTRACT_PATH/EntryAddr"
  #  entryAddr=$(grep Deployed <"$CONTRACT_PATH/EntryAddr" | grep -o '0x.\{40\}')
  #  print_green "dataswap contract address: $entryAddr"

  #  print_blue "aduit contract"
  #  goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker.abi --address $ETH_ADDR1 $broker_address audit "$entryAddr^1"
  #  print_green "aduit contract aduit:successful"


   print_blue "Deploy Contract in ethereum2"
   print_blue "Deploy broker_data contract"
   goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/broker_data.sol "["0x20f7fac801c5fc3f7e20cfbadaa1cdb33d818fa3"]^1" >"$CONTRACT_PATH/brokerDataAddr2"
   broker_data_address2=$(grep Deployed <"$CONTRACT_PATH/brokerDataAddr2" | grep -o '0x.\{40\}')
   print_green "broker_data2 contract address: $broker_data_address2"


   print_blue "Deploy broker contract"
   goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/broker.sol "1356^ethappchain2^["0xc7F999b83Af6DF9e67d0a37Ee7e900bF38b3D013","0x79a1215469FaB6f9c63c1816b45183AD3624bE34","0x97c8B516D19edBf575D72a172Af7F418BE498C37","0xc0Ff2e0b3189132D815b8eb325bE17285AC898f8"]^1^["0x20f7fac801c5fc3f7e20cfbadaa1cdb33d818fa3"]^1^$broker_data_address2" >"$CONTRACT_PATH/brokerAddr2"
   broker_address2=$(grep Deployed <"$CONTRACT_PATH/brokerAddr2" | grep -o '0x.\{40\}')
   print_green "broker2 contract address: $broker_address2"

   print_blue "aduit contract"
   goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker_data.abi --address $ETH_ADDR2 $broker_data_address2 audit "$broker_address2^1"
   print_green "aduit contract aduit:successful"

   print_blue "Deploy Entry contract"
   goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/Entry.sol "$broker_address2^true" >"$CONTRACT_PATH/EntryAddr2"
   entryAddr2=$(grep Deployed <"$CONTRACT_PATH/EntryAddr2" | grep -o '0x.\{40\}')
   print_green "Entry contract address: $entryAddr2"

   print_blue "aduit contract"
   goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker.abi --address $ETH_ADDR2 $broker_address2 audit "$entryAddr2^1"
   print_green "aduit contract aduit:successful"

  # print_blue "Deploy transfer contract"
  # goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/transfer.sol "$broker_address2^true" >"$CONTRACT_PATH/transferAddr2"
  # transfer_address2=$(grep Deployed <"$CONTRACT_PATH/transferAddr2" | grep -o '0x.\{40\}')
  # print_green "transfer2 contract address: $transfer_address2"

  # print_blue "aduit contract"
  # goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker.abi --address $ETH_ADDR2 $broker_address audit "$transfer_address2^1"
  # print_green "aduit contract aduit:successful"

#  print_blue "Deploy dataswap contract"
#    goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/data_swapper.sol "$broker_address2^true" >"$CONTRACT_PATH/EntryAddr2"
#    entryAddr2=$(grep Deployed <"$CONTRACT_PATH/EntryAddr2" | grep -o '0x.\{40\}')
#    print_green "dataswap contract address: $entryAddr2"

#    print_blue "aduit contract"
#    goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker.abi --address $ETH_ADDR2 $broker_address2 audit "$entryAddr2^1"
#    print_green "aduit contract aduit:successful"
   print_blue "Deploy Contract in ethereum3"
   print_blue "Deploy broker_data contract"
   goduck ether contract deploy --address $ETH_ADDR3 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/broker_data.sol "["0x20f7fac801c5fc3f7e20cfbadaa1cdb33d818fa3"]^1" >"$CONTRACT_PATH/brokerDataAddr3"
   broker_data_address3=$(grep Deployed <"$CONTRACT_PATH/brokerDataAddr3" | grep -o '0x.\{40\}')
   print_green "broker_data3 contract address: $broker_data_address3"


   print_blue "Deploy broker contract"
   goduck ether contract deploy --address $ETH_ADDR3 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/broker.sol "1356^ethappchain3^["0xc7F999b83Af6DF9e67d0a37Ee7e900bF38b3D013","0x79a1215469FaB6f9c63c1816b45183AD3624bE34","0x97c8B516D19edBf575D72a172Af7F418BE498C37","0xc0Ff2e0b3189132D815b8eb325bE17285AC898f8"]^1^["0x20f7fac801c5fc3f7e20cfbadaa1cdb33d818fa3"]^1^$broker_data_address3" >"$CONTRACT_PATH/brokerAddr3"
   broker_address3=$(grep Deployed <"$CONTRACT_PATH/brokerAddr3" | grep -o '0x.\{40\}')
   print_green "broker3 contract address: $broker_address3"

   print_blue "aduit contract"
   goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker_data.abi --address $ETH_ADDR3 $broker_data_address3 audit "$broker_address3^1"
   print_green "aduit contract aduit:successful"

   print_blue "Deploy Entry contract"
   goduck ether contract deploy --address $ETH_ADDR3 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/Entry.sol "$broker_address^true" >"$CONTRACT_PATH/EntryAddr3"
   entryAddr3=$(grep Deployed <"$CONTRACT_PATH/EntryAddr3" | grep -o '0x.\{40\}')
   print_green "Entry contract address: $entryAddr3"

   print_blue "aduit contract"
   goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker.abi --address $ETH_ADDR3 $broker_address audit "$entryAddr3^1"
   print_green "aduit contract aduit:successful"
}


if [ "$MODE" == "deploy" ]; then
  deploy_contracts
else
  exit 1
fi