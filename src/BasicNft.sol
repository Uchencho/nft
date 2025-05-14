// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIDToURI;

    constructor() ERC721("BasicNFT", "B-NFT") {
        s_tokenCounter = 0;
    }

    function mintNFT(string memory _tokenURI) public {
        s_tokenIDToURI[s_tokenCounter] = _tokenURI;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenID
    ) public view override returns (string memory) {
        return s_tokenIDToURI[tokenID];
    }
}
