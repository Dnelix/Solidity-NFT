// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface IERC721metadata {

    function name() external view returns (string memory _name);

    function symbol() external view returns (string memory _symbol);

    /// A distinct Uniform Resource Identifier (URI) for a given asset.
    /// Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    //function tokenURI(uint256 _tokenId) external view returns (string);
}