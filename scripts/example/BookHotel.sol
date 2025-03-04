// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;
import "./LogicHotel.sol";

contract BookHotel {
    LogicHotel private hotel;
    mapping(string => uint64) accountM; // map for accounts
    // change the address of Broker accordingly
    address BrokerAddr;

    string bitxhubID;
    string appchainID;
    string curFullID;

    // AccessControl
    modifier onlyBroker {
        require(msg.sender == BrokerAddr, "Invoker are not the Broker");
        _;
    }

    constructor(address _brokerAddr, bool _ordered) {
        BrokerAddr = _brokerAddr;
        Broker(BrokerAddr).register(_ordered);
        (bitxhubID, appchainID) = Broker(BrokerAddr).getChainID();
        curFullID = genFullServiceID(addressToString(getAddress()));
       hotel = new LogicHotel(5,1);
    }

    function getCurFullID() public view returns (string memory) {
        return curFullID;
    }

    // get local contract address
    function getAddress() internal view returns (address) {
        return address(this);
    }

    function register(bool _ordered) public {
        Broker(BrokerAddr).register(_ordered);
    }

    // contract for asset
    function bookHotel(string memory destChainServiceID, string memory booker, uint64 num) public {
        //require(accountM[sender] >= amount);
        //accountM[sender] -= amount;
        bytes[] memory lock_args = new bytes[](2);
        lock_args[0] = abi.encodePacked(true);
        lock_args[1] = abi.encodePacked(booker);
        bytes[] memory args = new bytes[](3);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(booker);
        args[2] = abi.encodePacked(num);
        //args[3] = abi.encodePacked(amount);

//        bytes[] memory argsRb = new bytes[](2);
//        argsRb[0] = abi.encodePacked(sender);
//        argsRb[1] = abi.encodePacked(num);
//        string[] memory func = new string[](3);
//        func[0] = "interchainCharge";
//        func[1] = "";
//        func[2] = "interchainRollback";
        Broker(BrokerAddr).emitInterchainEvent(destChainServiceID, "setInvoke", lock_args, "setLocalHotel", new bytes[](0), "", new bytes[](0), false, new string[](0));
        (bool res, , ) = hotel.bookRoom(booker,num);
        if (res){
            bytes[] memory new_args = new bytes[](2);
            new_args[0] = abi.encodePacked(booker);
            new_args[1] = abi.encodePacked(num);
            Broker(BrokerAddr).emitInterchainEvent(destChainServiceID, "invokeMerge", new_args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
        }

    }

    function test(string memory destChainServiceID, string memory booker, uint64 num) public {
        bytes[] memory new_args = new bytes[](2);
        new_args[0] = abi.encodePacked(booker);
        new_args[1] = abi.encodePacked(num);
        Broker(BrokerAddr).emitInterchainEvent(destChainServiceID, "invokeMerge", new_args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
    }

    function setLocalHotel(bytes[] memory args) public {
        hotel.setState(args);
    }

    function interchainRollback(bytes[] memory args) public onlyBroker {
        require(args.length == 2, "interchainRollback args' length is not correct, expect 2");
        string memory sender = string(args[0]);
        uint64 amount = bytesToUint64(args[1]);
        accountM[sender] += amount;
    }

    function interchainMultiRollback(bytes[] memory args, bool[] memory multiStatus) public onlyBroker {
        uint64 arglenth = bytesToUint64(args[0]);
        string memory sender;
        uint64 amount;
        if (multiStatus.length == 0){
            multiStatus = new bool[]((args.length-1)/arglenth);
            for (uint i = 0; i < (args.length-1)/arglenth; i++){
                multiStatus[i] = false;
            }
        }
        for (uint i = 0; i < multiStatus.length; i++){
            if (!multiStatus[i]){
                sender = string(args[i * arglenth + 1]);
                amount = bytesToUint64(args[i * arglenth + 2]);
                accountM[sender] += amount;
            }
        }
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
