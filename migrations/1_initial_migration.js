// Make sure the IkmToken contract is included by requireing it.
const IkmToken = artifacts.require("IkmToken");

// THis is an async function, it will accept the Deployer account, the network, and eventual accounts.
module.exports = async function (deployer, network, accounts) {
  // await while we deploy the IkmToken
  await deployer.deploy(IkmToken, "IkmToken", "DVTK", 18, 5000000);
  const ikmToken = await IkmToken.deployed()

};
