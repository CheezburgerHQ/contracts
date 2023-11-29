## 🍔 Cheezburger Smart Contracts

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

## Licensing

The core Cheezburger contracts are released under the MIT License. However, CHZB and Social remains unlicensed. Please review each contract for details on licensing.

## Resources

- [Website](https://cheezburger.lol)
- [Documentation](https://documentation.cheezburger.lol)
- [Bug bounty program](https://documentation.cheezburger.lol/bug-bounty-program)
