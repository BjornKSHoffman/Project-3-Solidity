pragma solidity ^0.5.0;

import "./Mint_A_Stock_Tether_Token.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";

contract StockTetherTokenSale is Crowdsale, MintedCrowdsale {

    constructor(
        uint rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        StockTetherToken token // the ArcadeToken itself that the ArcadeTokenSale will work with
    )
        Crowdsale(rate, wallet, token)
        public
    {
        // constructor can stay empty
    }
}

contract StockTetherTokenSaleDeployer {

    address public arcade_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        uint rate,
        uint shares_outstanding,
        address payable wallet // this address will receive all Ether raised by the sale
    )
        public
    {
        // create the ArcadeToken and keep its address handy
        StockTetherToken token = new StockTetherToken(name, symbol, shares_outstanding);
        token_address = address(token);

        // create the ArcadeTokenSale and tell it about the token
        StockTetherTokenSale arcade_sale = new StockTetherTokenSale(rate, wallet, token);
        arcade_sale_address = address(arcade_sale);

        // make the ArcadeTokenSale contract a minter, then have the ArcadeTokenSaleDeployer renounce its minter role
        token.addMinter(arcade_sale_address);
        token.renounceMinter();
    }
}
