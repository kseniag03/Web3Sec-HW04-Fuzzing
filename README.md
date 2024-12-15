# Web3Sec-HW04-Fuzzing

## Tools
- Foundry
- Echidna
- Medusa

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

medusa fuzz --target-contracts test/ERC20External.sol --config test/medusa.yaml // ???
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

