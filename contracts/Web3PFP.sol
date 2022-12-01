//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";


contract LittleDrawlingsNFT is ERC721URIStorage, Ownable {
    address private _owner;
    address private _wallet;
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    constructor() ERC721("LittleDrawlingsNFT", "NFT") {
        _owner = msg.sender;
    }

    event NFTCreated(address owner, uint256 tokenID);
    event NFTUpdated(address owner, uint256 tokenID);
    event TransferSent(address _from, uint _amount);

    uint256 public MINT_AMOUNT = 0.00021 ether;
    uint256 public UPDATE_INFO_AMOUNT = 0.000025 ether;
    uint256 public UPDATE_IMAGE_AMOUNT = 0.00000625 ether;

    function changeAmount(uint256 value) public isOwner() {
        MINT_AMOUNT = value;
    }

    function mintNFT(address recipient, string memory tokenURI)
    public
    payable
    returns (uint256)
    {
        _tokenIds.increment();
        console.log('MINT_AMOUNT', MINT_AMOUNT);
        require(MINT_AMOUNT == (msg.value), "invalid amount");
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        emit NFTCreated(msg.sender, newItemId);
        return newItemId;
    }

    function updateInfo(uint256 tokenID) public payable {
        require(msg.value == UPDATE_INFO_AMOUNT, "invalid amount");
        emit NFTUpdated(msg.sender, tokenID);
    }

    function updateImage(uint256 tokenID) public payable {
        require(msg.value == UPDATE_IMAGE_AMOUNT, "invalid amount");
        emit NFTUpdated(msg.sender, tokenID);
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    modifier isOwner() {
        require(_owner == msg.sender, "LittleDrawlings: not owner");
        _;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "";
    }
}