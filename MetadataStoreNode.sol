// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MetadataStoreNode {
    struct TrainingData {
        bool used;
        string metrics;
        string artifacts;
        string parameters;
        string weights;
        string tags;
    }

    mapping(uint => TrainingData) public trainingData;

    function logTrainingDataInfo(uint dataID, string memory metrics, string memory artifacts, string memory parameters, string memory weights, string memory tags) public {
        TrainingData storage data = trainingData[dataID];
        data.used = true;
        data.metrics = metrics;
        data.artifacts = artifacts;
        data.parameters = parameters;
        data.weights = weights;
        data.tags = tags;
    }

    function updateTrainingDataStatus(uint dataID, bool newStatus) public {
        trainingData[dataID].used = newStatus;
    }

    function retrieveDataInfo(uint dataID) public view returns (TrainingData memory) {
        return trainingData[dataID];
    }
}
