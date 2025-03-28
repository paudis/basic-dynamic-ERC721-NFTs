// SPDX- License-Identifier: MIT

/**
 * @title DeployMoodNft
 * @author Thanh Vu
 * @notice This script is to automate the process of deploying MoodNft to a blockchain network. Allows automatic deployment of multiple contracts
 * @dev Add pre-deployment checks and post-depployment actions. Add constructor to set initial values, get values for constructor
 */
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {MoodNft} from "src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(svgToImageURI(happySvg), svgToImageURI(sadSvg));
        vm.stopBroadcast();

        return moodNft;
    }

    // take the svg string param, encode it using OZ Base64 encode function
    // concatenates the encoded  value  with the baseURL
    // basically does the base64 -i happy/svg encoding thing programmatically!
    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));

        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}
