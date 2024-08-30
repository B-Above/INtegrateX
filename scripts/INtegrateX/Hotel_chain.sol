// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function lockState(bytes[] memory args) public virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function receiveState(bytes[] memory args) public virtual;
    function setname(string memory a) public virtual;
}

contract Hotel is StateContract{
    uint64 roomnum;
    uint64 temp;
    string temp_name;
    uint64[] temp_states;
    mapping (string => uint64) account;
    address _entry;
    function setEntry(address a) public {
        _entry = a;
    }

    function setname(string memory a) public override {
        server = a;
        temp_states = new uint64[](3);
    }

    function setRooms(uint64 a) public {
        roomnum = a;
    }

    function  getState(string memory name) public view returns (uint64, uint64){
        return (account[name],roomnum);
    }

    function  lockState(bytes[] memory args) public override returns (bytes[] memory){
        string memory name = string(args[1]);
        uint64 num = bytesToUint64(args[2]);
        temp = num;
        temp_name = name;
        lockNext(name, num);
        // bytes[] memory res = new bytes[](5);
        // res[0] = abi.encodePacked(uint64(1));
        // res[1] = abi.encodePacked(server);
        // res[2] = args[1];
        // res[3] = abi.encodePacked(uint64(account[name]));
        // res[4] = abi.encodePacked(uint64(roomnum));
        return new bytes[](0);
    }

    function lockNext(string memory name, uint64 num) public returns(bool){
        bytes[] memory args;
        bool a = false;
        args = new bytes[](4);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked("bank");
        args[2] = abi.encodePacked(name);
        args[3] = abi.encodePacked(num);
        a = Entry(_entry).lockChainMode(args);
        
        return a;
    }


    function  updateState(bytes[] memory args) public override{
        bytes[] memory res = new bytes[](3);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked("ticket");
        uint64 r = bytesToUint64(args[1]);
        if (r == 1){
            res[2] = abi.encodePacked(uint64(1));
            Entry(_entry).receiveChainMode(res);
            return;    
        }
        (temp_states[0],temp_states[1],temp_states[2]) = book(account[temp_name],temp,roomnum);
        if (temp_states[0] == 0){
            res[2] = abi.encodePacked(uint64(1));
            Entry(_entry).receiveChainMode(res);
            return;  
        }
        res[2] = abi.encodePacked(uint64(0));
        Entry(_entry).receiveChainMode(res);
    }

    function  receiveState(bytes[] memory args) public override{
        bytes[] memory res = new bytes[](3);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked("train");
        res[2] = args[1];

        roomnum = temp_states[1];
        account[temp_name] = temp_states[2];
        res[2] = abi.encodePacked(uint64(0));
        Entry(_entry).updateChainMode(res);
    }
    

    function setState(string memory name, uint64 rooms, uint64 hasr)public {
        account[name] = hasr;
        roomnum = rooms;
        temp = 0;
    }

    function books (string memory name,uint64 num) public returns (uint64){
        uint64 a;
        uint64 b;
        uint64 c;
        (a,b,c) = book(account[name],num,roomnum);
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

    function book (uint64 before,uint64 num,uint64 rooms) public pure returns (uint64,uint64,uint64){
        if (rooms > num){
            return (num,rooms-num,before+num);
        }else {
            return (0,rooms,before);
        }
    }
}


abstract contract Entry{
    function receiveChainMode(bytes[] memory args) public virtual returns (bool);
    function lockChainMode(bytes[] memory args) public virtual returns (bool);
    function updateChainMode(bytes[] memory args) public virtual returns (bool) ;
}