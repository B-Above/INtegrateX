// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function updateState(bytes[] memory args) public virtual;
}

contract flg_main is StateContract {
    address l_trans1;
    address l_trans2;
    address entry;
    mapping(string=>uint64) accounts;
    mapping(uint=>bytes[]) ids;
    mapping(uint=>bytes[]) states;
    uint64 id;
    uint64 temp_addear;
    int n ;



    function set(address _trans1, address _trans2,address _entry,string memory _ts) public {
        l_trans1 = _trans1;
        l_trans2 = _trans2;
        entry = _entry;
        server = _ts;
        n = 0;
        id = 0;
    }
    function  getState(string memory name) public view returns (uint64){
        return accounts[name];
    }


    function lockAll(string memory n1,string memory n2,uint64 num) public returns(bool){
        n = 0;
        bytes[] memory args1 = new bytes[](5);
        args1[0] = abi.encodePacked(uint64(0));
        args1[1] = abi.encodePacked("trans1");
        args1[2] = abi.encodePacked(id);
        args1[3] = abi.encodePacked(n1);
        args1[4] = abi.encodePacked(n2);
        bool a = Entry(entry).lockState(args1);
        args1[0] = abi.encodePacked(num);
        ids[id] = args1;
        id += 1;
        bytes[] memory args2 = new bytes[](5);
        args2[0] = abi.encodePacked(uint64(0));
        args2[1] = abi.encodePacked("trans2");
        args2[2] = abi.encodePacked(id);
        args2[3] = abi.encodePacked(n1);
        args2[4] = abi.encodePacked(n2);
        bool b = Entry(entry).lockState(args2);
        args2[0] = abi.encodePacked(num);
        ids[id] = args2;
        id += 1;
        return (a&&b);
    }

    function lockone(uint64 ser1,string memory n1,string memory n2,uint64 num) public returns(bool){
        n = -2;
        bytes[] memory args = new bytes[](5);
        args[0] = abi.encodePacked(uint64(0));
        if (ser1 == 1){
            args[1] = abi.encodePacked("trans1");
        }else {
            args[1] = abi.encodePacked("trans2");
        }       
        args[2] = abi.encodePacked(id);
        args[3] = abi.encodePacked(n1);
        args[4] = abi.encodePacked(n2);
        bool a = Entry(entry).lockState(args);
        args[0] = abi.encodePacked(num);
        ids[id] = args;
        id += 1;
        return a;
    }

    function Execute(uint64 adder) public returns(bool){
        bytes[] memory arg1;
        
       

        bool a;
    

        (a,arg1)= Entry(entry).getState("trans1");
    

        if (!a){
            return false;
        }     
        uint64 id1= uint64(bytesToUint64(arg1[3]));
        

        uint64 s1 = uint64(bytesToUint64(arg1[4]));
        uint64 r1 = uint64(bytesToUint64(arg1[5]));
        

    
        (s1,r1) = flg_logic(l_trans1).transfer(s1,r1,adder);
        


        arg1[0] = abi.encodePacked(uint64(0));
        
        

        arg1[4] = abi.encodePacked(uint64(s1));
        

        arg1[6] = abi.encodePacked(uint64(r1));
        

        Entry(entry).updateState(arg1);
       

        return true;
    }
    function  updateState(bytes[] memory args) public override{
        n += 1;
        uint64 id = uint64(bytesToUint64(args[3]));
        states[id] = args;
        if(n==-1){
            uint64 s1 = uint64(bytesToUint64(args[4]));
            uint64 r1 = uint64(bytesToUint64(args[5]));
            (s1,r1) = flg_logic(l_trans1).transfer(s1,r1,adder);

            args[0] = abi.encodePacked(uint64(0));
            args[3] = abi.encodePacked(uint64(num1));
            num += temp_adder;
            Entry(entry).updateState(args);
        }else if(n==2){
            Execute(temp_adder);
        }
        

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


    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint64 i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }
}

abstract contract flg_logic{
     function transfer (uint64 sender,uint64 receiver,uint64 num) public virtual returns (uint64,uint64);
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