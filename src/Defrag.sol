// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interfaces/IVault.sol";

contract Defrag is ERC721 {
    IVault public vault;
    uint256 public minMintAmount;

    mapping (uint256 => uint256) internal underlyingFractions;
    uint256 internal nextId;

    constructor(
        address _vault,
        uint256 _minMintAmount,
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        vault = IVault(_vault);
        minMintAmount = _minMintAmount;
    }

    function mint(uint256 amount) public returns (uint256) {
        require(amount >= minMintAmount, "<minMintAmount");
        nextId++;
        underlyingFractions[nextId] = amount;
        vault.transferFrom(address(msg.sender), address(this), amount);
        _safeMint(address(msg.sender), nextId);
        return nextId;
    }

    function fractionsFor(uint256 tokenId) public view returns (uint256) {
        return underlyingFractions[tokenId];
    }
}
