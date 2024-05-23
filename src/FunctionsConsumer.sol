// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

import { FunctionsClient } from "lib/chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import { ConfirmedOwner } from "lib/chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import { FunctionsRequest } from "lib/chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

contract FunctionsConsumer is FunctionsClient, ConfirmedOwner {
    using FunctionsRequest for FunctionsRequest.Request;

    bytes32 public donId;
    string public storedData;  // New variable to store data in the contract
    string public latestForecast;

    event ForecastedPrice(string latestForecast);
    event OCRResponse(bytes32 indexed requestId, bytes result, bytes err);

    bytes32 public latestRequestId;
    bytes public latestResponse;
    bytes public latestError;

    constructor(address router, bytes32 _donId) FunctionsClient(router) ConfirmedOwner(msg.sender) {
        donId = _donId;
    }

    function setStoredData(string memory data) public onlyOwner {
        storedData = data;
    }

    function sendAIRequest(
        string calldata source,
        FunctionsRequest.Location secretsLocation,
        bytes calldata encryptedSecretsReference,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) external onlyOwner {
        FunctionsRequest.Request memory req;
        req.initializeRequest(
            FunctionsRequest.Location.Inline,
            FunctionsRequest.CodeLanguage.JavaScript,
            source
        );
        req.secretsLocation = secretsLocation;
        req.encryptedSecretsReference = encryptedSecretsReference;
        
        // Include the stored data in the request
        string[] memory args = new string[](1);
        args[0] = storedData;
        req.setArgs(args);
        
        latestRequestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            callbackGasLimit,
            donId
        );
    }

    function fulfillRequest(bytes32 requestId, bytes memory response, bytes memory err) internal override {
        latestResponse = response;
        latestError = err;
        latestRequestId = requestId;
        latestForecast = string(abi.encodePacked(response));
        emit ForecastedPrice(latestForecast);
        emit OCRResponse(requestId, response, err);
    }
}
