// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFTCreation {
    string public name = "NFT Creation";
    string public symbol = "NFTC";
    
    uint256 public totalSupply;
    string private _baseTokenURI;

    mapping(uint256 => address) public tokenOwner;
    mapping(uint256 => string) public tokenURI;
    mapping(address => uint256) public ownedTokensCount;
    mapping(uint256 => address) public tokenApprovals;

    // Event to emit when a new NFT is created
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    constructor(string memory baseTokenURI) {
        _baseTokenURI = baseTokenURI;
        totalSupply = 0;
    }

    // Function to create a new NFT
    function createNFT(address to, string memory uri) public returns (uint256) {
        uint256 tokenId = totalSupply + 1;
        tokenOwner[tokenId] = to;
        tokenURI[tokenId] = uri;
        ownedTokensCount[to]++;
        totalSupply++;

        emit Transfer(address(0), to, tokenId);

        return tokenId;
    }

    // Function to get the owner of an NFT by token ID
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = tokenOwner[tokenId];
        require(owner != address(0), "NFT not minted yet");
        return owner;
    }

    // Function to transfer an NFT from one address to another
    function transfer(address to, uint256 tokenId) public {
        address owner = tokenOwner[tokenId];
        require(owner == msg.sender, "Only the owner can transfer");
        require(to != address(0), "Invalid address");

        tokenOwner[tokenId] = to;
        ownedTokensCount[msg.sender]--;
        ownedTokensCount[to]++;

        emit Transfer(msg.sender, to, tokenId);
    }

    // Function to approve an address to manage the NFT on behalf of the owner
    function approve(address to, uint256 tokenId) public {
        address owner = tokenOwner[tokenId];
        require(owner == msg.sender, "Only the owner can approve");

        tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    // Function to get the token's metadata URI


    // Function to change the base URI for token metadata
    function setBaseURI(string memory baseTokenURI) public {
        _baseTokenURI = baseTokenURI;
    }

    // Utility function to convert uint to string
    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        str = string(bstr);
    }
}
