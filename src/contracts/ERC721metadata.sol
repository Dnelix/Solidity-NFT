// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './interfaces/IERC721metadata.sol';
import './ERC165.sol';

contract ERC721metadata is IERC721metadata, ERC165 {
    string private _name; // = 'KryptoBirdy';
    string private _symbol; // = 'KRBD';

    constructor(string memory nam, string memory symb) {
        _registerInterface(bytes4(keccak256('name(bytes4)')^keccak256('symbol(bytes4)')));
        _name = nam;
        _symbol = symb;
    }

    function name() external view override returns(string memory) {
        return _name;
    }

    function symbol() external view override returns(string memory) {
        return _symbol;
    }
}