// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
contract L_Bank{

    function deposit (uint64 before,uint64 num) public pure returns (uint64){
        return num+before;
    }

    function withdraw (uint64 before,uint64 num) public pure returns (uint64,uint64){
        if (before > num){
            return (num,before-num);
        }else {
            return (0,before);
        }
    }
    

}