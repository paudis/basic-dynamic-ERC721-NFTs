// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol"; // encode tokenURI to jsonURI

contract MoodNft is ERC721 {
    error MoodNFT__CantFlipIfNotOwner();

    uint256 private s_tokenCounter; // s_ denotes being stored on-chain, state variable
    string private s_sadSvgImageUri; // the already encoded imageURI (saves gas to do on chain)
    string private s_happySvgImageUri; // tokenUri is json object, contains the imageURi

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood; // tokenIdToMood

    // pass through sadSvg & happySvg through constructor to store on chain
    constructor(string memory sadSvg, string memory happySvg) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvg;
        s_happySvgImageUri = happySvg;
    }

    function mintMoodNft() public {
        _safeMint(msg.sender, s_tokenCounter); // tokenCounter == tokenId
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY; // minted NFT is mapped to default happy
        s_tokenCounter++;
    }

    function flipMoodNft(uint256 tokenId) public view {
        // Needs the imageURI to flip, use key - tokenId
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNFT__CantFlipIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] == Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] == Mood.HAPPY;
        }
    }

    // Concatenating the prefix "data:image/svg+xml;base64,"
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,"; // returns baseURI of our metadata
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        // string memory tokenMetadata - need to  uses abi.encodedPacked to get bytes output

        // return the concatenated tokenURI with prefix and encoded base64 image output :)
        return string( // step 6: return as string
            abi.encodePacked( // step 5: concatenating prefix+encoded metadata
                _baseURI(), // step 4: getting the prefix
                Base64.encode( // step 3: encoded it to Base64 object
                    bytes( // step 2: turned into bytes object
                        abi.encodePacked( // step 1: concat->bytes of the below tokenURI metadata
                            '{"name: "',
                            name(),
                            '", description: "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": 100}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
