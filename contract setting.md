## contract setting

[TOC]



### deeptest

#### deep2:

```json
Deploy broker_data contract
broker_data1 contract address: 0xD3880ea40670eD51C3e3C0ea089fDbDc9e3FBBb4
Deploy broker contract
broker1 contract address: 0x668a209Dc6562707469374B8235e37b8eC25db08
Entry contract address: 0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9

Deploy Blank3 in ethereum1
Blank3 contract address: 0x857133c5C69e6Ce66F7AD46F200B9B3573e77582
Deploy L_blank contract
L_blank1 contract address: 0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11
Deploy L_blank contract
L_blank2 contract address: 0xe95C4c9D9DFeAdC8aD80F87de3F36476DcDdE9F4
Deploy blank3_chain contract
blank1_chain contract address: 0xb00AC45963879cb9118d13120513585873f81Cdb

Deploy Contract in ethereum2
Deploy S_blank contract
broker_data2 contract address: 0x857133c5C69e6Ce66F7AD46F200B9B3573e77582
Deploy blank_chain contract
blank2_chain contract address: 0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11

Deploy Contract in ethereum3
Deploy broker_data contract
broker_data3 contract address: 0x857133c5C69e6Ce66F7AD46F200B9B3573e77582
Deploy blank_chain contract
blank3_chain contract address: 0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11
```



INtergrateX:

bc1: Entry.sol blank3.sol L_blank.sol L_blank.sol

bc2: Entry.sol S_blank.sol

bc3: Entry.sol S_blank.sol

`setup`: 

bc1:

```
blank3:
set "0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11", "0xe95C4c9D9DFeAdC8aD80F87de3F36476DcDdE9F4","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","blank0"
Entry.sol
regServer "blank1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9" 
regServer "blank2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain3:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "blank0","0x857133c5C69e6Ce66F7AD46F200B9B3573e77582"
```

bc2:

```
Entry:
regServer "blank1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain1:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "blank1","0x857133c5C69e6Ce66F7AD46F200B9B3573e77582"
S_blank:
setnain "blank1","blank0"
```

bc3:

```
Entry:
regServer "blank2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain1:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "blank2","0x857133c5C69e6Ce66F7AD46F200B9B3573e77582"
S_blank:
setname "blank2","blank0"
```



Chain_mode:

bc1: Entry.sol blank3_chain.sol 

```
Entry:
regServer "bc1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer "bc2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain3:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "bc0","0xb00AC45963879cb9118d13120513585873f81Cdb"
blank3:
setup "bc0","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9" 
```

bc2: Entry.sol blank_chain.sol

```
Entry:
regServer "bc0","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain1:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer "bc2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain3:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "bc1","0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11"
blank:
setup "bc1","bc2","bc0","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
```

bc3: Entry.sol blank_chain.sol

```SOLIDITY
Entry:
regServer "bc0","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain1:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer "bc1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "bc2","0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11"
blank:
setup "bc2","bc2","bc1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
```

#### deep 3:

```json
Deploy broker_data contract
broker_data1 contract address: 0xD3880ea40670eD51C3e3C0ea089fDbDc9e3FBBb4
Deploy broker contract
broker1 contract address: 0x668a209Dc6562707469374B8235e37b8eC25db08
Entry contract address: 0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9

Deploy Blank3 in ethereum1
Blank3 contract address: 0x857133c5C69e6Ce66F7AD46F200B9B3573e77582
Deploy L_blank contract
L_blank1 contract address: 0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11
Deploy L_blank contract
L_blank2 contract address: 0xe95C4c9D9DFeAdC8aD80F87de3F36476DcDdE9F4
Deploy L_blank contract
L_blank3 contract address: 0xb00AC45963879cb9118d13120513585873f81Cdb
Deploy blank_chain deep3 contract
blank1_chain contract address: 0xd590f0c82d1DAfeabEf43D4c793C1Ac1A4e070B2

Deploy Contract in ethereum2
Deploy S_blank contract
S_blank2 contract address: 0x857133c5C69e6Ce66F7AD46F200B9B3573e77582
Deploy S_blank contract
S_blank4 contract address: 0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11
Deploy blank_chain contract
blank2_chain contract address: 0xe95C4c9D9DFeAdC8aD80F87de3F36476DcDdE9F4
Deploy blank_chain contract
blank4_chain contract address: 0xb00AC45963879cb9118d13120513585873f81Cdb

Deploy Contract in ethereum3
Deploy broker_data contract
broker_data3 contract address: 0x857133c5C69e6Ce66F7AD46F200B9B3573e77582
Deploy blank_chain contract
blank3_chain contract address: 0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11
```

INtergrateX:

bc1: Entry.sol blank4.sol L_blank.sol L_blank.sol L_blank.sol

bc2: Entry.sol S_blank.sol S_blank.sol

bc3: Entry.sol S_blank.sol

`setup`:

bc1:

```solidity
blank4:
set "0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11", "0xe95C4c9D9DFeAdC8aD80F87de3F36476DcDdE9F4","0xb00AC45963879cb9118d13120513585873f81Cdb","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","blank0"
Entry.sol
regServer "blank1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9" 
regServer "blank2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain3:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer 
"blank3","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "blank0","0x857133c5C69e6Ce66F7AD46F200B9B3573e77582"
```

bc2:

```solidity
Entry:
regServer "blank1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain1:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "blank1","0x857133c5C69e6Ce66F7AD46F200B9B3573e77582"
regState "blank3","0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11"
S_blank:
setnain "blank1","blank0"
S_blank:
setnain "blank3","blank0"
```

bc3:

```solidity
Entry:
regServer "blank2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain1:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "blank2","0x857133c5C69e6Ce66F7AD46F200B9B3573e77582"
S_blank:
setname "blank2","blank0"
```

Chain mode

bc1: Entry.sol blank4_chain.sol 

```solidity
Entry:
regServer "bc1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer "bc2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain3:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer "bc3","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "bc0","0xb00AC45963879cb9118d13120513585873f81Cdb"
blank3:
setup "bc0","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9" 
```

bc2: Entry.sol blank_chain.sol blank_chain.sol

```solidity
Entry:
regServer "bc0","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain1:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer "bc2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain3:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "bc1","0xe95C4c9D9DFeAdC8aD80F87de3F36476DcDdE9F4"
regState "bc3","0xb00AC45963879cb9118d13120513585873f81Cdb"
blank1:
setup "bc1","bc2","bc0","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
blank3:
setup "bc3","bc3","bc2","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"

```



bc3: Entry.sol blank_chain.sol

```solidity
Entry:
regServer "bc0","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain1:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer "bc1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regServer "bc3","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9","1356:ethappchain2:0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
regState "bc2","0x30c5D3aeb4681af4D13384DBc2a717C51cb1cc11"
blank:
setup "bc2","bc3","bc1","0x48c60e86ccb66067F923F3F05ef602Ae2F28cbf9"
```

