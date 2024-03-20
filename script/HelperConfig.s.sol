// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// 1. Deploy mocks on local anvil chain
// 2. Keep track of contract addresses across chains

// Sepolia ETH/USD
// Mainnet ETH/USD

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if local anvil chain, deploy mocks
    // otherwise grab existing addresses
    NetworkConfig public activeNetworkConfig;

    uint8 public constant USD_DECIMALS = 8;
    int256 public constant INITIAL_USD_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return mainnetConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // 1. Deploy Mock Contracts
        // 2. Return the mock address

        vm.startBroadcast();

        // usd has 8 decimals
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            USD_DECIMALS,
            INITIAL_USD_PRICE
        );

        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
