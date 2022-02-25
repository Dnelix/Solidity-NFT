// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721connector.sol';

contract Kryptobird is ERC721connector {

    string[] public Kryptobirdz; //array of strings to store the NFTs

    mapping(string => bool) _kBirdExists; //create maping of either true or false to each NFT to be updated after each mint

    function mint(string memory _kryptoBird) public {
        require(!_kBirdExists[_kryptoBird], 'This KryptoBird already exists'); // Require that this NFT has not been minted (ie set to TRUE) previously
        Kryptobirdz.push(_kryptoBird); //pushes what is minted into the created array
        uint _id = Kryptobirdz.length - 1; //_id value is the last index of the array (ie length - 1)

        _mint(msg.sender, _id); // calling the mint function previously created in ERC721 and parsing the required values of sender and tokenId

        _kBirdExists[_kryptoBird] = true; //assign true to this minted NFT
    }

    constructor() ERC721connector('Kryptobirdy', 'KRBD') {
        
    }
}