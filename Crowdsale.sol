pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, TimedCrowdsale, CappedCrowdsale,RefundablePostDeliveryCrowdsale{

    constructor(
        uint rate,
        address payable wallet,
        PupperCoin token,
        uint cap,
        uint openingTime,
        uint closingTime,
        uint goal// @TODO: Fill in the constructor parameters!
    )
         Crowdsale(rate, wallet, token)
         CappedCrowdsale(cap)
         TimedCrowdsale(openingTime,closingTime)
         RefundableCrowdsale(goal)
         // @TODO: Pass the constructor parameters to the crowdsale contracts.
        public
    {
        // constructor can stay empty
    }
  
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal// @TODO: Fill in the constructor parameters!
    )
        public
    {
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);// @TODO: create the PupperCoin and keep its address handy

        PupperCoinSale coin_sale = new PupperCoinSale(1, wallet, token, now , now + 24 weeks, goal, 300000000000000000000);
        token_sale_address = address(coin_sale);// @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
