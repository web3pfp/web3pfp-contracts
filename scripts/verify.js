const hre = require('hardhat');
require('@nomiclabs/hardhat-etherscan');

async function main() {
    await hre.run('verify:verify', {
        address: "0x2c699AE45cBfA9a6b5c5dd7Ec51051b491e56C73",
        constructorArguments: [],
    });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});