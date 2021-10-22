// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./utils/DefragTest.sol";

contract TestDefrag is DefragTest {
    function test_has_vault_address() public {
        assertEq(address(defrag.vault()), address(vault));
    }

    function test_has_min_min_amount() public {
        assertEq(defrag.minMintAmount(), MIN_MINT_AMOUNT);
    }

    function test_transfers_out_fractions_on_mint() public {
        vault.transfer(address(user), MIN_MINT_AMOUNT);
        uint256 balanceBefore = vault.balanceOf(address(user));

        user.call_approve(address(vault), address(defrag), MIN_MINT_AMOUNT);
        user.call_mint(MIN_MINT_AMOUNT);

        uint256 balanceAfter = vault.balanceOf(address(user));

        assertEq(balanceAfter, balanceBefore - MIN_MINT_AMOUNT);
    }

    function test_transfers_in_fractions_on_mint() public {
        vault.transfer(address(user), MIN_MINT_AMOUNT);
        uint256 balanceBefore = vault.balanceOf(address(defrag));

        user.call_approve(address(vault), address(defrag), MIN_MINT_AMOUNT);
        user.call_mint(MIN_MINT_AMOUNT);

        uint256 balanceAfter = vault.balanceOf(address(defrag));

        assertEq(balanceAfter, balanceBefore + MIN_MINT_AMOUNT);
    }

    function testFail_must_meet_min_mint_amount() public {
        vault.transfer(address(user), MIN_MINT_AMOUNT);

        user.call_approve(address(vault), address(defrag), MIN_MINT_AMOUNT);
        user.call_mint(MIN_MINT_AMOUNT - 1);
    }
}
