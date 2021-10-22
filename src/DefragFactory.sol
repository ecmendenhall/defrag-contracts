// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Defrag.sol";
import "./interfaces/IVault.sol";

contract DefragFactory {
    uint256 public defragCount;
    mapping(uint256 => address) public defrags;

    function defrag(address _vault) public returns (uint256) {
        IVault vault = IVault(_vault);
        require(vault.curator() == address(msg.sender), "!curator");
        defragCount++;
        uint256 id = defragCount;
        Defrag d = new Defrag();
        defrags[id] = address(d);
        return id;
    }
}
