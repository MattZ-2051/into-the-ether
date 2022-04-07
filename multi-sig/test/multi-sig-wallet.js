const { assert } = require("chai");
const chai = require("chai");
chai.use(require("chai-as-promised"));

const MultiSigWallet = artifacts.require("MultiSignatureWallet");

const expect = chai.expect;

contract("MultiSigWallet", (accounts) => {
  const owners = [accounts[0], accounts[1], accounts[2]];
  const NUM_CONF_REQ = 2;

  describe("execute transaction", () => {
    let wallet;
    beforeEach(async () => {
      wallet = await MultiSigWallet.new(owners, NUM_CONF_REQ);
      const to = owners[0];
      const value = 0;
      const data = "0x0";

      await wallet.submitTransaction(to, value, data);
      await wallet.confirmTransaction(0, { from: owners[0] });
      await wallet.confirmTransaction(0, { from: owners[1] });
    });

    it("should execute", async () => {
      const response = await wallet.executeTransaction(0, { from: owners[0] });
      const { logs } = response;

      assert.equal(logs[0].event, "ExecuteTransaction");
      assert.equal(logs[0].args.owner, owners[0]);
      assert.equal(logs[0].args.txIndex, 0);

      const tx = await wallet.getTransaction(0);
      assert.equal(tx.executed, true);
    });

    it("should reject if already executed", async () => {

      await wallet.executeTransaction(0, { from: owners[0]});
      await expect(wallet.executeTransaction(0, {from: owners[0]})).to.be.rejected
    });
  });
});
