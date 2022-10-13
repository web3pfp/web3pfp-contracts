// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

interface non_standard_IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external ;

    function transfer(
        address to,
        uint256 amount
    ) external ;

    function decimals() external returns (uint8);
}

contract Web3PFP is ERC721URIStorage, Ownable {
    address private _owner;
    address private _wallet;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Web3PFP", "PFP") {
        _owner = msg.sender;
    }

    event NFTCreated(address owner, uint256 tokenID);
    event NFTUpdated(address owner, uint256 tokenID);
    event TransferSent(address _from, uint _amount);

    uint256 public MINT_AMOUNT = 30;
    uint256 public UPDATE_AMOUNT = 3;

    function changeMintAmount(uint256 value) public onlyOwner isOwner() {
        MINT_AMOUNT = value;
    }

    function changeUpdateAmount(uint256 value) public onlyOwner isOwner() {
        UPDATE_AMOUNT = value;
    }

    function mintNFT(address recipient, string memory tokenURI, uint256 amount, address tokenAddress)
    public
    returns (uint256)
    {
        _tokenIds.increment();
        console.log('MINT_AMOUNT', MINT_AMOUNT);

        uint decimals = non_standard_IERC20(tokenAddress).decimals();
        console.log('amount', amount);
        uint price = (MINT_AMOUNT * (10 ** decimals)) / 10;
        console.log('price', price);

        require(_tokenIds.current() > 0 && _tokenIds.current() < 21000, "Exceeds token supply");
        require(IERC20(tokenAddress).allowance(msg.sender, address(this)) >= price, "not approved");

        non_standard_IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            amount
        );

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        console.log('newItemId', newItemId);
        emit NFTCreated(msg.sender, newItemId);
        return newItemId;
    }

    function updateNFT(address tokenAddress, uint256 amount)
    public
    returns (uint256)
    {
        uint8 decimals = non_standard_IERC20(tokenAddress).decimals();
        uint price = (UPDATE_AMOUNT * (10 ** decimals)) / 10;

        console.log('amount', amount);
        console.log('price', price);
        console.log('UPDATE_AMOUNT', UPDATE_AMOUNT);
        require(IERC20(tokenAddress).allowance(msg.sender, address(this)) >= price, "not approved");

        non_standard_IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        uint256 itemId = _tokenIds.current();
        emit NFTUpdated(msg.sender, itemId);
        return itemId;
    }

    function withdraw(address tokenAddress, uint256 amount) external onlyOwner {

        IERC20 token = IERC20(tokenAddress);

        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "balance is low");

        non_standard_IERC20(tokenAddress).transfer(
            msg.sender,
            amount
        );
        emit TransferSent(msg.sender, amount);
    }

    modifier isOwner() {
        require(_owner == msg.sender, "Web3PFP: not owner");
        _;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://ipfs.pragmaticdlt.com/ipns/";
    }
}