//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

//import the helper functions that converts svg and json to base64
import { Base64 } from "./libraries/Base64.sol";

contract WhiskeyNFT is ERC721URIStorage {
    //inherited from OpenZeppelin to keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    //Create arrays from which our randomness will be derived
    string[] firstWords = ["DOG", "GOAT", "DONKEY", "CAT", "PORCUPINE", "RHINOCEROS", "EMU", "PANDA", "SHEEP", "GIRAFFE", "LION", "MARMOSET", "MEERKAT", "MACAW", "RATTLESNAKE", "ARMADILLO"];
    string[] secondWords = ["FOOTBALL", "SOCCER", "HOCKEY", "LACROSSE", "BASEBALL", "BASKETBALL", "RUNNING", "CYCLING", "BOXING", "RUGBY", "SOFTBALL", "RACING", "ARMWRESTLING", "DISCUS", "FRISBEE", "PICKLEBALL"];
    string[] thirdWords = ["BLUES", "ROCK", "SWING", "EDM", "COUNTRY", "OPERA", "HIPHOP", "METAL", "RAP", "KPOP", "AFROBEAT", "FOLK", "FLAMENCO", "ACAPELLA", "BLUEGRASS", "DISCO"];

    //pass the name of our NFTs token and its symbol
    constructor() ERC721 ("WhiskeyNFT", "DRINK") {
        console.log("Keep grinding. You got this!");
    }

    //Function to randomly pick a word from each array
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        //seed the random generator
        uint rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        //Squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    //funtion user will hit to get NFT
    function makeWhiskeyNFT() public {
        //get current tokenId, starts at 0
        uint256 newItemId = _tokenIds.current();

        //randomly select one word from each of the arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        //concatenate it all together and close the <text> and <svg> tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        //format and map the JSON metadata and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        //set the title of the nft to that of the randomly generated word
                        combinedWord,
                        '", "description": "It\'s hip to be square", "image": "data:image/svg+xml;base64',
                        //Add data:image/svg+xml;base64 and then append our base64 encode our svg
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        //prepend data:application/json;base64 to json
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
            );

        console.log("\n-----------------");
        console.log(finalTokenUri);
        console.log("-----------------\n");

        //mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        //set the NFTs data
        _setTokenURI(newItemId, finalTokenUri);

        //Increment the counter for when the next NFT is minted
        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}