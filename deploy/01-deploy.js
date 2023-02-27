const { network, ethers, run } = require("hardhat")
// const { verify } = require("../utils/verify")

const { developmentChains, VERIFICATION_BLOCK_CONFIRMATIONS } = require("../helper-hardhat-config")


module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId;

    const args = [
        "70000000000000000000",//wei
        "ERECOIN",
        "ERE",
        "1000000000000000000000",//wei
        "5000000",
        "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e"
    ]
    const waitBlockConfirmations = developmentChains.includes(network.name)
        ? 1
        : VERIFICATION_BLOCK_CONFIRMATIONS

    const ERC20Token = await deploy("CrowdFunding", {
        from: deployer,
        log: true,
        args: args,
        waitConfirmations: waitBlockConfirmations
    })

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...")
        await verify(ERC20Token.address, args);
    }

}
const verify = async (contractAddress, args) => {
    console.log("Verifying contract...")
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        })
    } catch (e) {
        if (e.message.toLowerCase().includes("already verified")) {
            console.log("Already verified!")
        } else {
            console.log(e)
        }
    }
}
module.exports.tags = ["all", "ERC20Token"]