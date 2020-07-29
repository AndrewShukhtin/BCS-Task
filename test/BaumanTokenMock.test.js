const BaumanTokenMock = artifacts.require("BaumanTokenMock");
const truffleAssert = require('truffle-assertions');

contract('BaumanTokenMock', (accounts) => {
  it("By default owner's account have zero balance", async () => {
    const baumanTokenMockInstance = await BaumanTokenMock.deployed();
    const balance = await baumanTokenMockInstance.balanceOf.call(accounts[0]);

    assert.equal(balance.valueOf(), 0, "0 wasn't in the owner's account");
  });

  it("accounts[0] should be the owner account", async () => {
    const baumanTokenMockInstance = await BaumanTokenMock.deployed();
    const isOwner = await baumanTokenMockInstance.isOwner.call();

    assert.equal(isOwner, true, "accounts[0] is not owner account");
  });

  it("Minted 100 BMC to owner's account", async () => {
    const baumanTokenMockInstance = await BaumanTokenMock.deployed();
    const amount = 100;
    await baumanTokenMockInstance.mint.sendTransaction(accounts[0], amount, {from : accounts[0]});

    const balanceOfOwner = await baumanTokenMockInstance.balanceOf.call(accounts[0]);
    assert.equal(balanceOfOwner.valueOf(), amount, "Owner's account should have 100 BMC");
  });

  it("Only owner can minting to another account", async () => {
    const baumanTokenMockInstance = await BaumanTokenMock.deployed();
    const amount = 100;

    await truffleAssert.reverts(
       baumanTokenMockInstance.mint(accounts[1], amount, {from : accounts[1]}),
      'Ownable: caller is not the owner'
    );
  });

  it("Owner can burn tokens from another account", async () => {
    const baumanTokenMockInstance = await BaumanTokenMock.deployed();
    const amount = 100;

    await baumanTokenMockInstance.mint.sendTransaction(accounts[1], amount, {from : accounts[0]});

    const burnedAmount = 50;

    await baumanTokenMockInstance.burnFrom.sendTransaction(accounts[1], burnedAmount);

    const balanceOfBurned = await baumanTokenMockInstance.balanceOf.call(accounts[1]);
    assert.equal(balanceOfBurned.valueOf(), amount - burnedAmount, "Second account should contain 50 BMC");
  });

  it("Only owner can burn tokens from another account", async () => {
    const baumanTokenMockInstance = await BaumanTokenMock.deployed();
    const amount = 100;

    await truffleAssert.reverts(
      baumanTokenMockInstance.burnFrom.sendTransaction(accounts[1], amount, {from : accounts[1]}),
      'Ownable: caller is not the owner'
    );
  });

  it("Everyone can burn own tokens", async () => {
    const baumanTokenMockInstance = await BaumanTokenMock.deployed();
    const amount = 100;

    await baumanTokenMockInstance.mint.sendTransaction(accounts[2], amount, {from : accounts[0]});

    const burnedAmount = 30;
    await baumanTokenMockInstance.burn.sendTransaction(burnedAmount, {from : accounts[2]});

    const balanceAfterBurn = await baumanTokenMockInstance.balanceOf.call(accounts[2]);

    assert.equal(balanceAfterBurn.valueOf(), amount - burnedAmount, "Expected 70 BMC after burning");
  });
});