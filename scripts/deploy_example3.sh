#!/usr/bin/env bash

source x.sh

MODE=deploy
ETH_ADDR1=http://localhost:8545 
ETH_ADDR2=http://localhost:8547 
ETH_ADDR3=http://localhost:8549


CURRENT_PATH=$(pwd)
ACCOUNT_PATH="${CURRENT_PATH}/docker/quick_start"
CONTRACT_PATH="${CURRENT_PATH}/example"

function deploy_contracts() {

   print_blue "Deploy Blank3 in ethereum1"
   goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/blank4.sol >"$CONTRACT_PATH/blank3Addr"
   Blank3add=$(grep Deployed <"$CONTRACT_PATH/blank3Addr" | grep -o '0x.\{40\}')
   print_green "Blank3 contract address: $Blank3add"


   print_blue "Deploy L_blank contract"
   goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/L_blank.sol >"$CONTRACT_PATH/l1Addr"
   l1_address=$(grep Deployed <"$CONTRACT_PATH/l1Addr" | grep -o '0x.\{40\}')
   print_green "L_blank1 contract address: $l1_address"

   print_blue "Deploy L_blank contract"
   goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/L_blank.sol >"$CONTRACT_PATH/l2Addr"
   l2_address=$(grep Deployed <"$CONTRACT_PATH/l2Addr" | grep -o '0x.\{40\}')
   print_green "L_blank2 contract address: $l2_address"

   print_blue "Deploy L_blank contract"
   goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/L_blank.sol >"$CONTRACT_PATH/l3Addr"
   l3_address=$(grep Deployed <"$CONTRACT_PATH/l3Addr" | grep -o '0x.\{40\}')
   print_green "L_blank3 contract address: $l3_address"

   print_blue "Deploy blank_chain deep3 contract"
   goduck ether contract deploy --address $ETH_ADDR1 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/blank4_chain.sol >"$CONTRACT_PATH/bcaddr"
   bc_address=$(grep Deployed <"$CONTRACT_PATH/bcaddr" | grep -o '0x.\{40\}')
   print_green "blank1_chain contract address: $bc_address"

#    print_blue "aduit contract"
#    goduck ether contract invoke --key-path "$ACCOUNT_PATH"/account.key --abi-path "$CONTRACT_PATH"/broker_data.abi --address $ETH_ADDR1 $broker_data_address audit "$broker_address^1"
#    print_green "aduit contract aduit:successful"


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
   print_blue "Deploy S_blank contract"
   goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/S_blank.sol >"$CONTRACT_PATH/S11Addr"
   S11=$(grep Deployed <"$CONTRACT_PATH/S11Addr" | grep -o '0x.\{40\}')
   print_green "S_blank2 contract address: $S11"

   print_blue "Deploy S_blank contract"
   goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/S_blank.sol >"$CONTRACT_PATH/S12Addr"
   S12=$(grep Deployed <"$CONTRACT_PATH/S12Addr" | grep -o '0x.\{40\}')
   print_green "S_blank4 contract address: $S12"

   print_blue "Deploy blank_chain contract"
   goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/blank_chain.sol >"$CONTRACT_PATH/bc2addr"
   bc2_address=$(grep Deployed <"$CONTRACT_PATH/bc2addr" | grep -o '0x.\{40\}')
   print_green "blank2_chain contract address: $bc2_address"

   print_blue "Deploy blank_chain contract"
   goduck ether contract deploy --address $ETH_ADDR2 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/blank_chain.sol >"$CONTRACT_PATH/bc4addr"
   bc4_address=$(grep Deployed <"$CONTRACT_PATH/bc4addr" | grep -o '0x.\{40\}')
   print_green "blank4_chain contract address: $bc4_address"


   print_blue "Deploy Contract in ethereum3"
   print_blue "Deploy broker_data contract"
   goduck ether contract deploy --address $ETH_ADDR3 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/S_blank.sol >"$CONTRACT_PATH/S2Addr"
   S2=$(grep Deployed <"$CONTRACT_PATH/S2Addr" | grep -o '0x.\{40\}')
   print_green "broker_data3 contract address: $S2"

   print_blue "Deploy blank_chain contract"
   goduck ether contract deploy --address $ETH_ADDR3 --key-path "$ACCOUNT_PATH"/account.key  --code-path "$CONTRACT_PATH"/blank_chain.sol >"$CONTRACT_PATH/bc3addr"
   bc3_address=$(grep Deployed <"$CONTRACT_PATH/bc3addr" | grep -o '0x.\{40\}')
   print_green "blank3_chain contract address: $bc3_address"

}


if [ "$MODE" == "deploy" ]; then
  deploy_contracts
else
  exit 1
fi