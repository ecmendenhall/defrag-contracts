// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "./interfaces/IVault.sol";

contract Defrag is ERC721Upgradeable {
    IVault public vault;
    uint256 public minMintAmount;

    mapping(uint256 => uint256) internal underlyingFractions;
    uint256 internal nextId;

    function initialize(
        address _vault,
        uint256 _minMintAmount,
        string memory _name,
        string memory _symbol
    ) external initializer {
        __ERC721_init(_name, _symbol);
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
