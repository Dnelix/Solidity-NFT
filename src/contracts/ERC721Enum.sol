// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721.sol';
import './interfaces/IERC721Enum.sol';

contract ERC721Enum is IERC721Enum, ERC721 {

    uint256[] private _allTokens; // create an array of integers to hold the list of tokens

    mapping (uint256 => uint256) private _allTokensIndex; // Mapping from tokenId to position in _allTokens array
    mapping (address => uint256[]) private _ownedTokens; // Mapping of owner to list of all owned token ids
    mapping (uint256 => uint256) private _tokenIndex; // mapping from token id to index of the owner tokens list

    constructor(){
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^keccak256('tokenByIndex(bytes4)')^keccak256('ownerTokenByIndex(bytes4)')));
    }

    function totalSupply() public view override returns(uint256){
        return _allTokens.length; //length of the _allTokens array
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721){
        super._mint(to, tokenId);
        _addTokensToOwner(to, tokenId); // add tokens to the owner
        _addTokensToAllTokens(tokenId); // add tokens to total supply (_allTokens)
    }

    function _addTokensToAllTokens(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length; // For 1st map, set the position of the new token to be created to the current length of the array
        _allTokens.push(tokenId);
    }

    function _addTokensToOwner(address to, uint256 tokenId) private {
        _tokenIndex[tokenId] = _ownedTokens[to].length; // For 2nd map assign a position to tokenIndex by setting it to current length of the owned tokens array 
        _ownedTokens[to].push(tokenId); // Add tokenId to owned tokens
    }

    function tokenByIndex(uint256 index) public view override returns(uint256){
        require(index < totalSupply(), 'Global Index exceeded'); // Ensure that the provided index no does not exceed total supply
        return _allTokens[index]; // The function returns token when given the index
    }

    function ownerTokenByIndex (address owner, uint256 index) public view override returns (uint256){
        require(index <= balanceOf(owner), 'Owner token index exceeded'); // Ensure that the provided index does not exceed number of tokens owned by owner
        return _ownedTokens[owner][index];
    }

}