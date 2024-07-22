CONTAINER_NAME1="ethereum-1"
CONTAINER_NAME2="ethereum-2"
CONTAINER_NAME3="ethereum-3"

docker exec $CONTAINER_NAME1 sh -c "geth attach http://localhost:8545 --exec 'eth.sendTransaction({from: \"0x20F7Fac801C5Fc3f7E20cFbADaA1CDb33d818Fa3\", to: \"0x3846AC9B6BE8698141816A5AD3836B756987D869\", value: web3.toWei(10000, \"ether\")})'"
docker exec $CONTAINER_NAME2 sh -c "geth attach http://localhost:8545 --exec 'eth.sendTransaction({from: \"0x20F7Fac801C5Fc3f7E20cFbADaA1CDb33d818Fa3\", to: \"0x3846AC9B6BE8698141816A5AD3836B756987D869\", value: web3.toWei(10000, \"ether\")})'"
docker exec $CONTAINER_NAME3 sh -c "geth attach http://localhost:8545 --exec 'eth.sendTransaction({from: \"0x20F7Fac801C5Fc3f7E20cFbADaA1CDb33d818Fa3\", to: \"0x3846AC9B6BE8698141816A5AD3836B756987D869\", value: web3.toWei(10000, \"ether\")})'"