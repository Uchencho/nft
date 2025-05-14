// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployNFT} from "../script/DeployNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployNFT public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUB = "";

    function setUp() public {
        deployer = new DeployNFT();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "BasicNFT";
        string memory actualName = basicNft.name();
        // assert(actualName == expectedName); can't compare strings this way
        assertEq(actualName, expectedName);
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintNFT() public {
        vm.prank(USER);
        basicNft.mintNFT(PUB);
        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(PUB)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }
}
