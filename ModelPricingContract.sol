// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract ModelPricingContract is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 public baselineScore;
    uint256 public retrainedScore;
    uint256 public currentPrice; // The current price based on the model score

    // Chainlink Oracle parameters
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    // Define pricing tiers
    uint256 private constant tier1Price = 50;
    uint256 private constant tier2Price = 100;
    uint256 private constant tier3Price = 150;

    // API URLs
    string private baselineScoreUrl = "https://e3c4-72-203-214-88.ngrok.io/baseline-score";
    string private retrainedScoreUrl = "https://e3c4-72-203-214-88.ngrok.io/retrained-score";

    // Constructor to set up Chainlink
    constructor() {
        setPublicChainlinkToken();
        oracle = /* Chainlink Oracle Address */;
        jobId = /* Chainlink Job ID */;
        fee = /* Chainlink Fee */;
    }

    // Request Baseline Score
    function requestBaselineScore() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfillBaselineScore.selector);
        request.add("get", baselineScoreUrl);
        request.add("path", "data,path"); // Adjust the JSON path
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    // Request Retrained Score
    function requestRetrainedScore() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfillRetrainedScore.selector);
        request.add("get", retrainedScoreUrl);
        request.add("path", "data,path"); // Adjust the JSON path
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    // Callback function for baseline score
    function fulfillBaselineScore(bytes32 _requestId, uint256 _score) public recordChainlinkFulfillment(_requestId) {
        baselineScore = _score;
        updatePricing(baselineScore);
    }

    // Callback function for retrained score
    function fulfillRetrainedScore(bytes32 _requestId, uint256 _score) public recordChainlinkFulfillment(_requestId) {
        retrainedScore = _score;
        updatePricing(retrainedScore);
    }

    // Function to update pricing
    function updatePricing(uint256 _score) internal {
        if (_score < 0.3) {
            currentPrice = tier1Price;
        } else if (_score < 0.7) {
            currentPrice = tier2Price;
        } else {
            currentPrice = tier3Price;
        }
    }

    // Additional functions to interact with the model, handle payments, etc.
}
// Data Stream 
contract DataConsumerV3 {
    AggregatorV3Interface internal dataFeed;

    /**
     * Network: Sepolia
     * Aggregator: ETH/USD
     * Address: 0x72AFAECF99C9d9C8215fF44C77B94B99C28741e8
     */
    constructor() {
        dataFeed = AggregatorV3Interface(
            0x72AFAECF99C9d9C8215fF44C77B94B99C28741e8
        );
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }
}
