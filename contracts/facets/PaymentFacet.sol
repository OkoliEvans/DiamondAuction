//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "../../lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import { LibDiamond } from "../libraries/LibDiamond.sol";
import { PricefeedFacet } from "./PricefeedFacet.sol";

contract PaymentFacet {
   

    function setAdmin(address _admin) external returns(address) {
         LibDiamond.DiamondStorage storage pStore = LibDiamond.diamondStorage();
        pStore.contractOwner = _admin;
        return pStore.contractOwner;
    }

    function addItemPasscode(string memory _item, uint256 _passcode) external {
        LibDiamond.DiamondStorage storage pStore = LibDiamond.diamondStorage();
        if (msg.sender != pStore.contractOwner)
            revert("Unauthorized Operation: Only admin is authorized...");
        pStore.passcodeAssignedPerItem[_item] = _passcode;
    }

    function setTokens(address _token, uint16 _decimal) external {
        LibDiamond.DiamondStorage storage pStore = LibDiamond.diamondStorage();
        if(msg.sender != pStore.contractOwner ) revert("Unauthorized Operation: Only admin is authorized...");
        pStore.decimalPerToken[_token] = _decimal;
    }

    function buy(string memory _item,address _token, uint256 _amount) external returns (bool success) {
        _swapUsdtEth(_token, _amount);
        require(success = true, "Purchase Fail...!");
        _returnPasscode(_item);
    }

    ////////////  v2 CORE FUNCTIONS   //////////////////

    function _swapUsdtEth( address _tokenA ,uint256 _amountA) internal {
          LibDiamond.DiamondStorage storage pStore = LibDiamond.diamondStorage();
        PricefeedFacet ps;
        int256 priceEth = ps.getLatestEthPrice();
        uint256 swapRate = (3.5 ether * uint256(priceEth)) / 1e18;
        if( pStore.decimalPerToken[_tokenA] == 0 ) revert("Only USDT is accepted for now");
        if (_amountA < swapRate) revert("Price is 3.5 ether");
        bool success = IERC20(_tokenA).transferFrom(
            msg.sender,
            address(this),
            _amountA
        );
        if (!success) revert("Withdraw Fail...!");
    }

    function _returnPasscode(
        string memory _item
    ) internal view returns (uint256) {
         LibDiamond.DiamondStorage storage pStore = LibDiamond.diamondStorage();
        // if (!ps.buyerIsRecorded[msg.sender]) revert("No record found...");
        return pStore.passcodeAssignedPerItem[_item];
    }

    function withdrawEth(address _to, uint256 _amount) external {
         LibDiamond.DiamondStorage storage pStore = LibDiamond.diamondStorage();
        if (address(this).balance < _amount) {
            revert("Insufficient funds");
        }
        if (_to == address(0)) revert("ERROR: Invalid address");
        if (msg.sender != pStore.contractOwner)
            revert("Unauthorized Operation: Only Admin is authorized");
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Withdraw Fail...!");
    }

    function withdrawToken(address _token, address _to, uint256 _amount) external {
        LibDiamond.DiamondStorage storage pStore = LibDiamond.diamondStorage();
        if (address(this).balance < _amount) {
            revert("Insufficient funds");
        }
        if (_to == address(0)) revert("ERROR: Invalid address");
        if (msg.sender != pStore.contractOwner)
            revert("Unauthorized Operation: Only Admin is authorized");
        bool success = IERC20(_token).transfer(_to, _amount);
        require(success, "Withdraw Fail...!");
    }
}
