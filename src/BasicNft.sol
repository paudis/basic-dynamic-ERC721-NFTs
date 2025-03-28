// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations - enums
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is
    ERC721 // Is run on instantiation
{
    uint256 private s_tokenCounter; // track tokenIds each time an NFT is minted, a storage variable
    mapping(uint256 => string) private s_tokenIdToUri; // maps token to tokenURI

    constructor() ERC721("Doggo", "DOGG") {
        // name and symbol inherited from ERC721
        s_tokenCounter = 0;
    }

    // Every time someone mints a Doggo NFT, a TokenURI needs to be assigned to the minted TokenId
    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri; // map newly minted TokenId -> TokenUri
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    // Need to override as it is a virtual function  in the base ERC721 contract
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
