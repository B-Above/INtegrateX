pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

//contract DataSwapper {
contract Entry {
    mapping(string => uint64) accountM; // map for accounts
    mapping(string => string) owner; // map for accounts
    mapping(string => bool) islocked;
    struct Item {
        string account;
        uint64 value;
        string owner;
        bool locked;
    }
    // change the address of Broker accordingly
    address BrokerAddr;
    string bitxhubID;
    string appchainID;
    string curFullID;

    // AccessControl
    modifier onlyBroker() {
        require(msg.sender == BrokerAddr, "Invoker are not the Broker");
        _;
    }

    constructor(address _brokerAddr, bool _ordered) {
        BrokerAddr = _brokerAddr;
        Broker(BrokerAddr).register(_ordered);
        (bitxhubID, appchainID) = Broker(BrokerAddr).getChainID();
        curFullID = genFullServiceID(addressToString(getAddress()));
    }

    function register(bool _ordered) public {
        Broker(BrokerAddr).register(_ordered);
    }

    // 告诉源头尝试执行
    function callBackLock(
        string memory sourChainServiceID,
        string memory key,
        uint64 value,
        bool success
    ) public {
        bytes[] memory args = new bytes[](4);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(key);
        args[2] = abi.encodePacked(value);
        // 这里可能有问题 todo
        //args[3] = abi.encodePacked(success);

        Broker(BrokerAddr).emitInterchainEvent(
            sourChainServiceID,
            "informedLock",
            args,
            "",
            new bytes[](0),
            "",
            new bytes[](0),
            false,
            new string[](0)
        );
    }

    function informedLock(
        bytes[] memory args,
        bool isRollback
    ) public onlyBroker returns (bytes[] memory) {
        // require(
        //     args.length == 3,
        //     "interchainCharge args' length is not correct, expect 3"
        // );

        string memory key = string(args[0]);

        // 就是下一行不能执行了
        uint64 value = bytesToUint64(args[1]);
        string memory player = string (args[2]);
        //这里的 success 应该是尝试拿到锁?为什么是传入参数
        //uint64 success = bytesToUint64(args[2]);

        if (!islocked[key]) {
            // 拿到锁，(直接执行) todo 尝试执行
            if(player == "sender"){
                accountM[key] -= value;
            }else{
                accountM[key] += value;
            }
            islocked[key] = true;
            // todo 这里加的参数(233)应该缓存在执行链
            tryAddValue(key, 23);

        } else {
            // 锁拿不到 尝试撤回其它的锁 todo
        }
        return new bytes[](0);
    }

    // 释放锁并且更新对方
    function releaseRemoteLock(
        string memory destChainServiceID,
        string memory key,
        uint64 value
    ) public {
        islocked[key] = false;

        bytes[] memory args = new bytes[](3);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(key);
        args[2] = abi.encodePacked(value);

// 不能直接调用
        Broker(BrokerAddr).emitInterchainEvent(
            destChainServiceID,
            "otherReleaseLock",
            args,
            "",
            new bytes[](0),
            "",
            new bytes[](0),
            false,
            new string[](0)
        ); 

    }

    function otherReleaseLock(
        bytes[] memory args,
        bool isRollback
    ) public onlyBroker returns (bytes[] memory) {
        require(
            args.length == 2,
            "interchainCharge args' length is not correct, expect 1"
        );

        string memory key = string(args[0]);
        uint64 value = bytesToUint64(args[1]);

        // 更新本地的lock
        islocked[key] = true;
        accountM[key] = value;

        return new bytes[](0);
    }

    function setSelf(string memory key, uint64 value) public {
        accountM[key] = value;
        owner[key] = curFullID;
        islocked[key] = true;
    }

    function getSelf(string memory key) public view returns (Item memory) {
        Item memory item;
        item.account = key;
        item.value = accountM[key];
        item.owner = owner[key];
        item.locked = islocked[key];
        return item;
    }

    function tryAddValue(string memory key, uint64 value) public {
        if (islocked[key]) {

            accountM[key] += value;
            if (!compareStrings(owner[key], curFullID)) {
                // 不属于自己释放锁定，更新回去  
                releaseRemoteLock(owner[key], key, accountM[key]);
            }
        } else {
            // 先硬编码一下 todo
            owner[key] = "1356:ethappchain2:0xb00AC45963879cb9118d13120513585873f81Cdb";
            getLock(
                "1356:ethappchain2:0xb00AC45963879cb9118d13120513585873f81Cdb",
                key
            );
        }
    }

    function getLock(
        string memory destChainServiceID,
        string memory key
    ) public {
        bytes[] memory args = new bytes[](3);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(key);
        args[2] = abi.encodePacked(curFullID);

        Broker(BrokerAddr).emitInterchainEvent(
            destChainServiceID,
            "otherGetLock",
            args,
            "",
            new bytes[](0),
            "",
            new bytes[](0),
            false,
            new string[](0)
        );
    }

    function otherGetLock(
        bytes[] memory args,
        bool isRollback
    ) public onlyBroker returns (bytes[] memory) {
        require(
            args.length == 2,
            "interchainCharge args' length is not correct, expect 1"
        );

        string memory key = string(args[0]);
        string memory sourceFullID = string(args[1]);

        // 更新本地的lock
        if (bytes(owner[key]).length == 0) {
            // 之前没有 临时构建一个本地的数据
            setSelf(key, 0);
            // 标记一下锁
            // 这下面的部分执行了嘛？ todo
            islocked[key] = false;
            callBackLock(sourceFullID, key, accountM[key], true);
        } else {
            // 已有数据 查看锁
            if (islocked[key]) {
                // 有锁 可以给他

                // tmp
                islocked[key] = false;
                callBackLock(sourceFullID, key, accountM[key], true);
            } else {
                // 没有锁 不能成功回退
                // tmp
                callBackLock(sourceFullID, "", 0, true);
            }
        }
        return new bytes[](0);
    }

    // contract for asset
    function setOther(
        string memory destChainServiceID,
        string memory key,
        uint64 value
    ) public {
        bytes[] memory args = new bytes[](3);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(key);
        args[2] = abi.encodePacked(value);

        // bytes[] memory argsRb = new bytes[](2);
        // argsRb[0] = abi.encodePacked(key);
        // argsRb[1] = abi.encodePacked(uint64(0));

        Broker(BrokerAddr).emitInterchainEvent(
            destChainServiceID,
            "otherSet",
            args,
            "",
            new bytes[](0),
            "",
            new bytes[](0),
            false,
            new string[](0)
        );
    }

    function otherSet(
        bytes[] memory args,
        bool isRollback
    ) public onlyBroker returns (bytes[] memory) {
        require(
            args.length == 2,
            "interchainCharge args' length is not correct, expect 3"
        );
        string memory key = string(args[0]);
        uint64 value = bytesToUint64(args[1]);
        accountM[key] = value;
        return new bytes[](0);
    }

    function getOther(
        string memory destChainServiceID,
        string memory key
    ) public {
        bytes[] memory args = new bytes[](3);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(key);
        args[2] = abi.encodePacked(curFullID);

        Broker(BrokerAddr).emitInterchainEvent(
            destChainServiceID,
            "otherGet",
            args,
            "",
            new bytes[](0),
            "",
            new bytes[](0),
            false,
            new string[](0)
        );
    }

    function otherGet(
        bytes[] memory args,
        bool isRollback
    ) public onlyBroker returns (bytes[] memory) {
        require(
            args.length == 2,
            "interchainCharge args' length is not correct, expect 1"
        );
        string memory key = string(args[0]);
        string memory sourceFullID = string(args[1]);

        bytes[] memory args = new bytes[](3);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(key);
        args[2] = abi.encodePacked(accountM[key]);
        Broker(BrokerAddr).emitInterchainEvent(
            sourceFullID,
            "otherSet",
            args,
            "",
            new bytes[](0),
            "",
            new bytes[](0),
            false,
            new string[](0)
        );
        // // 如果换成两个参数怎么样
        // bytes[] memory result = new bytes[](1);
        // result[0] = abi.encodePacked(accountM[key]);
        // // 这里一旦回复的是信息 就不行了
        return new bytes[](0);
    }

    // get local contract address
    function getAddress() internal view returns (address) {
        return address(this);
    }

    function bytesToUint64(bytes memory b) public pure returns (uint64) {
        uint64 number;
        for (uint i = 0; i < b.length; i++) {
            number = uint64(
                number + uint8(b[i]) * (2 ** (8 * (b.length - (i + 1))))
            );
        }
        return number;
    }

    function _toChecksumCapsFlags(
        address account
    ) internal pure returns (bool[40] memory characterCapitalized) {
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

            characterCapitalized[2 * i] = (leftNibbleAddress > 9 &&
                leftNibbleHash > 7);
            characterCapitalized[2 * i + 1] = (rightNibbleAddress > 9 &&
                rightNibbleHash > 7);
        }
    }

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
            asciiBytes[2 * i] = bytes1(
                leftNibble + (leftNibble < 10 ? 48 : 87)
            );
            asciiBytes[2 * i + 1] = bytes1(
                rightNibble + (rightNibble < 10 ? 48 : 87)
            );
        }

        return string(asciiBytes);
    }

    function _getAsciiOffset(
        uint8 nibble,
        bool caps
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

    function genFullServiceID(
        string memory serviceID
    ) private view returns (string memory) {
        return
            string(
                abi.encodePacked(bitxhubID, ":", appchainID, ":", serviceID)
            );
    }

    function compareStrings(
        string memory _a,
        string memory _b
    ) public pure returns (bool) {
        // Compare lengths
        if (bytes(_a).length != bytes(_b).length) {
            return false;
        }

        // Compare each character
        for (uint i = 0; i < bytes(_a).length; i++) {
            if (bytes(_a)[i] != bytes(_b)[i]) {
                return false;
            }
        }

        return true;
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
