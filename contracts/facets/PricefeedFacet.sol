// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import { LibDiamond } from "../libraries/LibDiamond.sol";

contract PricefeedFacet {

    // constructor() {
    //     EthPriceFeed = AggregatorV3Interface(
    //         0xEe9F2375b4bdF6387aa8265dD4FB8F16512A1d46
    //     );
    //     EthBnbPriceFeed = AggregatorV3Interface(
    //         0xc546d2d06144F9DD42815b8bA46Ee7B8FcAFa4a2
    //     );
    // }

    function addAggregators(address _Aggregator, string memory _tokenSymbol) external {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        if(msg.sender != ds.contractOwner) revert("Unauthorized Operation: ONLY ADMIN ACCESS");
        ds.tokenAggregator[_Aggregator] = _tokenSymbol;
    }

    /**
     * Returns the latest price.
     */
    function getLatestEthPrice() external view returns (int) {
      LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        // prettier-ignore
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = ds.PriceFeedEth.latestRoundData();
        return (price/ 1e18);
    }
    
}
