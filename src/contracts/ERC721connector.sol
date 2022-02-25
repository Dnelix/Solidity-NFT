// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721metadata.sol';
import './ERC721Enum.sol';

contract ERC721connector is ERC721metadata, ERC721Enum {

    constructor(string memory nam, string memory symb) ERC721metadata(nam, symb) {
        
    }
}