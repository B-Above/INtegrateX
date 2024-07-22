// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function lockState(bytes[] memory args) public view virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function setname(string memory a) public virtual;
}

contract Bank is StateContract{
    mapping (string => uint64) account;
    address l_bank;
    function setBank(address a) public {
        l_bank = a;
    }
    function  getState(string memory name) public view returns (uint){
        return (account[name]);
    }

    function setname(string memory a) public override {
        server = a;
    }

    function  lockState(bytes[] memory args) public override view returns (bytes[] memory){
        string memory name = string(args[1]);
        bytes[] memory res = new bytes[](4);
        res[0] = abi.encodePacked(uint64(1));
        res[1] = abi.encodePacked(server);
        res[2] = args[1];
        res[3] = abi.encodePacked(account[name]);
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
        (a,b) = L_Bank(l_bank).withdraw(account[name],num);
        account[name] = b;
        return a;
    } 
    function deposit(string memory name, uint64 num) public returns(uint64){
        uint64 a = L_Bank(l_bank).deposit(account[name], num);
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
}

abstract contract L_Bank{
    function withdraw (uint64 before,uint64 num) public pure virtual returns (uint64,uint64);
    function deposit (uint64 before,uint64 num) public pure virtual returns (uint64);
}

