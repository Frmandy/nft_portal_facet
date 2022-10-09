// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

import {LibInput} from "@cartesi-rollups/libraries/LibInput.sol";


contract NFT is ERC721 {
    
    event CartesiGenNFTRequest(address, uint256, uint256, uint256, uint256);
    event CartesiGenNFTMint(address, uint256, uint256, uint256, uint256);

    uint256 public currentTokenId;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    function mintTo(address recipient) public payable returns (uint256) {
        uint256 newItemId = ++currentTokenId;
        _safeMint(recipient, newItemId);
        return newItemId;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        return Strings.toString(id);
    }

    bytes32 constant INPUT_HEADER = keccak256("gen_nft");

    function mintRequest(uint256 id, uint256 x, uint256 y, uint256 zoom) public {
        require(msg.sender != address(0), "INVALID_RECIPIENT");
        require(_ownerOf[id] != address(0), "ALREADY_MINTED");
        require(id > 0 && id <= 100, "ONLY_ONE_HUNDRED");

        // claimed
        _ownerOf[id] = msg.sender;

        // call the nft portal for Cartesi
        LibInput.DiamondStorage storage inputDS = LibInput.diamondStorage();

        bytes memory input = abi.encode(
            INPUT_HEADER,
            x, y, zoom, id
        );

        //inputDS.addInternalInput(input); // fails to compile

        emit CartesiGenNFTRequest(msg.sender, id, x, y, zoom);
    }

    // Cartesi callback from `mintRequest`
    function callbackMint(bytes calldata _data) internal {
        require(msg.sender == address(this), "only itself");

        (uint256 x, uint256 y, uint256 zoom, uint256 id) = abi
            .decode(_data, (address, address, uint256));

    //    require(_ownerOf[id] != address(0), "ALREADY_MINTED");
//
    //    address to = _ownerOf[id];
//
    //    // Counter overflow is incredibly unrealistic.
    //    unchecked {
    //        _balanceOf[_ownerOf[id]]++;
    //    }

        emit CartesiGenNFTMint(_ownerOf[id], id, x, y, zoom);

        //emit Transfer(address(0), _ownerOf[id], id);
    }
    
}
