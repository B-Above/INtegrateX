// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

contract Ticket{
    mapping (string => int) account;
    int price ;
    address l_bank;
    address l_hotel;
    address entry;
    string bank_ser;
    string hotel_ser;

    constructor(address _bank, address _hotel,int p,address _entry,string memory _bs,string memory _hs) {
        l_bank = _bank;
        l_hotel = _hotel;
        entry = _entry;
        price = p;
        bank_ser = _bs;
        hotel_ser = _hs;
    }


    function setBank(address a) public {
        l_bank = a;
    }
    function setHotel(address a) public {
        l_hotel = a;
    }
    function setPrice(int a)public{
        price = a;
    }
    function  getState(string memory name) public view returns (int){
        return (account[name]);
    }

    function setState(string memory name, int money)public {
        account[name] = money;
    }

    function pay (string memory name,int num) public returns (int){
        int a;
        int b;
        (a,b) = L_Bank(l_bank).withdraw(account[name],num);
        account[name] = b;
        return a;
    } 
    function deposit(string memory name, int num) public returns(int){
        int a = L_Bank(l_bank).deposit(account[name], num);
        account[name] = a;
        return a;
    }
    function lockAll(string memory name) public returns(bool){
        bytes[] memory h_args = new bytes[](3);
        h_args[0] = abi.encodePacked(uint64(0));
        h_args[1] = abi.encodePacked(hotel_ser);
        h_args[2] = abi.encodePacked(name);

        bytes[] memory b_args = new bytes[](4);
        b_args[0] = abi.encodePacked(uint64(0));
        b_args[1] = abi.encodePacked(bank_ser);
        b_args[2] = abi.encodePacked(name);
        bool a = Entry(entry).lockState(h_args);
        bool b = Entry(entry).lockState(b_args);
        return (a&&b);
    }


    function butTicket(string memory name, int num) public returns(bool){
        bytes[] memory hs;
        bytes[] memory bs;
        bool h;
        bool b;
        (h,hs)= Entry(entry).getState(name);
        (b,bs)= Entry(entry).getState(name);
        if (!h||!b){
            return false;
        }
        int has_rooms = abi.decode(hs[3], (uint64));
        int rooms = abi.decode(hs[4], (uint64));
        int has_money = abi.decode(bs[3],(uint64));
        int t_price = price*num;
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
}

abstract contract L_Bank{
    function withdraw (int before,int num) public pure virtual returns (int,int);
    function deposit (int before,int num) public pure virtual returns (int);
}

abstract contract L_Hotel{
    function book (int before,int num,int rooms) public pure virtual returns (int,int,int);
}

abstract contract Entry{
    function lockState(bytes[] memory args) public virtual returns (bool);
    function getState(string memory ser)public view virtual returns (bool,bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function updateAll(bytes[] memory args)public virtual;
}