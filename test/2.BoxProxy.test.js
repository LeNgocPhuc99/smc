const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
const { Contract, BigNumber } = require("ethers");

describe("Box (proxy)", function () {
    let box;
  
    beforeEach(async function () {
      const Box = await ethers.getContractFactory("Box")
      //initilize with 42
      box = await upgrades.deployProxy(Box, [42], {initializer: 'store'})
      })
  
    it("should retrieve value previously stored", async function () {    
      // console.log(box.address," box(proxy)")
      // console.log(await upgrades.erc1967.getImplementationAddress(box.address)," getImplementationAddress")
      // console.log(await upgrades.erc1967.getAdminAddress(box.address), " getAdminAddress")   
  
      expect(await box.retrieve()).to.equal(BigNumber.from('42'))
  
      await box.store(100)
      expect(await box.retrieve()).to.equal(BigNumber.from('100'))
    })
  
  })