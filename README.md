# IntegrateX

**IntegrateX** , an efficient cross-chain interoperability system that ensures the overall atomicity of cross-chain smart contract invocations. 

 

## Deployment

This project use Bitxhub to implement the relayer in cross chain communication.

Use [usage documentation](https://github.com/meshplus/goduck/wiki/%E9%83%A8%E7%BD%B2%E5%B7%A5%E5%85%B7goduck%E4%BD%BF%E7%94%A8%E6%96%87%E6%A1%A3) to quick run BitXHub.



### Quick start

```shell
goduck playground start
```



## 📁 Project Structure

```
.
├── IntegrateX/                # Main implementation of the cross-chain framework
│   ├── Bridging/              # Bridging contracts for cross-chain message verification and dispatch
│   ├── Deeptest/              # Deep testing modules 
│   ├── FGL/                   # Fine-grained locking mechanism example
│   ├── Train-Hotel/           # Cross-chain application example: hotel and train booking coordination
│   └── ethereum_client/       # Scripts or tools to run local Ethereum-compatible chains
├── Script/  				   # Scripts for dockers,quick start and config  
├── Contract setting.md        # Contract setting for each contract  
```



