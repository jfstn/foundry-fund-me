// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

// Test types:
// Unit
// Integration
// Forked test
// testing our code on a simulated real environment
// forge test --match-test "testPriceFeedVersionIsAccurate" -vvv --fork-url $SEPOLIA_RPC_URL
// Staging
// testing our code on a real environment

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new DeployFundMe().run();
    }

    function testMinimunDollarIsFive() external view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMessageSender() external view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() external view {
        assertEq(fundMe.getVersion(), 4);
    }
}
