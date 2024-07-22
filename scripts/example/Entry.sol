pragma solidity >=0.5.6;
pragma experimental ABIEncoderV2;

contract Entry {
    mapping(string => string) dataM; // map for accounts
    mapping(string => string) serverID;
    mapping(string => address) serverList;
    mapping(string => address) stateList;
    mapping(string => bytes[]) states;

    // change the address of Broker accordingly
       address BrokerAddr;
       bytes t;
       address t1;

    // AccessControl
    modifier onlyBroker {
        require(msg.sender == BrokerAddr, "Invoker are not the Broker");
        _;
    }

    constructor(address _brokerAddr, bool _ordered) {
        BrokerAddr = _brokerAddr;
        Broker(BrokerAddr).register(_ordered);
    }

    function regServer(string memory s,address addr,string memory ID)public {
        serverList[s] = addr;
        serverID[s] = ID;
    }

    function regState(string memory s,address addr)public {
        stateList[s] = addr;
    }

    function getServer(string memory s)public view returns(address){
        return serverList[s];
    }

    function getServerCode(string memory s) public view returns(bytes memory){
        address a = getServer(s);
        return at(a);
    }

    function register(bool _ordered) public {
        Broker(BrokerAddr).register(_ordered);
    }

    // contract for data exchange
    function getData(string memory key) public view returns(string memory) {
        return dataM[key];
    }

    function see() public view returns(bytes memory,address){
        return(t,t1);
    }   

    function at(address addr) public view returns (bytes memory) {
        bytes memory code;
        bytes memory result = new bytes(32);
        assembly {
            let size := extcodesize(addr)
            code := mload(0x40)
            mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            mstore(add(result, 32), keccak256(code, size))
        }
        return result;
    }
    
    function compareBytes(bytes memory a, bytes memory b) internal pure returns (bool) {
        if (a.length != b.length) {
            return false;
        }
        for (uint64 i = 0; i < a.length; i++) {
            if (a[i] != b[i]) {
                return false;
            }
        }
        return true;
    }

    function checkSeriver(string memory destChainServiceID, string memory name1, string memory name2) public {
        bytes[] memory args = new bytes[](4);
        bytes memory code = getServerCode(name1);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(name1);
        args[2] = abi.encodePacked(name2);
        args[3] = code;
        Broker(BrokerAddr).emitInterchainEvent(destChainServiceID, "interchainGet", args, "interchainSet", new bytes[](0), "", new bytes[](0), false, new string[](0));
    }

    function set(string memory key, string memory value) public {
        dataM[key] = value;
    }

    function interchainSet(bytes[] memory args) public onlyBroker returns(bytes[] memory){
        //require(args.length == 1, "interchainSet args' length is not correct, expect 1");
        string memory name1 = string(args[0]);
        string memory value = string(args[1]);
        dataM[name1] = value;
        return new bytes[](0);
    }

    function interchainGet(bytes[] memory args, bool isRollback) public onlyBroker returns(bytes[] memory) {
        //require(args.length == 3, "interchainGet args' length is not correct, expect 3");
        string memory name1 = string(args[0]);
        string memory name2 = string(args[1]);
        bytes memory code1 = args[2];
        bytes memory code2 = getServerCode(name2);
        if(compareBytes(code1, code2)){
            dataM[name1] = "yes";
        }else {
            dataM[name1] = "no";
        }
        bytes[] memory argb =  new bytes[](2);
        argb[0] = abi.encodePacked(name1);
        argb[1] = abi.encodePacked(dataM[name1]);
        return argb;
    }

    // Multi operation
    function lockMulti(string[] memory sers,uint len) public returns (bool){
        uint l = sers.length; 
        bytes[] memory args = new bytes[](l+2);
        args[0] = abi.encodePacked(uint64(0));
        args[1] = abi.encodePacked(uint64(len));
        for (uint256 i = 0; i<l; i++) 
        {
            args[i+2] = abi.encodePacked(sers[i]);
        }
        Broker(BrokerAddr).emitInterchainEvent(serverID[sers[1]], "interchainLockMulti", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
        return true;
    }

    function updateMulti(bytes[] memory args) public returns (bool){ 
        string memory ser = string(args[2]);
        Broker(BrokerAddr).emitInterchainEvent(serverID[ser], "interchainUpdateMulti", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
        return true;
    }


    //INtegrateX
    function lockState(bytes[] memory args) public returns (bool) {
        string memory server = string(args[1]);
        if(states[server].length == 0){
            //Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainGetState", args, "interchainSetState", new bytes[](0), "", new bytes[](0), false, new string[](0));
            Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainGetState", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
            return true;
        }else {
            if(bytesToUint64(states[server][0])== 0){
                //Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainGetState", args, "interchainSetState", new bytes[](0), "", new bytes[](0), false, new string[](0));
                Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainGetState", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
                return true;
            }
        }
        return false;
    }

    function interchainGetState(bytes[] memory args, bool isRollback)public returns(bytes[] memory){
        string memory server = string(args[0]);
        address ser = stateList[server];
        states[server] =  StateContract(ser).lockState(args);
        receiveSeriver(server);
        return new bytes[](0);
    }

    function receiveSeriver(string memory name1) public {
        uint256 l = states[name1].length;
        bytes[] memory args = new bytes[](l+1);
        args[0] = abi.encodePacked(uint64(0));
        for (uint256 i = 0; i<l; i++) 
        {
            args[i+1] = states[name1][i];
        }
        Broker(BrokerAddr).emitInterchainEvent(serverID[name1], "receiveState", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
    }

    function receiveState(bytes[] memory args, bool isRollback)public returns(bytes[] memory){
        string memory server = string(args[1]);
        states[server] = args;
        address main = stateList[string(args[2])];
        StateContract(main).updateState(args);
        return new bytes[](0);
    }

    function updateState(bytes[] memory args) public {
        string memory server = string(args[1]);
        if(bytesToUint64(states[server][0])!= 0){
            states[server] = args;
            Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainUpdate", states[server], "", new bytes[](0), "", new bytes[](0), false, new string[](0));
        }
    }

    function interchainSetState(bytes[] memory args)public{
        string memory server = string(args[1]);
        states[server] = args;
    }

    function interchainUpdate(bytes[] memory args, bool isRollback)public returns(bytes[] memory){
        string memory server = string(args[0]);
        address ser = stateList[server];
        StateContract(ser).updateState(args);
        return new bytes[](0);
    }

    function getState(string memory ser)public view returns (bool,bytes[] memory){
        if(states[ser].length == 0){
            return (false,new bytes[](0));
        }else {
            if(bytesToUint64(states[ser][0])== 0){
                return (false,new bytes[](0));
            }
        }
        return (true,states[ser]);
    }
    // function lockSeriver(string memory destChainServiceID, string memory name1) public {
    //     bytes[] memory args = new bytes[](3);
    //     args[0] = abi.encodePacked(uint64(0));
    //     args[1] = abi.encodePacked(name1);
    //     args[2] = abi.encodePacked("ycy");
    //     Broker(BrokerAddr).emitInterchainEvent(destChainServiceID, "GetState", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
    // }

    // function GetState(bytes[] memory args, bool isRollback)public returns(bytes[] memory){
    //     string memory server = string(args[0]);
    //     address ser = stateList[server];
    //     bytes[] memory argb =  StateContract(ser).lockState(args);
    //     states[server] = argb;
    //     return new bytes[](0);
    // }

    

    //other operations
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
    

    // function updateAll(bytes[] memory args) public{
    //     for (uint256 i = 0 ; i<args.length; i++) 
    //     {
    //         string memory server = string(args[i]);
    //         states[server][0] = abi.encodePacked(uint64(0));
    //         Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainUpdate", states[server], "", new bytes[](0), "", new bytes[](0), false, new string[](0));
    //     }
  
    // }

    // function update(string memory server) public{    
    //     states[server][0] = abi.encodePacked(uint64(0));
    //     Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainUpdate", states[server], "", new bytes[](0), "", new bytes[](0), false, new string[](0));
    // }

    
    // ChainMode
    function lockChainMode(bytes[] memory args) public returns (bool) {
        string memory server = string(args[1]);
        //Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainGetState", args, "interchainSetState", new bytes[](0), "", new bytes[](0), false, new string[](0));
        Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainModeGet", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
        return true;
    }

    function updateChainMode(bytes[] memory args) public returns (bool) {
        string memory server;
        bytes[] memory args1 = new bytes[](2);
        args1[0] = abi.encodePacked(uint64(0));
        uint l = args.length;
        for (uint i = 0; i<l; i++) 
        {
            server = string(args[i]);
            args1[1] = args[i];
            Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainModeUp", args1, "", new bytes[](0), "", new bytes[](0), false, new string[](0)); 
        }
        //Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainGetState", args, "interchainSetState", new bytes[](0), "", new bytes[](0), false, new string[](0));
        return true;
    }

    function receiveChainMode(bytes[] memory args) public returns (bool) {
        string memory server = string(args[1]);
        //Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainGetState", args, "interchainSetState", new bytes[](0), "", new bytes[](0), false, new string[](0));
        Broker(BrokerAddr).emitInterchainEvent(serverID[server], "interchainUpdate", args, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
        return true;
    }

    function interchainModeUp(bytes[] memory args, bool isRollback)public returns(bytes[] memory){
        string memory server = string(args[0]);
        address ser = stateList[server];
        StateContract(ser).receiveState(args);
        return new bytes[](0);
    }

    function interchainModeGet(bytes[] memory args, bool isRoolback)public returns(bytes[] memory){
        string memory server = string(args[0]);
        address ser = stateList[server];
        states[server] =  StateContract(ser).lockState(args);
        return new bytes[](0);
    }

    // Multi operation
    function interchainLockMulti(bytes[] memory args, bool isRollback)public returns(bytes[] memory){
        uint64 l = bytesToUint64(args[0]);
        string memory asker = string(args[1]);
        bytes[][] memory argb = new bytes [][](l);
        bytes[] memory targs = new bytes[](2);
        targs[0] = args[0];
        targs[1] = args[l+2];
        uint64 c = 0;
        for (uint256 i=0; i<l; i++) 
        {
            string memory server = string(args[i+2]);
            address ser = stateList[server];
            argb[i] = StateContract(ser).lockState(targs);
            c = c + bytesToUint64(argb[i][0]);
        }
        bytes[] memory res = new bytes[](c+1);
        res[0] = abi.encodePacked(uint64(0));
        uint index = 1;
        for (uint256 i=0; i<l; i++) 
        {
            uint64 k = bytesToUint64(argb[i][0]);
            for (uint256 j=0; j<k; j++) 
            {
                res[index] = argb[i][j];
                index += 1;
            }
        }
        states[asker] = res;
        Broker(BrokerAddr).emitInterchainEvent(serverID[asker], "interchainReceiveMulti", res, "", new bytes[](0), "", new bytes[](0), false, new string[](0));
        return new bytes[](0);
    }

    function interchainReceiveMulti(bytes[] memory args, bool isRollback)public returns(bytes[] memory){
        uint l = args.length;
        for (uint i = 0; i<l; i++) 
        {
            uint64 r = bytesToUint64(args[i]);
            bytes[] memory temp =new bytes[](r);
            temp[0] = args[i];
            for (uint j = 1; j<r; j++) 
            {
                temp[j] = args[i+j];
            }
            string memory ser = string(temp[1]);
            states[ser] = temp;
            i = i+r-1;
        }
        return new bytes[](0);
    }

    function interchainUpdateMulti(bytes[] memory args, bool isRollback)public returns(bytes[] memory){
        uint l = args.length;
        for (uint i = 0; i<l; i++) 
        {
            uint64 r = bytesToUint64(args[i]);
            bytes[] memory temp =new bytes[](r);
            temp[0] = args[i];
            for (uint j = 1; j<r; j++) 
            {
                temp[j] = args[i+j];
            }
            string memory server = string(temp[1]);

            address ser = stateList[server];
            StateContract(ser).updateState(temp);
            i = i+r-1;
        }
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

abstract contract StateContract {
    function lockState(bytes[] memory args) public virtual returns (bytes[] memory);
    function updateState(bytes[] memory args) public virtual;
    function receiveState(bytes[] memory args) public virtual;
}
