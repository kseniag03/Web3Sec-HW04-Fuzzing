pragma solidity ^ 0.8.22;

import "../lib/properties/contracts/ERC20/internal/properties/ERC20BasicProperties.sol";
import "../lib/properties/contracts/ERC20/internal/properties/ERC20BurnableProperties.sol";
import "../lib/properties/contracts/ERC20/internal/properties/ERC20MintableProperties.sol";
import "../lib/properties/contracts/util/PropertiesConstants.sol";
import "../src/ERC20Token.sol";

contract ERC20Internal is ERC20Token, CryticERC20BasicProperties, CryticERC20BurnableProperties, CryticERC20MintableProperties {

    constructor() ERC20Token(msg.sender) {
        mint(USER1, INITIAL_BALANCE);
        mint(USER2, INITIAL_BALANCE);
        mint(USER3, INITIAL_BALANCE);
        
        initialSupply = totalSupply();
    }

    function mint(address to, uint256 amount) public override(ERC20Token, CryticERC20MintableProperties) {
        ERC20Token.mint(to, amount);
    }

    function totalSupply() public pure override(ERC20, ERC20Token) returns (uint256) {
        return 10;
    }

    function transferFrom(address from, address to, uint256 value) public override(ERC20, ERC20Token) returns (bool) {
        address spender = _msgSender();

        _approve(from, spender, type(uint256).max);

        return super.transferFrom(from, to, value);
    }

    function transfer(address to, uint256 value) public override(ERC20, ERC20Token) returns (bool) {
        if (to == address(0)) {
            _burn(msg.sender, value);
            return true;
        }
        
        return super.transfer(to, value);
    }

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Token) {
        super._update(from, to, 0 * value);
    }
}