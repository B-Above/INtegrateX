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

contract blank is StateContract{
    uint64 price;
    uint64 temp;
    address _entry;
    string nextname;
    string before;
    function setEntry(address a) public {
        _entry = a;
    }

    function setname(string memory a) public override {
        server = a;
    }

    function setnext(string memory a,string memory b) public{
        nextname = a;
        before = b;
    }

    function setnums(uint64 a) public {
        price = a;
    }

    function  getState() public view returns (uint64){
        return price;
    }

    function  lockState(bytes[] memory args) public override returns (bytes[] memory){
        uint l = args.length;
        uint64 num = bytesToUint64(args[1]);
        if (l == 2){
            endexecute(args);
        }else {
            temp = num;
            lockNext(args);
        }
        // bytes[] memory res = new bytes[](5);
        // res[0] = abi.encodePacked(uint64(1));
        // res[1] = abi.encodePacked(server);
        // res[2] = args[1];
        // res[3] = abi.encodePacked(uint64(account[name]));
        // res[4] = abi.encodePacked(uint64(roomnum));
        return new bytes[](0);
    }

    function lockNext(bytes[] memory args) public returns(bool){
        bool a = false;
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(nextname);
        a = Entry(_entry).lockChainMode(args);
        
        return a;
    }

    function  endexecute(bytes[] memory args) public{
        uint64 r = bytesToUint64(args[1]);
        temp = price + r;
        bytes[] memory res = new bytes[](2);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked(before);
        Entry(_entry).receiveChainMode(res);
    }

    function  updateState(bytes[] memory args) public override{
        temp = price + temp;
        bytes[] memory res = new bytes[](2);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked(before);
        Entry(_entry).receiveChainMode(res);
    }

    function  receiveState(bytes[] memory args) public override{
        price = temp;
    }
    
    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint64 i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }
}


abstract contract Entry{
    function receiveChainMode(bytes[] memory args) public virtual returns (bool);
    function lockChainMode(bytes[] memory args) public virtual returns (bool);
    function updateChainMode(bytes[] memory args) public virtual returns (bool) ;
}