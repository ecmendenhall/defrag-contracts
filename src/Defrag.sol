// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./interfaces/IVault.sol";

contract Defrag {
    IVault public vault;
    uint256 public minMintAmount;

    constructor(address _vault, uint256 _minMintAmount) {
        vault = IVault(_vault);
        minMintAmount = _minMintAmount;
    }

    function mint(uint256 amount) public returns (uint256) {
        require(amount >= minMintAmount, "<minMintAmount");
        vault.transferFrom(address(msg.sender), address(this), amount);
        return 1;
    }
}
