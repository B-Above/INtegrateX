// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
contract L_Hotel{
    function book (uint64 before,uint64 num,uint64 rooms) public pure returns (uint64,uint64,uint64){
        if (rooms > num){
            return (num,rooms-num,before+num);
        }else {
            return (0,rooms,before);
        }
    }
}
