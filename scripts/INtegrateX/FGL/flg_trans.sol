// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

abstract contract StateContract {
    string server;
    function lockState(bytes[] memory args) public  virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function setname(string memory a) public virtual;
}

contract flg_trans is StateContract {
    uint64 num ;
    address entry;
    mapping(string=>bytes[]) states;
    mapping(string=>uint64)accounts;
    uint64 l_size;
 

    function setname(string memory a) public override {
        server = a;
    }

    function set(address _entry,string memory _ts,uint64 ls) public {
        entry = _entry;
        num = 0;
        l_size = ls;
        server = _ts;
    }
    function setls(uint64 a)public{
        l_size= a;
    }
    function setNum(uint64 a)public{
        num = a;
    }
    function  getState(string memory name) public view returns (uint64){
        return accounts[name];
    }

    function  setState(string memory name,uint64 a) public{
        accounts[name] = a;
    }


    function lockAll(int tn,string memory name) public returns(bool){
        bytes[] memory args1 = new bytes[](5);
        args1[0] = abi.encodePacked(uint64(0));
        args1[1] = abi.encodePacked("flg");
        args1[2] = abi.encodePacked(name);
        args1[3] = abi.encodePacked(uint64(tn));
        args1[4] = abi.encodePacked(num);
        bool a = Entry(entry).lockState(args1);
        
 
        return (a);
    }

    function  lockState(bytes[] memory args) public override  returns (bytes[] memory){
        uint64 l = bytesToUint64(args[2]);
        bytes[] memory res = new bytes[](4);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = args[0];
        res[2] = args[1];
        string memory name = string(args[1]);
        uint64 temp = bytesToUint64(args[3]);
        uint64 fin = 0;
        for (uint256 i =0; i<l; i++) 
        {
            uint64 k =  temp/l_size;
            if (accounts[name] > l_size*k){
                accounts[name] -= temp;
                fin += temp;
            }
        }
        res[3] = abi.encodePacked(fin);
        Entry(entry).updateState(res);
        return res;
    }


    function  updateState(bytes[] memory args) public override{
        string memory name = string(args[1]);
        uint64 temp = bytesToUint64(args[2]);
        {
            accounts[name] += temp;
        }

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
    function lockMulti(string[] memory sers,uint len) public virtual returns (bool);
    function updateMulti(bytes[] memory sers) public virtual returns (bool);
    function checkSeriver(string memory destChainServiceID, string memory name1, string memory name2) public virtual;
    function lockState(bytes[] memory args) public virtual returns (bool);
    function getState(string memory ser)public view virtual returns (bool,bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function updateAll(bytes[] memory args)public virtual;
    
}