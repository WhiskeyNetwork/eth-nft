const main = async() => {
    const nftContractFactory = await hre.ethers.getContractFactory('WhiskeyNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    //call the function to mint NFT in WhiskeyNFT.sol
    let txn = await nftContract.makeWhiskeyNFT()
    //wait for it to be mined
    await txn.wait()
    console.log("Minted NFT #1");

    //Mint another NFT just for fun
    // txn = await nftContract.makeWhiskeyNFT();
    // await txn.wait()
    // console.log("Minted NFT #2");
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (e) {
        console.log(e);
        process.exit(1);
    }
};

runMain();