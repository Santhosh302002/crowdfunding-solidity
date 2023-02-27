const { expect } = require("chai");
const { Contract } = require("ethers");
const { getNamedAccounts, ethers, network } = require("hardhat");

describe("Token contract", async function () {
    // global vars
    console.log("Testing");
    let Token;
    let oceanToken;
    let name = "ERECOIN";
    let sym = "ERE";
    let tokenCap = 100000000;
    let inital = 7000000;
    let tokenBlockReward = 50;
    let JsonRpcProvider;
    const args = [
        inital,
        name,
        sym,
        tokenCap,
        tokenBlockReward
    ]
    console.log(args);

    // const [owner, otherAccount] = await ethers.getSigners();
    // console.log(owner);
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    console.log(deployer)

    const ERC20Token = await deploy("ERC20Token", {
        from: deployer,
        log: true,
        args: args,
        waitConfirmations: waitBlockConfirmations || 1
    })


    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        console.log("Hi")
        await deployments.fixture(["all"]) // Deploys modules with the tags "mocks" and "raffle"
        Contract = await ethers.getContractAt("ERC20Token");
        console.log(Contract);
    });
    // it("Owner", async () => {
    //     const balance = await oceanToken.totalSupply();
    //     expect(balance.to.equal(tokenCap));
    // })

});