// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function lockState(bytes[] memory args) public view virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function setname(string memory a) public virtual;
}

contract Blank is StateContract{
    uint64 num;
    address l_blank;
    function setBlank(address a) public {
        l_blank = a;
    }
    function  getState() public view returns (uint64){
        return num;
    }

    function setname(string memory a) public override {
        server = a;
    }

    function  lockState(bytes[] memory args) public override view returns (bytes[] memory){
        bytes[] memory res = new bytes[](3);
        res[0] = abi.encodePacked(uint64(3));
        res[1] = abi.encodePacked(server);
        res[2] = abi.encodePacked(num);
        return res;
    }

    function  updateState(bytes[] memory args) public override{
        uint64 b = bytesToUint64(args[1]);
        num = b;
    }

    function setState(uint64 money)public {
        num = money;
    }

    function add (uint64 a) public returns (uint64){
        num = L_Blank(l_blank).add(num,a);
        return num;
    } 
    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }

    
}

abstract contract L_Blank{
    function add (uint64 before,uint64 num) public pure virtual returns (uint64);
}

