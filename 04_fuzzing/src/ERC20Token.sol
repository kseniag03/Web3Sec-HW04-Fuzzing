// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^ 0.8.22;

import { ERC20 } from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { ERC20Burnable } from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { ERC20Pausable } from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import { ERC20Permit } from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import { Ownable } from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract ERC20Token is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ERC20Permit {
    constructor(address initialOwner)
    ERC20("ERC20Token", "MTK")
    Ownable(initialOwner)
    ERC20Permit("ERC20Token")
    { }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public virtual onlyOwner {
        _mint(to, amount);
    }

    function totalSupply() public pure virtual override(ERC20) returns (uint256) {
        return 10;
    }

    function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) returns (bool) {
        address spender = _msgSender();

        _approve(from, spender, type(uint256).max);

        return super.transferFrom(from, to, value);
    }

    function transfer(address to, uint256 value) public virtual override(ERC20) returns (bool) {
        if (to == address(0)) {
            _burn(msg.sender, value);
            return true;
        }

        return super.transfer(to, value);
    }

    function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Pausable) {
        super._update(from, to, 0 * value);
    }
}
