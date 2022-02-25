// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

/* Mint function
a. NFT to point to an address
b. Keep track of the token IDs
c. Keep track of token owner addresses 
d. Keep track of how many tokens an owner address has
e. Create an event that emits a transfer log containing the information required*/

contract ERC721 is ERC165, IERC721 {

    mapping(uint256 => address) private _tokenOwner; //mapping of Token IDs (int) to owner (address)
    mapping(address => uint256) private _tokensCount; //mapping from owner to number of owned tokens
    mapping(uint256 => address) private _tokenApprovals; //mapping from tokenID to approved addresses

    constructor(){
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }

    function balanceOf(address _owner) public override view returns(uint256){
        require(_owner != address(0), 'Address is invalid!');
        return _tokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public override view returns(address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Token does not exist');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) { // function takes tokenID as parameter. We expect a return of true/false (bool)
        address owner = _tokenOwner[tokenId]; // tokenID is parsed to the _tokenOwner mapping to obtain the corresponding address
        return owner != address(0); // Check if the address returned is a zero address. Returns true is it's not
    }

    function _mint(address to, uint256 tokenId) virtual internal {
        require(to != address(0), "Invalid Address"); //require that the address is not a zero address
        require(!_exists(tokenId), "Token already minted"); //Require that this tokenID is not existng before now

        _tokenOwner[tokenId] = to;
        _tokensCount[to] +=1; // increment count of token each time the function is called

        emit Transfer(address(0), to, tokenId); //emit the transfer event
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require (_to != address(0), 'Invalid Address!'); // require that the receiving address is not a zero adress
        //require (_exists(_tokenId), 'You must own tokens to transfer');
        require (ownerOf(_tokenId) == _from, 'You can only transfer tokens you own');// require that address tranferring the token actually owns it
        _tokenOwner[_tokenId] = _to; // add token id to address receiving the token
        _tokensCount[_from] -= 1; // update balance of the _from address
        _tokensCount[_to] += 1; // update the balance of the _to address
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApproved(msg.sender, _tokenId)); // call the approval function to require that the user is approved
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public { // approve an address to a token
        address owner = ownerOf(_tokenId);
        require(msg.sender == owner, 'Current caller is not the owner'); // require that approver is the owner
        require(_to != owner, 'Cannot approve tokens to self'); // require that the owner cannot approve sending tokens to himself

        _tokenApprovals[_tokenId] = _to; // map the _to address in the tokenApprovals array
        emit Approval(owner, _to, _tokenId);
    }

    function isApproved(address spender, uint256 tokenId) public view returns (bool){
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender == owner);
    }
}