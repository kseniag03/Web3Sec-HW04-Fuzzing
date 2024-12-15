# Web3Sec-HW04-Fuzzing

## Tools
- Foundry
- Echidna
- Medusa // не поддалось

## Install
```bash
forge install
forge build
```

## Testing
```bash
forge clean
forge build

echidna test/ERC20Internal.sol --contract ERC20Internal --config test/echidna.yaml
echidna test/ERC20External.sol --contract ERC20External --config test/echidna-ext.yaml

medusa fuzz --target-contracts test/ERC20External.sol --config test/medusa.yaml // анлаки, не работает
```

## Report
1. test_ERC20(external)_userBalanceNotHigherThanSupply() (аналогично для test_ERC20(external)_userBalancesLessThanTotalSupply()):
    1. User balance higher than total supply, Sum of user balances are greater than total supply
    2. т.к. totalSupply всегда возвращает 10, нарушается связь между балансами пользователей и общим кол-вом выпущенных токенов
    3. 
```sol
    function totalSupply() public pure virtual override(ERC20) returns (uint256) {
        return 10;
    }
```

2. test_ERC20(external)_mintTokens(address,uint256):
    1. Mint failed to update total supply
    2. т.к. totalSupply не отражает изменения состояния, результат mint некорректный
    3. 
```sol
    function totalSupply() public pure virtual override(ERC20) returns (uint256) {
        return 10;
    }
```

3. test_ERC20(external)_burn(uint256):
    1. Total supply incorrect after burn
    2. т.к. totalSupply остается равным 10, независимо от того, сколько токенов было сожжено
    3. 
```sol
    function totalSupply() public pure virtual override(ERC20) returns (uint256) {
        return 10;
    }
```

4. test_ERC20(external)_mintTokens(address,uint256):
    1. Mint failed to update target balance
    2. при обновлении баланса происходит его обнуление (вот прикольный прикол, однако), поэтому результат mint некорректный
    3. изменение закомментировано, чтобы при запуске фаззинга оно не перекрывало остальные фейлы (6 для internal и 5 для external)
```sol
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Token) {
        super._update(from, to, 0 * value);
    }
```

5. test_ERC20_spendAllowanceAfterTransfer(address,uint256):
    1. Allowance not updated correctly
    2. бесконечное разрешение на кол-во переведённых токенов (падает только в internal, т.к. в external не проверяется изменение allowance после вызова transferFrom, потому что конечный результат (перевод токенов) остаётся корректным)
    3. 
```sol
    function transferFrom(address from, address to, uint256 value) public override(ERC20, ERC20Token) returns (bool) {
        address spender = _msgSender();

        _approve(from, spender, type(uint256).max);

        return super.transferFrom(from, to, value);
    }
```

6. test_ERC20(external)_transferToZeroAddress() и test_ERC20(external)_transfer(address,uint256):
    1. Successful transfer to address zero, Wrong target balance after transfer
    2. вместо исключения происходит вызов функции сжигания: она корректно уменьшает баланс отправителя, но допускает перевод на address(0)
    3. 
```sol
    function transfer(address to, uint256 value) public virtual override(ERC20) returns (bool) {
        if (to == address(0)) {
            _burn(msg.sender, value);
            return true;
        }

        return super.transfer(to, value);
    }
```
