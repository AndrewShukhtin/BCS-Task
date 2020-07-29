// SPDX-License-Identifier: MIT
pragma solidity ^0.5.10;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract BaumanToken is ERC20Detailed, ERC20, Ownable {
  uint256 private _initialSupply;

  constructor () ERC20Detailed("BaumanCoin", "BMC", 18) public {
    address newOwner = 0x0A46bb47D132DCA0Cefbe5fEEBf078635D24c64D;
    _transferOwnership(newOwner);
    mint(newOwner, _initialSupply);
  }

  function burn(uint256 amount) public {
    _burn(_msgSender(), amount);
  }

  function burnFrom(address account, uint256 amount) public onlyOwner {
    _burnFrom(account, amount);
  }

  function mint(address account, uint256 amount) public onlyOwner {
    _mint(account, amount);
  }


}