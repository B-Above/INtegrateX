pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

contract DataSwapper {
    mapping(string => string) dataM; // map for accounts
    // change the address of Broker accordingly
       address BrokerAddr;

    // AccessControl
    modifier onlyBroker {
        require(msg.sender == BrokerAddr, "Invoker are not the Broker");
        _;
    }

    constructor(address _brokerAddr, bool _ordered) {
        BrokerAddr = _brokerAddr;
        Broker(BrokerAddr).register(_ordered);
    }

    function register(bool _ordered) public {
        Broker(BrokerAddr).register(_ordered);
    }

    // contract for data exchange
    function getData(string memory key) public view returns(string memory) {
        return dataM[key];
    }

    function get(string memory destChainServiceID, string memory key, string memory value) public {
        bytes[] memory args = new bytes[](3);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(key);
        args[2] = abi.encodePacked(value);

        Broker(BrokerAddr).emitInterchainEvent(destChainServiceID, "interchainGet", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
    }

    function set(string memory key, string memory value) public {
        dataM[key] = value;
    }

    function interchainSet(bytes[] memory args) public onlyBroker {
        require(args.length == 2, "interchainSet args' length is not correct, expect 2");
        string memory key = string(args[0]);
        string memory value = string(args[1]);
        set(key, value);
    }

    function interchainGet(bytes[] memory args, bool isRollback) public onlyBroker returns(bytes[] memory) {
        require(args.length == 2, "interchainGet args' length is not correct, expect 2");
        string memory key = string(args[0]);
        string memory value = string(args[1]);
        dataM[key] = value;

        return new bytes[](0);
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
        string[] memory group) public virtual;

    function register(bool ordered) public virtual;
}