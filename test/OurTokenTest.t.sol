// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    uint256 public constant STARTING_BALANCE = 1000 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        uint256 bobBalance = ourToken.balanceOf(bob);
        assertEq(
            bobBalance,
            STARTING_BALANCE,
            "Bob should have the starting balance"
        );
    }

    function testAllowancesWorks() public {
        uint256 Initial_Allowance = 100 ether;

        vm.prank(bob);
        ourToken.approve(alice, Initial_Allowance);

        uint256 transferbalance = 50 ether;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferbalance);

        assertEq(
            ourToken.balanceOf(alice),
            transferbalance,
            "Alice should have received the transferred amount"
        );

        assertEq(
            ourToken.balanceOf(bob),
            STARTING_BALANCE - transferbalance,
            "Bob's balance should be reduced after transfer"
        );
    }

    function testTransfer() public {
        uint256 transferAmount = 100 ether;
        vm.startPrank(bob);
        ourToken.transfer(alice, transferAmount);
        assertEq(
            ourToken.balanceOf(alice),
            transferAmount,
            "Alice should receive the transfer amount"
        );
        assertEq(
            ourToken.balanceOf(bob),
            STARTING_BALANCE - transferAmount,
            "Bob's balance should be reduced after transfer"
        );
        vm.stopPrank();
    }

    function testtransferFrom() public {
        uint256 transferAmount = 100 ether;

        vm.prank(bob);
        ourToken.approve(alice, transferAmount);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(
            ourToken.balanceOf(alice),
            transferAmount,
            "Alice should receive the transfer amount"
        );
        assertEq(
            ourToken.balanceOf(bob),
            STARTING_BALANCE - transferAmount,
            "Bob's balance should be reduced after transfer"
        );
    }
}
