import { ethers } from "ethers";
import { useState, useEffect } from "react";
import axios from "axios";
import Web3Modal from "web3modal";
import { nftAddress, marketplaceAddress } from "../config";

import NftJson from "../artifacts/contracts/Nft.sol/NFT.json";
import MarketplaceJson from "../artifacts/contracts/Marketplace.sol/Marketplace.json";

export default function Home() {
  const [nfts, setNfts] = useState([]);
  const [loadingState, setLoadingState] = useState("not-loaded");

  useEffect(() => {
    loadNfts();
  }, []);

  const loadNfts = async () => {
    const provider = new ethers.providers.JsonRpcProvider();
    const tokenContract = new ethers.Contract(
      nftAddress,
      NftJson.abi,
      provider
    );
    const marketContract = new ethers.Contract(
      marketplaceAddress,
      MarketplaceJson.abi,
      provider
    );
    const data = await marketContract.fetchUnsoldItems();

    try {
      const items = await Promise.all(
        data.map(async (item) => {
          const tokenUri = await tokenContract.tokenURI(item.tokenId);
          const meta = await axios.get(tokenUri);
          let price = ethers.utils.formatUnits(items.price.toString(), "ether");
          return {
            price,
            tokenId: item.tokenId.toNumber(),
            seller: item.seller,
            owner: item.owner,
            image: meta.data.image,
            name: meta.data.name,
            description: meta.deta.description,
          };
        })
      );

      setNfts(items);
      setLoadingState("loaded");
    } catch {
      setLoadingState("error fetching items");
    }
  };

  const buyNfft = async (nft) => {
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.provider.Web3Provider(connection);

    const signer = provider.getSigner();
    const contract = new ethers.Contract(
      marketplaceAddress,
      MarketplaceJson.abi,
      signer
    );

    const price = ethers.utils.parseUnits(nft.price.toString(), "ether");
    const transaction = await contract.createSale(nftAddress, nft.tokenId, {
      value: price,
    });

    await transaction.wait();
    loadNfts();
  };

  if (loadingState === "loaded" && !nfts.length)
    return <h1 className="px-20 py-10 text-3xl">No items in marketplace</h1>;

  return (
    <div className="flex justify-center">
      <div className="px-4 max-w-7xl">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-4">
          {nfts.map((nft, index) => {
            <div
              key={index}
              className="border shadow rounded-xl overflow-hidden"
            >
              <img src={nft.image} alt="nft-img" />
              <div className="p-4">
                <p
                  style={{ height: "64px" }}
                  className="text-2xl font-semibold"
                >
                  {nft.name}
                </p>
                <div style={{ height: "70px", overflow: "hidden" }}>
                  <p className="text-gray-400">{nft.description}</p>
                </div>
              </div>
              <div className="p-4 bg-black">
                <p className="text-2xl mb-4 font-bold text-white">
                  {nft.price} Matic
                </p>
                <button
                  className="w-full bg-pink-500 text-white font-bold py-2 px-12 rounded"
                  onClick={() => buyNft(nft)}
                >
                  Buy NFT
                </button>
              </div>
            </div>;
          })}
        </div>
      </div>
    </div>
  );
}
