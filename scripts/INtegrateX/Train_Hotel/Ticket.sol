// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

contract Ticket{
    mapping (string => uint64) account;
    uint64 price ;
    address l_bank;
    address l_hotel;
    address entry;
    string bank_ser;
    string hotel_ser;
    string ser_name;
    mapping(string=>bytes[]) states;


    function set(address _bank, address _hotel,uint64 p,address _entry,string memory _bs,string memory _hs,string memory _ts) public {
        l_bank = _bank;
        l_hotel = _hotel;
        entry = _entry;
        price = p;
        bank_ser = _bs;
        hotel_ser = _hs;
        ser_name = _ts;
    }


    function setBank(address a) public {
        l_bank = a;
    }
    function setHotel(address a) public {
        l_hotel = a;
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
    function lockAll(string memory name) public returns(bool){
        bytes[] memory h_args = new bytes[](3);
        h_args[0] = abi.encodePacked(uint64(0));
        h_args[1] = abi.encodePacked(hotel_ser);
        h_args[2] = abi.encodePacked(name);

        bytes[] memory b_args = new bytes[](3);
        b_args[0] = abi.encodePacked(uint64(0));
        b_args[1] = abi.encodePacked(bank_ser);
        b_args[2] = abi.encodePacked(name);
        bool a = Entry(entry).lockState(h_args);
        bool b = Entry(entry).lockState(b_args);
        return (a&&b);
    }

    function lockAllinOne(string memory name,uint len) public returns(bool){
        string[] memory args = new string[](4);
        args[0] = ser_name;
        args[1] = hotel_ser;
        args[2] = bank_ser;
        args[3] = name;

        bool b = Entry(entry).lockMulti(args,len);
        return (b);
    }

    function lockOne(int c, string memory name) public returns(bool){
        bytes[] memory args;
        bool a = false;
        if (c == 0){
            args = new bytes[](3);
            args[0] = abi.encodePacked(uint64(0));
            args[1] = abi.encodePacked(hotel_ser);
            args[2] = abi.encodePacked(name);
            a = Entry(entry).lockState(args);
        }else{
            args = new bytes[](3);
            args[0] = abi.encodePacked(uint64(0));
            args[1] = abi.encodePacked(bank_ser);
            args[2] = abi.encodePacked(name);
            a = Entry(entry).lockState(args);
        }
        return a;
    }


    function buyTicket(string memory name, uint64 num) public returns(bool){
        bytes[] memory hs;
        bytes[] memory bs;
        bool h;
        bool b;
        (h,hs)= Entry(entry).getState(hotel_ser);
        (b,bs)= Entry(entry).getState(bank_ser);
        if (!h||!b){
            return false;
        }     
        uint64 has_rooms = uint64(bytesToUint64(hs[3]));
        uint64 rooms = uint64(bytesToUint64(hs[4]));
        uint64 has_money = uint64(bytesToUint64(bs[3]));
        uint64 t_price = price*num;
        (t_price, has_money) = L_Bank(l_bank).withdraw(has_money,t_price);
        if (t_price == 0){
            return false;
        }
        (num,rooms,has_rooms) = L_Hotel(l_hotel).book(has_rooms,num,rooms);
        if (num == 0){
            return false;
        }
        hs[0] = abi.encodePacked(uint64(0));
        bs[0] = abi.encodePacked(uint64(0));
        hs[3] = abi.encodePacked(uint64(has_rooms));
        hs[4] = abi.encodePacked(uint64(rooms));
        bs[3] = abi.encode(uint64(has_money));
        Entry(entry).updateState(bs);
        Entry(entry).updateState(hs);
        account[name] += num;
        return true;
    }

    function buyInMulit(string memory name, uint64 num) public returns(bool){
        bytes[] memory hs;
        bytes[] memory bs;
        bool h;
        bool b;
        (h,hs)= Entry(entry).getState(hotel_ser);
        (b,bs)= Entry(entry).getState(bank_ser);
        if (!h||!b){
            return false;
        }     
        uint64 has_rooms = uint64(bytesToUint64(hs[3]));
        uint64 rooms = uint64(bytesToUint64(hs[4]));
        uint64 has_money = uint64(bytesToUint64(bs[3]));
        uint64 t_price = price*num;
        (t_price, has_money) = L_Bank(l_bank).withdraw(has_money,t_price);
        if (t_price == 0){
            return false;
        }
        (num,rooms,has_rooms) = L_Hotel(l_hotel).book(has_rooms,num,rooms);
        if (num == 0){
            return false;
        }
        bytes[] memory res = new bytes[](10);
        res[0] = abi.encodePacked(uint64(0));
        res[1] = abi.encodePacked(uint64(4));
        res[2] = abi.encodePacked(hotel_ser);
        res[3] = abi.encodePacked(name);
        res[4] = abi.encodePacked(uint64(has_rooms));
        res[5] = abi.encodePacked(uint64(rooms));
        res[6] = abi.encodePacked(uint64(3));
        res[7] = abi.encodePacked(bank_ser);
        res[8] = abi.encodePacked(name);
        res[9] = abi.encodePacked(uint64(has_money));
        
        Entry(entry).updateMulti(res);
        account[name] += num;
        return true;
    }

    function buy(string memory name, uint64 num) public returns(bool){
        bytes[] memory hs;
        bytes[] memory bs;
        bool h;
        bool b;
        (h,hs)= Entry(entry).getState(hotel_ser);
        (b,bs)= Entry(entry).getState(bank_ser);
        states[bank_ser] = bs;
        states[hotel_ser] = hs;
        if (!h||!b){
            return false;
        }     
        uint64 has_rooms = uint64(bytesToUint64(hs[3]));
        uint64 rooms = uint64(bytesToUint64(hs[4]));
        uint64 has_money = uint64(bytesToUint64(bs[3]));
        uint64 t_price = price*num;
        (t_price, has_money) = L_Bank(l_bank).withdraw(has_money,t_price);
        if (t_price == 0){
            return false;
        }
        (num,rooms,has_rooms) = L_Hotel(l_hotel).book(has_rooms,num,rooms);
        if (num == 0){
            return false;
        }
        
        states[hotel_ser][0] = abi.encodePacked(uint64(0));
        states[bank_ser][0] = abi.encodePacked(uint64(0));
        states[hotel_ser][3] = abi.encodePacked(uint64(has_rooms));
        states[hotel_ser][4] = abi.encodePacked(uint64(rooms));
        states[bank_ser][3] = abi.encode(uint64(has_money));
        // hs[0] = abi.encodePacked(uint64(0));
        // bs[0] = abi.encodePacked(uint64(0));
        // hs[3] = abi.encodePacked(uint64(has_rooms));
        // hs[4] = abi.encodePacked(uint64(rooms));
        // bs[3] = abi.encode(uint64(has_money));
        // states[bank_ser] = bs;
        // states[hotel_ser] = hs;
        // account[name] += num;
        // Entry(entry).updateState(states[bank_ser]);
        // Entry(entry).updateState(states[hotel_ser]);
        account[name] += num;
        return true;
    }


    function update(string memory ser) public{
        Entry(entry).updateState(states[ser]);
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

abstract contract L_Bank{
    function withdraw (uint64 before,uint64 num) public pure virtual returns (uint64,uint64);
    function deposit (uint64 before,uint64 num) public pure virtual returns (uint64);
}

abstract contract L_Hotel{
    function book (uint64 before,uint64 num,uint64 rooms) public pure virtual returns (uint64,uint64,uint64);
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