

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function updateState(bytes[] memory args) public virtual;
}

contract blank5 is StateContract {
    uint64 num ;
    address l_blank1;
    address l_blank2;
    address l_blank3;
    address l_blank4;
    address entry;
    mapping(string=>bytes[]) states;
    uint64 temp_adder;
    int n;
    int m;


    function setadder(uint64 a)public{
        temp_adder = a;
    }


    function lockone(uint64 ser1) public returns(bool){
        n = -2;
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
        n += 1;
        if(n == -1){
            uint64 num1 = uint64(bytesToUint64(args[3]));
            num1 = L_blank(l_blank1).add(num1,temp_adder);

            args[0] = abi.encodePacked(uint64(0));
            args[3] = abi.encodePacked(uint64(num1));
            num += temp_adder;
            Entry(entry).updateState(args);
        }else if(n==4){
            if(m == 1){
                ExecuteMulti(temp_adder);
            }else {
                Execute(temp_adder);
            }
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
        uint64 num1 = uint64(bytesToUint64(arg1[3]));
        num1 = L_blank(l_blank1).add(num1,adder);

        arg1[0] = abi.encodePacked(uint64(0));
        arg1[3] = abi.encodePacked(uint64(num1));

        Entry(entry).updateState(arg1);
 
        num += adder;
        return true;
    }

    function set(address _blank1, address _blank2,address _blank3,address _blank4,address _entry,string memory _ts) public {
        l_blank1 = _blank1;
        l_blank2 = _blank2;
        l_blank3 = _blank3;
        l_blank4 = _blank4;
        entry = _entry;
        num = 0;
        temp_adder = 1;
        server = _ts;
        n = 0;
        m = 0;
    }

    function setNum(uint64 a)public{
        num = a;
    }
    function  getState() public view returns (uint64){
        return num;
    }


    function lockAll() public returns(bool){
        n = 0; 
        m = 0;
        bytes[] memory args1 = new bytes[](2);
        args1[0] = abi.encodePacked(uint64(0));
        args1[1] = abi.encodePacked("blank1");
        bytes[] memory args2 = new bytes[](2);
        args2[0] = abi.encodePacked(uint64(0));
        args2[1] = abi.encodePacked("blank2");
        bytes[] memory args3 = new bytes[](2);
        args3[0] = abi.encodePacked(uint64(0));
        args3[1] = abi.encodePacked("blank3");
        bytes[] memory args4 = new bytes[](2);
        args4[0] = abi.encodePacked(uint64(0));
        args4[1] = abi.encodePacked("blank4");

        bool a = Entry(entry).lockState(args1);
        bool b = Entry(entry).lockState(args2);
        bool c = Entry(entry).lockState(args3);
        bool d = Entry(entry).lockState(args4);
        return (a&&b&&c&&d);
    }

        function lockMulit() public returns(bool){
        n = 0;
        m = 1; 
        bytes[] memory args1 = new bytes[](3);
        args1[0] = abi.encodePacked(uint64(0));
        args1[1] = abi.encodePacked("blank1");
        args1[2] = abi.encodePacked("blank3");
        bytes[] memory args2 = new bytes[](3);
        args2[0] = abi.encodePacked(uint64(0));
        args2[1] = abi.encodePacked("blank2");
        args2[2] = abi.encodePacked("blank4");

        bool a = Entry(entry).lockMulti(args1);
        bool b = Entry(entry).lockMulti(args2);
        
        return (a&&b);
    }

    function Execute(uint64 adder) public returns(bool){
        bytes[] memory arg1;
 
        bool a;
        (a,arg1)= Entry(entry).getState("blank1");
        if (!a){
            return false;
        }     
        uint64 num1 = uint64(bytesToUint64(arg1[3]));
        num1 = L_blank(l_blank1).add(num1,adder);
        arg1[0] = abi.encodePacked(uint64(0));
        arg1[3] = abi.encodePacked(uint64(num1));
        Entry(entry).updateState(arg1);

        (a,arg1)= Entry(entry).getState("blank2");
        if (!a){
            return false;
        }     
        num1 = uint64(bytesToUint64(arg1[3]));
        num1 = L_blank(l_blank2).add(num1,adder);
        arg1[0] = abi.encodePacked(uint64(0));
        arg1[3] = abi.encodePacked(uint64(num1));
        Entry(entry).updateState(arg1);

        (a,arg1)= Entry(entry).getState("blank3");
        if (!a){
            return false;
        }     
        num1 = uint64(bytesToUint64(arg1[3]));
        num1 = L_blank(l_blank3).add(num1,adder);
        arg1[0] = abi.encodePacked(uint64(0));
        arg1[3] = abi.encodePacked(uint64(num1));
        Entry(entry).updateState(arg1);

        (a,arg1)= Entry(entry).getState("blank4");
        if (!a){
            return false;
        }     
        num1 = uint64(bytesToUint64(arg1[3]));
        num1 = L_blank(l_blank4).add(num1,adder);
        arg1[0] = abi.encodePacked(uint64(0));
        arg1[3] = abi.encodePacked(uint64(num1));
        Entry(entry).updateState(arg1);
        
        
        num += adder;
        return true;
    }

    function ExecuteMulti(uint64 adder) public returns(bool){
        bytes[] memory arg1;
        bytes[] memory res = new bytes[](9);
        bytes[] memory res2 = new bytes[](9);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked(uint64(3));
        res2[0] = abi.encodePacked(uint64(0));
        res2[1] = abi.encodePacked(uint64(3));

 
        bool a;
        (a,arg1)= Entry(entry).getState("blank1");
        if (!a){
            return false;
        }     
        uint64 num1 = uint64(bytesToUint64(arg1[3]));
        num1 = L_blank(l_blank1).add(num1,adder);
        res[2] = arg1[1];
        res[3] = arg1[2];
        res[4] = abi.encodePacked(uint64(num1));
        Entry(entry).updateState(arg1);

        (a,arg1)= Entry(entry).getState("blank2");
        if (!a){
            return false;
        }     
        uint64 num2 = uint64(bytesToUint64(arg1[3]));
        num2 = L_blank(l_blank2).add(num2,adder);
        res2[2] = arg1[1];
        res2[3] = arg1[2];
        res2[4] = abi.encodePacked(uint64(num2));

        (a,arg1)= Entry(entry).getState("blank3");
        if (!a){
            return false;
        }     
        res[5] = abi.encodePacked(uint64(3));
        num1 = uint64(bytesToUint64(arg1[3]));
        num1 = L_blank(l_blank3).add(num1,adder);
        res[6] = arg1[1];
        res[7] = arg1[2];
        res[8] = abi.encodePacked(uint64(num1));
        Entry(entry).updateMulti(res);

        

        (a,arg1)= Entry(entry).getState("blank4");
        if (!a){
            return false;
        }     
        res2[5] = abi.encodePacked(uint64(3));
        num2 = uint64(bytesToUint64(arg1[3]));
        num2 = L_blank(l_blank3).add(num2,adder);
        res2[6] = arg1[1];
        res2[7] = arg1[2];
        res2[8] = abi.encodePacked(uint64(num2));
        Entry(entry).updateMulti(res2);
        
        
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
    function lockMulti(bytes[] memory args) public virtual returns (bool);
    function updateMulti(bytes[] memory sers) public virtual returns (bool);
    function checkSeriver(string memory destChainServiceID, string memory name1, string memory name2) public virtual;
    function lockState(bytes[] memory args) public virtual returns (bool);
    function getState(string memory ser)public view virtual returns (bool,bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function updateAll(bytes[] memory args)public virtual;
    
}