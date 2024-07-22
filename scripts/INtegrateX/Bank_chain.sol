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

contract Bank is StateContract{
    mapping (string => uint64) account;
    address entry;
    string temp_name;
    uint64 temp_num;
    function setEntry(address a) public {
        entry = a;
    }
    function  getState(string memory name) public view returns (uint){
        return (account[name]);
    }

    function setname(string memory a) public override {
        server = a;
    }

    function  lockState(bytes[] memory args) public override returns (bytes[] memory){
        bytes[] memory res = new bytes[](3);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked("hotel");
        string memory name = string(args[1]);
        uint64 num = bytesToUint64(args[2]);
        uint64 a;
        uint64 b;
        (a,b) = withdraw(account[name], num);
        if (a == 0){
            res[2] = abi.encodePacked(uint64(1));
            return new bytes[](0);
        }
        res[2] = abi.encodePacked(uint64(0));
        temp_name = name;
        temp_num = b;
        Entry(entry).receiveChainMode(res);
        return res;
    }

    function  updateState(bytes[] memory args) public override{
        string memory name = string(args[1]);
        uint64 b = bytesToUint64(args[2]);
        account[name] = b;
    }

    function setState(string memory name, uint64 money)public {
        account[name] = money;
    }

    function pay (string memory name,uint64 num) public returns (uint64){
        uint64 a;
        uint64 b;
        (a,b) = withdraw(account[name],num);
        account[name] = b;
        return a;
    } 
    function deposit(string memory name, uint64 num) public returns(uint64){
        uint64 a = deposit(account[name], num);
        account[name] = a;
        return a;
    }

    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }

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

    function  receiveState(bytes[] memory args) public override{
        account[temp_name] = temp_num;
    }
}

abstract contract Entry{
    function receiveChainMode(bytes[] memory args) public virtual returns (bool);
    function lockChainMode(bytes[] memory args) public virtual returns (bool);
}