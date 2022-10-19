require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "ropsten",
  networks: {
    ropsten: {
      url: `https://ropsten.infura.io/v3/${process.env.ROPSTEN_LINK_KEY}`,
      accounts: [process.env.PRIVATE_KEY_MAIN]
    },
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.MUMBAI_LINK_KEY}`,
      accounts: [process.env.PRIVATE_KEY_MAIN],
    },
    polygon: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.POLYGON_LINK_KEY}`,
      accounts: [process.env.PRIVATE_KEY_SECONDARY],
    },
  },
  etherscan: {
    apiKey: {
      ropsten: process.env.ETHERSCAN_API_KEY,
      customChains: [
        {
          network: "rinkeby",
          chainId: 4,
          urls: {
            apiURL: "https://api-rinkeby.etherscan.io/api",
            browserURL: "https://rinkeby.etherscan.io"
          }
        }
      ],
      polygon: process.env.POLYGON_API_KEY,
      polygonMumbai: process.env.POLYGON_API_KEY,
    },
  },
};
