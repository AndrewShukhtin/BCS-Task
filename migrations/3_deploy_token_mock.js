const BaumanTokenMock = artifacts.require("./BaumanTokenMock.sol");

module.exports = function(deployer) {
  deployer.deploy(BaumanTokenMock);
}