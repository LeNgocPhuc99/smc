const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
const { Contract, BigNumber } = require("ethers");

describe("Box V2", function () {
    let boxV2;
  
    beforeEach(async function () {
      const BoxV2 = await ethers.getContractFactory("BoxV2")
      boxV2 = await BoxV2.deploy()
      await boxV2.deployed()
    });
  
    it("should retrievevalue previously stored", async function () {
      await boxV2.store(42)
      expect(await boxV2.retrieve()).to.equal(BigNumber.from('42'))
  
      await boxV2.store(100)
      expect(await boxV2.retrieve()).to.equal(BigNumber.from('100'))
    });
  
    it('should increment value correctly', async function () {
      await boxV2.store(42)
      await boxV2.increment()
      expect(await boxV2.retrieve()).to.equal(BigNumber.from('43'))
    })
  
  })