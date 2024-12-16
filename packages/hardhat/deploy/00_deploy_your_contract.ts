import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

/**
 * Deploys TokenA, TokenB, and SimpleDEX contracts using the deployer account.
 * 
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy, log } = hre.deployments;

  // Deploy TokenA
  const tokenADeployment = await deploy("TokenA", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  log(`TokenA deployed at: ${tokenADeployment.address}`);

  // Deploy TokenB
  const tokenBDeployment = await deploy("TokenB", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  log(`TokenB deployed at: ${tokenBDeployment.address}`);

  // Deploy SimpleDEX with addresses of TokenA and TokenB
  const simpleDEXDeployment = await deploy("SimpleDEX", {
    from: deployer,
    args: [tokenADeployment.address, tokenBDeployment.address],
    log: true,
    autoMine: true,
  });

  log(`SimpleDEX deployed at: ${simpleDEXDeployment.address}`);
};

export default deployYourContract;

deployYourContract.tags = ["SimpleDEX"];
