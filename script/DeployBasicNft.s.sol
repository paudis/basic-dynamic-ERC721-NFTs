// SPDX-License-Identifier: MIT
// deploy script to allow deployment to different environemtns eg testnet, mainnet, local

pragma solidity ^0.8.18;

import {BasicNft} from "../src/BasicNft.sol";
import {Script} from "forge-std/Script.sol";

contract DeployBasicNft is Script {
    function run() external returns (BasicNft) {
        vm.startBroadcast(); // subsequent actions will be treated as real blockchain actions
        BasicNft basicNft = new BasicNft(); // new instance of nft is called
        vm.stopBroadcast();
        return basicNft;
    }
}
