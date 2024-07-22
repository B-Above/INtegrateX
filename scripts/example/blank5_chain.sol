// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function lockState(bytes[] memory args) public virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function setname(string memory a) public virtual;
}


contract blank4 is StateContract{  
    uint64 price ;
    address entry;
    string temp_name;
    uint64 temp;


    function setup(string memory a, address _entry) public{
        server = a;
        entry = _entry;
    }

    function setname(string memory a) public override {
        server = a;
    }

    function  lockState(bytes[] memory args) public override returns (bytes[] memory){
        string memory name = string(args[1]);
        uint64 num = bytesToUint64(args[2]);
        temp = num;
        temp_name = name;
        return new bytes[](0);
    }

    function set(address _entry) public {
        entry = _entry;
        price = 0;
        temp = 0;
    }

    function setPrice(uint64 a)public{
        price = a;
    }
    function  getState() public view returns (uint64){
        return price;
    }

    function setState(uint64 money)public {
        price = money;
    }


    function Execute(uint64 num) public returns(bool){
        temp = num;
        bytes[] memory args;
        bool a = false;
        args = new bytes[](6);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked("bc1");
        args[2] = abi.encodePacked(num);
        args[3] = abi.encodePacked(num);
        args[4] = abi.encodePacked(num);
        args[5] = abi.encodePacked(num);
        a = Entry(entry).lockChainMode(args);
        
        return a;
    }


    function  updateState(bytes[] memory args) public override{
        bytes[] memory res = new bytes[](4);
        res[0] = abi.encodePacked("bc1");
        res[1] = abi.encodePacked("bc2");
        res[2] = abi.encodePacked("bc3");
        res[3] = abi.encodePacked("bc4");
        price += temp;    
        
        Entry(entry).updateChainMode(res);
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