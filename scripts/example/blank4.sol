

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function updateState(bytes[] memory args) public virtual;
}

contract blank4 is StateContract {
    uint64 num ;
    address l_blank1;
    address l_blank2;
    address l_blank3;
    address entry;
    mapping(string=>bytes[]) states;
    uint64 temp_adder;
    bytes[] blank1;
    bytes[] blank2;


    function setadder(uint64 a)public{
        temp_adder = a;
    }


    function lockone(uint64 ser1) public returns(bool){
        
        bytes[] memory args = new bytes[](2);
        args[0] = abi.encodePacked(uint64(0));
        if (ser1 == 1){
            args[1] = abi.encodePacked("blank1");
        }else {
            args[1] = abi.encodePacked("blank2");
        }       
        bool a = Entry(entry).lockState(args);
        return a;
    }

    function  updateState(bytes[] memory args) public override{
        uint64 num1 = uint64(bytesToUint64(args[3]));
        num1 = L_blank(l_blank1).add(num1,temp_adder);

        args[0] = abi.encodePacked(uint64(0));
        args[3] = abi.encodePacked(uint64(num1));
        num += temp_adder;
        Entry(entry).updateState(args);

    }

    function ExecuteOne(uint64 adder,uint64 ser) public returns(bool){
        bytes[] memory arg1;
        temp_adder = adder;

        string memory s = "blank1";
        if (ser != 1){
            s = "blank2";
        }

        bool a;
        
        (a,arg1)= Entry(entry).getState(s);


        if (!a){
            return false;
        }     
        uint64 num1 = uint64(bytesToUint64(arg1[2]));
        num1 = L_blank(l_blank1).add(num1,adder);

        arg1[0] = abi.encodePacked(uint64(0));
        arg1[3] = abi.encodePacked(uint64(num1));

        Entry(entry).updateState(arg1);
 
        num += adder;
        return true;
    }

    function set(address _blank1, address _blank2,address _blank3,address _entry,string memory _ts) public {
        l_blank1 = _blank1;
        l_blank2 = _blank2;
        l_blank3 = _blank3;
        entry = _entry;
        num = 0;
        temp_adder = 0;
        server = _ts;
    }

    function setNum(uint64 a)public{
        num = a;
    }
    function  getState() public view returns (uint64){
        return num;
    }


    function lockAll() public returns(bool){
        bytes[] memory args1 = new bytes[](2);
        args1[0] = abi.encodePacked(uint64(0));
        args1[1] = abi.encodePacked("blank1");
        bytes[] memory args2 = new bytes[](2);
        args2[0] = abi.encodePacked(uint64(0));
        args2[1] = abi.encodePacked("blank2");
        bytes[] memory args3 = new bytes[](2);
        args3[0] = abi.encodePacked(uint64(0));
        args3[1] = abi.encodePacked("blank3");

        bool a = Entry(entry).lockState(args1);
        bool b = Entry(entry).lockState(args2);
        bool c = Entry(entry).lockState(args3);
        return (a&&b&&c);
    }

    function Execute(uint64 adder) public returns(bool){
        bytes[] memory arg1;
        bytes[] memory arg2;
        bytes[] memory arg3;
        bool a;
        bool b;
        bool c;
        (a,arg1)= Entry(entry).getState("blank1");
        (b,arg2)= Entry(entry).getState("blank2");
        (c,arg3)= Entry(entry).getState("blank3");
        if (!a||!b||!c){
            return false;
        }     
        uint64 num1 = uint64(bytesToUint64(arg1[2]));
        uint64 num2 = uint64(bytesToUint64(arg2[2]));
        uint64 num3 = uint64(bytesToUint64(arg3[2]));
    
        num1 = L_blank(l_blank1).add(num1,adder);
        num2 = L_blank(l_blank2).add(num2,adder);
        num3 = L_blank(l_blank3).add(num3,adder);

        arg1[0] = abi.encodePacked(uint64(0));
        arg2[0] = abi.encodePacked(uint64(0));
        arg3[0] = abi.encodePacked(uint64(0));
        arg1[2] = abi.encodePacked(uint64(num1));
        arg2[2] = abi.encodePacked(uint64(num2));
        arg3[2] = abi.encodePacked(uint64(num3));
        Entry(entry).updateState(arg1);
        Entry(entry).updateState(arg2);
        Entry(entry).updateState(arg3);
        num += adder;
        return true;
    }


    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint64 i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }
}


abstract contract L_blank{
    function add (uint64 before,uint64 num) public pure virtual returns (uint64);
}

abstract contract Entry{
    function lockMulti(string[] memory sers,uint len) public virtual returns (bool);
    function updateMulti(bytes[] memory sers) public virtual returns (bool);
    function checkSeriver(string memory destChainServiceID, string memory name1, string memory name2) public virtual;
    function lockState(bytes[] memory args) public virtual returns (bool);
    function getState(string memory ser)public view virtual returns (bool,bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function updateAll(bytes[] memory args)public virtual;
    
}