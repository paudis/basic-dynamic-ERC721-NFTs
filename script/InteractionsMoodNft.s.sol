// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintMoodNft is Script {
    // get most recent version of the NFT contract and deploy it
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        mintOnContract(mostRecentlyDeployed);
    }

    // simulate on chain transactions and mint the NFT to contractAddress
    function mintOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintMoodNft();
        vm.stopBroadcast();
    }
}


