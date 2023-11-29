# <img src="logo.png" alt="Cheezburger" height="96"/>

This repository contains the core smart contracts and interfaces powering the Cheezburger ecosystem.

## Overview

Cheezburger provides a decentralized infrastructure for creating and managing tokens with built-in liquidity solutions. Key components include:

- **Cheezburger Factory** - Enables no-code deployment of ERC20 tokens paired with automated liquidity provisioning.
- **Liquidity-Less Tokens** - Allows launching new tokens without needing to provide initial liquidity. Liquidity is handled transparently on-chain.
- **Social Tokens** - Allows creating tokenized profiles for any social media identity in just 2 clicks.

All contracts are immutable, non-upgradeable and internally audited for security. Cheezburger establishes a permissionless, decentralized token launch platform with fair distribution and anti-rug protections.

## Contracts

**Core**

- `CheezburgerFactory.sol` - Main factory for deploying new tokens 
- `Cheezburger.sol` - Cheezburger (CHZB) token contract
- `CheezburgerBun.sol` - Sample ERC20 contract deployed by the factory

**Interfaces**

- `ICheezburger.sol` - Cheezburger token interface
- `ICheezburgerFactory.sol` - Factory interface

**Utils** 

- `CheezburgerConstants.sol` - Library with constant values
- `CheezburgerStructs.sol` - Library with shared data structures
- `CheezburgerSanitizer.sol` - Input validation logic

**Registries**

- `CheezburgerRegistry.sol` - Registry for tracking deployed tokens

**Fee Management** 

- `CheezburgerDynamicTokenomics.sol` - Fee and wallet limit calculations

**Deployer Kit**

- `CheezburgerDeployerKit.sol` - Reusable deployer logic

**Ownership** 

- `CheezburgerOwnership.sol` - Social token ownership management

## Live Implementations

#### Factory (Cheddar 1.1)

| Chain | Contract Address | Explorer Link |
|-|-|-|
| Ethereum | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://etherscan.io/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b)
| BNB Smart Chain | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://bscscan.com/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b)
| Arbitrum | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://arbiscan.io/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b)
| Optimism | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://optimistic.etherscan.io/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b)
| Polygon | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://polygonscan.com/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b) 
| Base | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://basescan.org/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b)
| Ethereum Goerli | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://goerli.etherscan.io/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b)
| Base Goerli | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://goerli.basescan.org/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b)
| BNB Smart Chain Testnet | 0xb51B7D01c94CEFF686E6463CE1eA461C2bb8276B | [Explorer](https://testnet.bscscan.com/address/0xb51b7d01c94ceff686e6463ce1ea461c2bb8276b)

#### CHZB (Social, Liquidity-Less)

| Chain | Contract Address | Explorer Link |
|-|-|-|
| Ethereum | 0xaDd8AbDEa5Cb95f4DCD8e128Eeef64f023615A6a | [Explorer](https://etherscan.io/address/0xaDd8AbDEa5Cb95f4DCD8e128Eeef64f023615A6a)

#### Social (Ownership)

| Chain | Contract Address | Explorer Link |
|-|-|-|
| Ethereum | 0x5F08A522c8a19b59e856aC52973a4617c05F8FFa | [Explorer](https://etherscan.io/address/0x5F08A522c8a19b59e856aC52973a4617c05F8FFa)

## Licensing

The core Cheezburger contracts are released under the MIT License. However, CHZB and Social remains unlicensed. Please review each contract for details on licensing.

## Resources

- [Website](https://cheezburger.lol)
- [Documentation](https://documentation.cheezburger.lol)
- [Bug bounty program](https://documentation.cheezburger.lol/bug-bounty-program)
