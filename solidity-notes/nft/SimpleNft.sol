// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OpenZepNft is ERC721, Ownable {
    uint256 public tokenSupply = 0;
    uint256 public MAX_SUPPLY = 5;

    constructor() ERC721("MyNFT", "MN") {}

    function mint() external {
        require(tokenSupply < MAX_SUPPLY, "max supply reached");
        _mint(msg.sender, tokenId);
        tokenSupply++;
    }

    // function _baseUri() overload baseUri and add ipfs link

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
