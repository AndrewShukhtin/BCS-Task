// SPDX-License-Identifier: MIT
pragma solidity ^0.5.10;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

//
// NOTE: Данный токен использует фреймворк OpenZeppelin.
// Особенностью этого фреймворка является то, что в нем
// уже реализованы стандарты токенов (ERC20, ...) и также
// данный фреймворк предоставляет наиболее распространненые
// паттерны поведения смарт-контрактов.
// OpenZeppelin version: 2.5.0
//

contract BaumanToken is ERC20Detailed, ERC20, Ownable {
  uint256 private _initialSupply;

  constructor () ERC20Detailed("BaumanCoin", "BMC", 18) public {
    // NOTE: Адрес владельца смарт-контракта известный по ТЗ.
    // HACK: Данный адрес был исправлен по требованию компилятора
    // с "0x0a46bb47d132dca0cefbe5feebf078635d24c64d" на вариант,
    // предоставленный ниже.
    address owner = 0x0A46bb47D132DCA0Cefbe5fEEBf078635D24c64D;

    // NOTE: Передаем адрес из ТЗ как новый адрес владельца смарт-контракта.
    _transferOwnership(owner);

    // NOTE: Изначальная эмиссия токенов -- любая.
    _initialSupply = 0;
  }

  //
  // NOTE: Данная функция позволяет сжигать токены у себя.
  // Функция таже выводит сожженые токены из оборота.
  //
  function burn(uint256 amount) public {
    _burn(_msgSender(), amount);
  }

  //
  // NOTE: Функция позволяет сжигать токены с указанного аккаунта
  // только владельцу смарт-контракта. Однако у данной функции есть проблемы,
  // как у функции описанной в стандарте, хотя она и соответсвует требованиям ТЗ.
  //
  function burnFrom(address account, uint256 amount) public onlyOwner {
    _burn(account, amount);
  }

  //
  // NOTE: Функция позволяет выпускать токены на указанный
  // аккаунт только владельцу смарт-контракта.
  //
  function mint(address account, uint256 amount) public onlyOwner {
    _mint(account, amount);
  }

  //
  // NOTE: По документации ERC20 функция не является обязательной, однако
  // дабы соотвествовать некоторым требованиям безопасности и обеспечить
  // соотвествие ТЗ, фунция доступна только владельцу смарт-контракта.
  // Полное описание функции см. https://docs.openzeppelin.com/contracts/2.x/api/token/erc20
  //
  function transferFrom(address sender, address recipient, uint256 amount) public onlyOwner returns (bool) {
    return super.transferFrom(sender, recipient, amount);
  }

  //
  // NOTE: Так же для задания было необходимо реализовать функцию первода
  // с любого адреса  на любой другой. Данная функция уже реализована
  // в фреймворке OpenZeppelin:
  // function transfer(address recipient, uint256 amount) public returns (bool);
  // релизация которой, просто наследуется от ERC20.
  //

  //
  // NOTE: Благодаря паттерну прав доступа "Ownable" реализована функция
  // function transferOwnership(address newOwner) public onlyOwner;
  // которая может передать права на "владение" смарт-контрактом
  // новому владьцу. Однако данной функций может пользоваться только
  // адрес-владлец, т.е. нового владьца может назначить только текуцщий
  // владец смарт контракта.
  //
}