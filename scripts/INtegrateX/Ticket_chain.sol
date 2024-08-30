// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function lockState(bytes[] memory args) public virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function setname(string memory a) public virtual;
}


contract Ticket is StateContract{
    mapping (string => uint64) account;
    uint64 price ;
    address entry;
    string temp_name;
    mapping(string=>bytes[]) states;
    uint64 temp;


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

    function set(uint64 p,address _entry) public {
        entry = _entry;
        price = p;
        temp = 0;
    }

    function setPrice(uint64 a)public{
        price = a;
    }
    function  getState(string memory name) public view returns (uint64){
        return (account[name]);
    }

    function setState(string memory name, uint64 money)public {
        account[name] = money;
    }


    function buyTicket(string memory name, uint64 num) public returns(bool){
        temp = num;
        temp_name = name;
        bytes[] memory args;
        bool a = false;
        args = new bytes[](4);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked("hotel");
        args[2] = abi.encodePacked(name);
        args[3] = abi.encodePacked(num);
        a = Entry(entry).lockChainMode(args);
        
        return a;
    }


    function  updateState(bytes[] memory args) public override{
        uint64 r = bytesToUint64(args[1]);
        bytes[] memory res = new bytes[](3);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked("hotel");
        if (r == 0){
            account[temp_name] -= temp*price;    
        }
        res[2] = abi.encodePacked(uint64(0));
        Entry(entry).updateChainMode(res);
    }

    function updateall()public{
        bytes[] memory res = new bytes[](3);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked("hotel");
        res[2] = abi.encodePacked(uint64(0));
        Entry(entry).updateChainMode(res);
    }
    



    function lookState(string memory name) public view returns(uint64,string memory,string memory,uint64) {
        bytes[] memory res = states[name];
        if (res.length>0){
            return (bytesToUint64(res[0]),string(res[1]),string(res[2]),bytesToUint64(res[3])); 
        }
        return (0,"null","null",0); 
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