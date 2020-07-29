// SPDX-License-Identifier: MIT
pragma solidity ^0.5.10;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

//
// NOTE: Данный смарт-контракт имеест все свойства смарт-контракта
// BaumanToken заисключением того факта, что владельцем данного
// токена является тот, кто его задеплоил. Это сделано для того,
// чтобы протестировать смарт-контракт на локальном блокчейне.
//

contract BaumanTokenMock is ERC20Detailed, ERC20, Ownable {
  uint256 private _initialSupply;

  constructor () ERC20Detailed("BaumanCoin", "BMC", 18) public {
    address owner = _msgSender();

    _transferOwnership(owner);

    _initialSupply = 0;

    _mint(owner, _initialSupply);
  }

  function burn(uint256 amount) public {
    _burn(_msgSender(), amount);
  }

  function burnFrom(address account, uint256 amount) public onlyOwner {
    _burn(account, amount);
  }

  function mint(address account, uint256 amount) public onlyOwner {
    _mint(account, amount);
  }

  function transferFrom(address sender, address recipient, uint256 amount) public onlyOwner returns (bool) {
    return super.transferFrom(sender, recipient, amount);
  }
}