// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../lib/forge-std/src/Script.sol";
import "../contracts/Diamond.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/facets/PaymentFacet.sol";
import "../contracts/facets/PricefeedFacet.sol";
import "../contracts/interfaces/IDiamondCut.sol";

contract DeployDiamond is Script, IDiamondCut {
    Diamond diamond;
    DiamondCutFacet diamondCutFacet;
    DiamondLoupeFacet diamondLoupeFacet;
    OwnershipFacet ownershipFacet;
    PaymentFacet paymentFacet;
    PricefeedFacet pricefeedFacet;

    function run() public {
        // deploy facets

        // set the deployer address == EOA deploying the contract
        address deployer = 0xc6d123c51c7122d0b23e8B6ff7eC10839677684d;
        uint256 key = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(key);

        diamondCutFacet = new DiamondCutFacet();
        diamond = new Diamond( deployer, address(diamondCutFacet));
        diamondLoupeFacet = new DiamondLoupeFacet();
        ownershipFacet = new OwnershipFacet();
        paymentFacet = new PaymentFacet();
        pricefeedFacet = new PricefeedFacet();


        // forge script script/deployer.s.sol:DeployDiamond --rpc-url https://eth-goerli.g.alchemy.com/v2/guq-3B5soit-xgOtFUtEeodMEJKdlJbe --broadcast --verify 2515NWURZVN1EHDMV6U8SSSX7S8D736JMN

        // upgrade diamond with facets

        FacetCut[] memory cuts = new FacetCut[](4);

        cuts[0] = (
            FacetCut({
                facetAddress: address(diamondLoupeFacet),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cuts[1] = (
            FacetCut({
                facetAddress: address(ownershipFacet),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        cuts[2] = (
            FacetCut({
                facetAddress: address(paymentFacet),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("PaymentFacet")
            })
        );

        cuts[3] = (
            FacetCut({
                facetAddress: address(pricefeedFacet),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("PricefeedFacet")
            })
        );

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cuts, address(0x0), "");
        // call a function to get facet addresses
        DiamondLoupeFacet(address(diamond)).facetAddresses();
        vm.stopBroadcast();
    }

    function generateSelectors(string memory _facetName)
    internal
    returns(bytes4[] memory selectors)
    {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}
    
}


