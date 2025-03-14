// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract VoiceVault is ERC721, Pausable, Ownable, ReentrancyGuard{
    using Strings for uint256;

    string public defaultURI = "";
    string private baseURI = "";

    string public cid;

    address public manager;
    uint256 public tokenMinted;
    uint256 public price = 0.001 ether;

    event TokenMinted(uint256 tokenId, address to);

    modifier onlyOwnerOrManager() {
        require((owner() == msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    constructor(address initialOwner, string memory _cid, string memory _name, 
        string memory _symbol, string memory _baseUri) ERC721(_name, _symbol) Ownable(initialOwner){
        manager = address(0x07C920eA4A1aa50c8bE40c910d7c4981D135272B);
        cid = _cid;
        baseURI = _baseUri;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string calldata _baseuri) public onlyOwnerOrManager {
		baseURI = _baseuri;
	}

    function setDefaultRI(string calldata _defaultURI) public onlyOwnerOrManager {
		defaultURI = _defaultURI;
	}

    function setManager(address _manager) public onlyOwnerOrManager {
        manager = _manager;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return baseURI;
    }

    function mint() public payable whenNotPaused nonReentrant returns (uint256){
        //require(price == msg.value, "Incorrect Funds Sent" ); // Amount sent should be equal to the price
        
        uint256 currentTokenId = tokenMinted;
        
        _safeMint(msg.sender, currentTokenId);
        tokenMinted++;
        emit TokenMinted(currentTokenId, msg.sender);
        return currentTokenId;
    }

    function mintInternal(address user) public whenNotPaused nonReentrant returns (uint256){
        uint256 currentTokenId = tokenMinted;
        _safeMint(user, currentTokenId);
        tokenMinted++;
        emit TokenMinted(currentTokenId, user);
        return currentTokenId;
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721)
        returns (bool) {
        // Supports the following `interfaceId`s:
        // - IERC165: 0x01ffc9a7
        // - IERC721: 0x80ac58cd
        // - IERC721Metadata: 0x5b5e139f
        // - IERC2981: 0x2a55205a
        return
            ERC721.supportsInterface(interfaceId);
    }

    function pause() public onlyOwnerOrManager nonReentrant {
        _pause();
    }

    function unpause() public onlyOwnerOrManager nonReentrant {
        _unpause();
    }

    function setPrice(uint256 newPrice) public onlyOwnerOrManager {
        require(newPrice > 0, "Price can not be zero");
        price = newPrice;
    }

    function setCid(string memory _cid) public onlyOwnerOrManager {
        cid = _cid;
    }

    // Override standard transfer functions to disable them
    function transferFrom(address, address, uint256) public pure override {
        revert("Transfers not allowed");
    }

    function safeTransferFrom(address, address, uint256, bytes memory) public pure override {
        revert("Transfers not allowed");
    }

    function withdraw() public onlyOwner nonReentrant{
        require(owner() != address(0),"Owner Address is NULL");
        (bool sent1, ) = owner().call{value: address(this).balance}("");
        require(sent1, "Failed to withdraw");
    }

}