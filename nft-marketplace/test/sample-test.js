const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarket", function () {
  it("Should create and execute a marketplace sale", async function () {
    const Marketplace = await ethers.getContractFactory('Marketplace');
    const market = await Marketplace.deploy();
    await market.deployed();
    const marketplaceAddress = market.address;

    const NFT = await ethers.getContractFactory('NFT')
    const nft = await NFT.deploy(marketplaceAddress);
    await nft.deployed();

    const nftContractAddress = nft.address;

    let listingPrice = await market.getListingPrice();
    listingPrice = listingPrice.toString()

    const auctionPrice = ethers.utils.parseUnits('100', 'ether');

    await nft.createToken('');
    await nft.createToken('');

    await market.createItem(nftContractAddress, 1, auctionPrice, { value: listingPrice })
    await market.createItem(nftContractAddress, 2, auctionPrice, { value: listingPrice })

    const [_, buyerAddress] = await ethers.getSigners();
    await market.connect(buyerAddress).createSale(nftContractAddress, 1, {value: auctionPrice});

    let items = await market.fetchUnsoldItems();

    items = await Promise.all(items.map(async i => {
      const tokenUri = await nft.tokenURI(i.tokenId)
      return item = {
        price: i.price.toString(),
        tokenId: i.tokenId.toString(),
        seller: i.seller,
        owner: i.owner,
        tokenUri
      }
    }))

    console.log('items', items)
  });
});
