// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
contract flg_logic{
    function transfer (uint64 sender,uint64 receiver,uint64 num) public pure returns (uint64,uint64){
        return (sender-num,receiver+num);
    }
}
