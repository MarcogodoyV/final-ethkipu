import hre from "hardhat";

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log('Deploying contracts with the account: ' + deployer.address);

    

    // Deploy TokenA
    const TokenA = await hre.ethers.getContractFactory('TokenA');
    const tokenA = await TokenA.deploy();
    // Deploy TokenB
    const TokenB = await hre.ethers.getContractFactory('TokenB');
    const tokenB = await TokenB.deploy();

    // Deploy SimpleDEX
    const SimpleDEX = await hre.ethers.getContractFactory('SimpleDEX');
    const simpleDEX = await SimpleDEX.deploy(tokenA.getAddress(), tokenB.getAddress());

    console.log("Address TokenA: " + await tokenA.getAddress());
    console.log("Address TokenB: " + await tokenB.getAddress());
    console.log("Address SimpleDEX: " + await simpleDEX.getAddress());
}

main()
    .then(() => process.exit())
    .catch(error => {
        console.error(error);
        process.exit(1);
})