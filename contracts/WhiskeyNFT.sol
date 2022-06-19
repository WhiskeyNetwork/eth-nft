//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract WhiskeyNFT is ERC721URIStorage {
    //inherited from OpenZeppelin to keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //pass the name of our NFTs token and its symbol
    constructor() ERC721 ("WhiskeyNFT", "DRINK") {
        console.log("Keep grinding. You got this!");
    }

    //funtion user will hit to get NFT
    function makeWhiskeyNFT() public {
        //get current tokenId, starts at 0
        uint256 newItemId = _tokenIds.current();

        //mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        //set the NFTs data
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/C3QL");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        //Increment th counter for when the next NFT is minted
        _tokenIds.increment();
    }
}