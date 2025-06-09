// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function updateState(bytes[] memory args) public virtual;
}

contract fgl is StateContract {
    uint64 num ;
    address l_fgl;
    address entry;
    mapping(string=>bytes[]) states;
    uint64 temp_adder;
    uint64 n ;



    function set(address _fgl,address _entry,string memory _ts) public {
        l_fgl = _fgl;
        entry = _entry;
        num = 0;
        temp_adder = 1;
        server = _ts;
        n = 0;
    }
    function setadder(uint64 a)public{
        temp_adder = a;
    }
    function setNum(uint64 a)public{
        num = a;
    }
    function  getState() public view returns (uint64){
        return num;
    }


   
    function lock(uint64 ser1) public returns(bool){
        n = ser1;
        bytes[] memory args = new bytes[](3);
        args[0] = abi.encodePacked(uint64(0));
        
        args[1] = abi.encodePacked("fgl");
        args[2] = abi.encodePacked(ser1);
            
        bool a = Entry(entry).lockState(args);
        return a;
    }


    function Execute(uint64 adder) public returns(bool){
        bytes[] memory arg1;

        bool a;

        (a,arg1)= Entry(entry).getState("fgl");

        if (!a){
            return false;
        }     
        uint64 num1 = uint64(bytesToUint64(arg1[3]));

        num1 = L_fgl(l_fgl).minus(num1,n*adder);


        arg1[0] = abi.encodePacked(uint64(0));

        arg1[3] = abi.encodePacked(uint64(num1));

        Entry(entry).updateState(arg1);

        num += n*adder;
        return true;
    }

    function  updateState(bytes[] memory args) public override{
        
        Execute(temp_adder);
        
    }


    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint64 i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }
}

abstract contract L_fgl{
    function add (uint64 before,uint64 num) public pure virtual returns (uint64);
    function minus (uint64 before,uint64 num) public pure virtual returns (uint64);
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