const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
const { Contract, BigNumber } = require("ethers");

describe("Box (proxy) V2", function () {
    let box;
    let boxV2;
  
    beforeEach(async function () {
      const Box = await ethers.getContractFactory("Box")
      const BoxV2 = await ethers.getContractFactory("BoxV2")
  
      box = await upgrades.deployProxy(Box, [42], {initializer: 'store'})
      boxV2 = await upgrades.upgradeProxy(box.address, BoxV2)
    })
  
    it("should retrieve value previously stored and increment correctly", async function () {
      expect(await boxV2.retrieve()).to.equal(BigNumber.from('42'))
  
      await boxV2.increment()
      //result = 42 + 1 = 43
      expect(await boxV2.retrieve()).to.equal(BigNumber.from('43'))
  
      await boxV2.store(100)
      expect(await boxV2.retrieve()).to.equal(BigNumber.from('100'))
    })
  
  })