// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

contract LogicHotel {
    struct bookMap{
        string name;
        uint64 num;
    }
    //房间数量和剩余数量
    uint64 numRooms;
    uint64 remainRooms;
    //锁
    bool isInvoked;

    //由名字映射到定了几个房间
    mapping(string => uint64) guestRooms;
    //房间单价
    uint64 price;
    address brokerAddr;
    //检测器是否处于调用状态
//    modifier onlyUnInvoked() {
//        require(!isInvoked);
//        _;
//    }
//    modifier onlyInvoked() {
//        require(isInvoked);
//        _;
//    }
////  todo 权限调用检测器
//    modifier onlyBroker() {
//        require(msg.sender == brokerAddr);
//        _;
//    }

    constructor(uint64 _num,uint64 _price){
        numRooms = _num;
        remainRooms = _num;
        isInvoked = false;
        price = _price;
    }

    function setState(bytes[] memory args) public {
        numRooms = bytesToUint64(args[0]);
        remainRooms = bytesToUint64(args[1]);
        string memory name = string(args[2]);
        guestRooms[name] = bytesToUint64(args[3]);
        price = bytesToUint64(args[4]);
    }

    function bookRoom (
        string memory _name,
        uint64 _num
    ) external returns (bool, uint64, uint64){
        isInvoked = true;
        if(_num>remainRooms){
            isInvoked = false;
            return (false,0,0);
        }
        guestRooms[_name] = guestRooms[_name] + _num;
        remainRooms -= _num;
        isInvoked = false;
        return (true,price*_num,guestRooms[_name]);
    }

    function releaseLock(bytes[] memory args) public {
        isInvoked = abi.decode(args[0], (bool));
    }

    function setInvoke (
        bytes[] memory args
    ) public returns (bytes[] memory){
        require(args.length == 2, "setInvoke args' length is not correct, expect 2");
        isInvoked = abi.decode(args[0], (bool));
        string memory name = string(args[1]);
        bytes[] memory result = new bytes[](4);
        result[0] = abi.encodePacked(numRooms);
        result[1] = abi.encodePacked(remainRooms);
        result[2] = abi.encodePacked(name);
        result[3] = abi.encodePacked(guestRooms[name]);
        result[4] = abi.encodePacked(price);
        return result;
    }

    function invokeMerge (
        bytes[] memory args
    ) external {
        string memory name = string(args[0]);
        uint64 num = bytesToUint64(args[1]);
        guestRooms[name] = guestRooms[name] + num;
        remainRooms -= num;
        isInvoked = false;
    }

    function lookup(string memory name) public view returns(bookMap memory){
        return bookMap(name, guestRooms[name]);
    }

    function getRemainRooms() public view returns(uint64){
        return remainRooms;
    }

    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }
}
