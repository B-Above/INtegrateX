// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

contract Hotel {
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
    //跨链参数
    address BrokerAddr;
    string bitxhubID;
    string appchainID;
    string curFullID;
    //检测器是否处于调用状态
    modifier onlyUnInvoked() {
        require(!isInvoked);
        _;
    }
    modifier onlyInvoked() {
        require(isInvoked);
        _;
    }
//  todo 权限调用检测器
    modifier onlyBroker() {
        require(msg.sender == BrokerAddr);
        _;
    }

    constructor(address _brokerAddr, bool _ordered,uint64 _num,uint64 _price) {
        BrokerAddr = _brokerAddr;
        Broker(BrokerAddr).register(_ordered);
        (bitxhubID, appchainID) = Broker(BrokerAddr).getChainID();
        curFullID = genFullServiceID(addressToString(getAddress()));
        numRooms = _num;
        remainRooms = _num;
        isInvoked = false;
        price = _price;
    }

    function setState(bytes[] memory args) public onlyBroker{
        numRooms = bytesToUint64(args[0]);
        remainRooms = bytesToUint64(args[1]);
        string memory name = string(args[2]);
        guestRooms[name] = bytesToUint64(args[3]);
        price = bytesToUint64(args[4]);
    }

    function bookRoom (
        string memory _name,
        uint64 _num
    ) external onlyUnInvoked returns (bool, uint64, uint64){
        isInvoked = true;
        if(_num>remainRooms){
            isInvoked = false;
            return (false,0,0);
        }
        guestRooms[_name] += _num;
        remainRooms -= _num;
        isInvoked = false;
        return (true,price*_num,guestRooms[_name]);
    }

    function releaseLock(bytes[] memory args) public onlyBroker{
        isInvoked = abi.decode(args[0], (bool));
    }

    function setInvoke (
        bytes[] memory args
    ) public onlyBroker onlyUnInvoked returns (bytes[] memory){
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

//    function invokeMerge (
//        bytes[] memory args
//    ) external onlyBroker onlyInvoked{
//        string memory name = string(args[0]);
//        uint64 num = bytesToUint64(args[1]);
//        guestRooms[name] += num;
//        remainRooms -= num;
//        isInvoked = false;
//    }
    function test(string memory name, uint64 num) public{
        bytes[] memory new_args = new bytes[](2);
        new_args[0] = abi.encodePacked(name);
        new_args[1] = abi.encodePacked(num);
        invokeMerge(new_args);
    }

    function invokeMerge (
        bytes[] memory args
    ) public {
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

    function getAddress() internal view returns (address) {
        return address(this);
    }

    function bytesToUint64(bytes memory b) public pure returns (uint64){
        uint64 number;
        for(uint i=0;i<b.length;i++){
            number = uint64(number + uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }

    function addressToString(
        address account
    ) internal pure returns (string memory asciiString) {
        // convert the account argument from address to bytes.
        bytes20 data = bytes20(account);

        // create an in-memory fixed-size bytes array.
        bytes memory asciiBytes = new bytes(40);

        // declare variable types.
        uint8 b;
        uint8 leftNibble;
        uint8 rightNibble;
        bool leftCaps;
        bool rightCaps;
        uint8 asciiOffset;

        // get the capitalized characters in the actual checksum.
        bool[40] memory caps = _toChecksumCapsFlags(account);

        // iterate over bytes, processing left and right nibble in each iteration.
        for (uint256 i = 0; i < data.length; i++) {
            // locate the byte and extract each nibble.
            b = uint8(uint160(data) / (2 ** (8 * (19 - i))));
            leftNibble = b / 16;
            rightNibble = b - 16 * leftNibble;

            // locate and extract each capitalization status.
            leftCaps = caps[2 * i];
            rightCaps = caps[2 * i + 1];

            // get the offset from nibble value to ascii character for left nibble.
            asciiOffset = _getAsciiOffset(leftNibble, leftCaps);

            // add the converted character to the byte array.
            asciiBytes[2 * i] = bytes1(leftNibble + asciiOffset);

            // get the offset from nibble value to ascii character for right nibble.
            asciiOffset = _getAsciiOffset(rightNibble, rightCaps);

            // add the converted character to the byte array.
            asciiBytes[2 * i + 1] = bytes1(rightNibble + asciiOffset);
        }


        return string(abi.encodePacked("0x", asciiBytes));
    }

    function _toChecksumCapsFlags(address account) internal pure returns (
        bool[40] memory characterCapitalized
    ) {
        // convert the address to bytes.
        bytes20 a = bytes20(account);

        // hash the address (used to calculate checksum).
        bytes32 b = keccak256(abi.encodePacked(_toAsciiString(a)));

        // declare variable types.
        uint8 leftNibbleAddress;
        uint8 rightNibbleAddress;
        uint8 leftNibbleHash;
        uint8 rightNibbleHash;

        // iterate over bytes, processing left and right nibble in each iteration.
        for (uint256 i; i < a.length; i++) {
            // locate the byte and extract each nibble for the address and the hash.
            rightNibbleAddress = uint8(a[i]) % 16;
            leftNibbleAddress = (uint8(a[i]) - rightNibbleAddress) / 16;
            rightNibbleHash = uint8(b[i]) % 16;
            leftNibbleHash = (uint8(b[i]) - rightNibbleHash) / 16;

            characterCapitalized[2 * i] = (
                leftNibbleAddress > 9 &&
                leftNibbleHash > 7
            );
            characterCapitalized[2 * i + 1] = (
                rightNibbleAddress > 9 &&
                rightNibbleHash > 7
            );
        }
    }

    // based on https://ethereum.stackexchange.com/a/56499/48410
    function _toAsciiString(
        bytes20 data
    ) internal pure returns (string memory asciiString) {
        // create an in-memory fixed-size bytes array.
        bytes memory asciiBytes = new bytes(40);

        // declare variable types.
        uint8 b;
        uint8 leftNibble;
        uint8 rightNibble;

        // iterate over bytes, processing left and right nibble in each iteration.
        for (uint256 i = 0; i < data.length; i++) {
            // locate the byte and extract each nibble.
            b = uint8(uint160(data) / (2 ** (8 * (19 - i))));
            leftNibble = b / 16;
            rightNibble = b - 16 * leftNibble;

            // to convert to ascii characters, add 48 to 0-9 and 87 to a-f.
            asciiBytes[2 * i] = bytes1(leftNibble + (leftNibble < 10 ? 48 : 87));
            asciiBytes[2 * i + 1] = bytes1(rightNibble + (rightNibble < 10 ? 48 : 87));
        }

        return string(asciiBytes);
    }

    function _getAsciiOffset(
        uint8 nibble, bool caps
    ) internal pure returns (uint8 offset) {
        // to convert to ascii characters, add 48 to 0-9, 55 to A-F, & 87 to a-f.
        if (nibble < 10) {
            offset = 48;
        } else if (caps) {
            offset = 55;
        } else {
            offset = 87;
        }
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function genFullServiceID(string memory serviceID) private view returns (string memory) {
        return string(abi.encodePacked(bitxhubID, ":", appchainID, ":", serviceID));
    }
}

abstract contract Broker {
    function emitInterchainEvent(
        string memory destFullServiceID,
        string memory func,
        bytes[] memory args,
        string memory funcCb,
        bytes[] memory argsCb,
        string memory funcRb,
        bytes[] memory argsRb,
        bool isEncrypt,
        string[] memory group
    ) public virtual;

    function register(bool ordered) public virtual;

    function getOuterMeta()
    public
    view
    virtual
    returns (string[] memory, uint64[] memory);

    function getChainID()
    public
    view
    virtual
    returns (string memory, string memory);
}
