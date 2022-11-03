const hre = require('hardhat');
require('@nomiclabs/hardhat-etherscan');

async function main() {
    await hre.run('verify:verify', {
        address: "0x23F7391cdAaE4A16A95A2619A536d920781B51Bd",
        constructorArguments: [],
    });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});