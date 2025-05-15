// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CannotFlipIfNotOwner();

    string private constant NFT_NAME = "Mood NFT";
    string private constant NFT_SYMBOL = "MN";
    string private constant JSON_BASE64_PREFIX =
        "data:application/json;base64,";

    uint256 private s_tokenCounter;
    string private s_sadSVGImageURI;
    string private s_happySVGImageURI;

    enum Mood {
        SAD,
        HAPPY
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory _sadSVGImageURI,
        string memory _happySVGImageURI
    ) ERC721(NFT_NAME, NFT_SYMBOL) {
        s_tokenCounter = 0;
        s_sadSVGImageURI = _sadSVGImageURI;
        s_happySVGImageURI = _happySVGImageURI;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function getImageURI(uint256 tokenId) public view returns (string memory) {
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            return s_happySVGImageURI;
        }
        return s_sadSVGImageURI;
    }

    function _baseURI() internal pure override returns (string memory) {
        return JSON_BASE64_PREFIX;
    }

    function flipMood(uint256 tokenId) public {
        if (msg.sender != _ownerOf(tokenId)) {
            revert MoodNft__CannotFlipIfNotOwner();
        }
        Mood currentMood = s_tokenIdToMood[tokenId];
        s_tokenIdToMood[tokenId] = currentMood == Mood.HAPPY
            ? Mood.SAD
            : Mood.HAPPY;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        bytes memory inputBytes = bytes(
            abi.encodePacked(
                '{ "name" : ',
                name(),
                ",",
                '"description" : "An NFT that reflects the mood of the owner, 100% on Chain!",'
                '"attributes" : [{"trait_type" : "moodiness", "value" : "100"}],'
                '"image" : ',
                getImageURI(tokenId),
                '"}'
            )
        );
        string memory encoded = Base64.encode(inputBytes);
        return string.concat(_baseURI(), encoded);
    }

    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}
