// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";
import {BasicNft} from "src/BasicNft.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer; // Init the deployer
    BasicNft public basicNft; // Init basicNft

    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    // To allow this contract to accept the nft
    /*function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) pure external returns (bytes4) {
        return this.onERC721Received.selector;
    }*/

    function setUp() public {
        deployer = new DeployBasicNft(); // Instantiate
        basicNft = deployer.run(); // deployer calls run()
    }

    // Tests //

    function testNameIsCorrect() public view {
        // Arrange - setup()
        string memory expectedName = "Doggo";

        // Act
        string memory tokenName = basicNft.name();

        // Assert - better to compare between hashes of the strings
        assert(keccak256(abi.encodePacked(tokenName)) == keccak256(abi.encodePacked(expectedName)));
    }

    // needs a user
    function testCanMintAndHaveABalance() public {
        // Arrange
        vm.prank(USER); // prank the user
        basicNft.mintNft(PUG); // user now mints an nft

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
