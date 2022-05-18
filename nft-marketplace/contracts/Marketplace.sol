// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _itemIds;
  Counters.Counter private _itemsSold;

  address payable owner;
  uint256 listingPrice = 0.025 ether;

  event ItemCreated(uint itemId, address nftContract, uint256 tokenId, address seller, address owner, uint256 price, bool sold);

  constructor() {
    owner = payable(msg.sender);
  }

  struct MarketItem {
    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
  }

  mapping(uint256 => MarketItem) private idToMarketItem;

  function getListingPrice() public view returns (uint256) {
    return listingPrice;
  }

  function createItem(address nftContract, uint256 tokenId, uint256 price) public payable nonReentrant {
    require(price > 0, "Price must be greater than 0!");
    require(msg.value == listingPrice, "Price must be equal to listing price");

    _itemIds.increment();
    uint256 itemId = _itemIds.current();

    idToMarketItem[itemId] = MarketItem(itemId, nftContract, tokenId, payable(msg.sender), payable(address(0)), price, false);

    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    emit ItemCreated(itemId, nftContract, tokenId, msg.sender, address(0), price, false);
  }

  function createSale(address nftContract, uint256 itemId) public payable nonReentrant {
    uint price = idToMarketItem[itemId].price;
    uint tokenId = idToMarketItem[itemId].tokenId;

    require(msg.value == price, "Please submit the asking price in order to complete purchase");

    idToMarketItem[itemId].seller.transfer(msg.value);
    IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);

    idToMarketItem[itemId].owner = payable(msg.sender);
    idToMarketItem[itemId].sold = true;
    _itemsSold.increment();
    payable(owner).transfer(listingPrice);

  }
}
