// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function lockState(bytes[] memory args) public view virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function setname(string memory a) public virtual;
}

contract Hotel is StateContract{
    uint64 roomnum;
    mapping (string => uint64) account;
    address l_hotel;
    function setHotel(address a) public {
        l_hotel = a;
    }

    function setname(string memory a) public override {
        server = a;
    }

    function setRooms(uint64 a) public {
        roomnum = a;
    }

    function  getState(string memory name) public view returns (uint64, uint64){
        return (account[name],roomnum);
    }

    function  lockState(bytes[] memory args) public override  view returns (bytes[] memory){
        string memory name = string(args[1]);
        bytes[] memory res = new bytes[](5);
        res[0] = abi.encodePacked(uint64(1));
        res[1] = abi.encodePacked(server);
        res[2] = args[1];
        res[3] = abi.encodePacked(uint64(account[name]));
        res[4] = abi.encodePacked(uint64(roomnum));
        return res;
    }


    function  updateState(bytes[] memory args) public override{
        string memory name = string(args[1]);
        uint64 b = bytesToUint64(args[2]);
        uint64 rooms = bytesToUint64(args[3]);
        
        account[name] = b;
        roomnum = rooms;
    }
    

    function setState(string memory name, uint64 rooms, uint64 hasr)public {
        account[name] = hasr;
        roomnum = rooms;
    }

    function books (string memory name,uint64 num) public returns (uint64){
        uint64 a;
        uint64 b;
        uint64 c;
        (a,b,c) = L_Hotel(l_hotel).book(account[name],num,roomnum);
        roomnum = b;
        account[name] = c;
        return a;
    } 

    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint64 i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }
}

abstract contract L_Hotel{
    function book (uint64 before,uint64 num,uint64 rooms) public pure virtual returns (uint64,uint64,uint64);
}