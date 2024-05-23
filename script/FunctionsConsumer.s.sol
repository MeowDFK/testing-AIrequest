// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/FunctionsConsumer.sol"; // Adjust the path based on your directory structure

contract DeployFunctionsConsumer is Script {
    function run() external {
        // Load environment variables
        address  routerAddress = vm.envAddress("CHAINLINK_ROUTER");
        bytes32 donId = vm.envBytes32("DON_ID");
        address owner = vm.envAddress("OWNER_ADDRESS");

        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the FunctionsConsumer contract
        FunctionsConsumer functionsConsumer = new FunctionsConsumer(routerAddress, donId);

        // Transfer ownership if necessary (and avoid self-transfer)
        if (owner != address(0) && owner != msg.sender) {
            functionsConsumer.transferOwnership(owner);
        }

        // Log the address of the deployed contract
        console.log("FunctionsConsumer deployed to:", address(functionsConsumer));

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
