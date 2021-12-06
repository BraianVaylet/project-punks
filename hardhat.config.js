require("@nomiclabs/hardhat-waffle");
require('dotenv').config()

const INFURA_PROJECT_ID_RINKEBY = process.env.INFURA_PROJECT_ID_RINKEBY;
const PRIVATE_KEY = process.env.DEPLOYER_SIGNER_PRIVATE_KEY;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_PROJECT_ID_RINKEBY}`,
      accounts: [PRIVATE_KEY]
    }
  }
};
