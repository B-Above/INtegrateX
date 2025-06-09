// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function lockState(bytes[] memory args) public virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function setname(string memory a) public virtual;
}

contract S_fgl is StateContract{
    string main_ser;
    uint64 num;
    address l_fgl;
    uint64 ls;
    function setfgl(address a) public {
        l_fgl = a;
    }
    function  getState() public view returns (uint64){
        return num;
    }

    function setname(string memory a) public override {
        server = a;
    }

    function setmain(string memory a, string memory b, uint64 lock_size, uint64 n) public {
        server = a;
        main_ser = b;
        ls = lock_size;
        num = n;
    }

    function  lockState(bytes[] memory args) public override returns (bytes[] memory){
        uint64 k =  bytesToUint64(args[1]);
        uint64 lo = k*ls;
        num -= lo;
        bytes[] memory res = new bytes[](4);
        res[0] = abi.encodePacked(uint64(4));
        res[1] = abi.encodePacked(server);
        res[2] = abi.encodePacked(main_ser);
        res[3] = abi.encodePacked(k*ls);
        return res;
    }

    function  updateState(bytes[] memory args) public override{
        
        uint64 b = bytesToUint64(args[2]);
        num += b;
    }

    function setState(uint64 money)public {
        num = money;
    }

    function add (uint64 a) public returns (uint64){
        num = L_fgl(l_fgl).add(num,a);
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

abstract contract L_fgl{
    function add (uint64 before,uint64 num) public pure virtual returns (uint64);
    function minus (uint64 before,uint64 num) public pure virtual returns (uint64);
}
