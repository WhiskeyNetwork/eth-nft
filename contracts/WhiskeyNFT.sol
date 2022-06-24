//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

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

        //concatenate it all together and close the <text> and <svg> tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
        console.log("\n-----------------");
        console.log(finalSvg);
        console.log("-----------------\n");

        //mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        //set the NFTs data
        _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStSWEJwWTB4dmNtUklZVzFpZFhKblpYSThMM1JsZUhRK0Nqd3ZjM1puUGc9PSIsCiAgICAiYXR0cmlidXRlcyI6IFsKICAgICAgewogICAgICAgICJ0cmFpdF90eXBlIjogIkJhY2tncm91bmQiLAogICAgICAgICJ2YWx1ZSI6ICJCbGFjayIKICAgICAgfSwKICAgICAgewogICAgICAgICJ0cmFpdF90eXBlIjogIlRleHQgY29sb3IiLAogICAgICAgICJ2YWx1ZSI6ICJXaGl0ZSIKICAgICAgfQogICAgXQp9Cg==");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        //Increment th counter for when the next NFT is minted
        _tokenIds.increment();
    }
}