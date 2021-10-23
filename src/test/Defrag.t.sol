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

    function test_can_mint_with_larger_amount() public {
        vault.transfer(address(user), 2 * MIN_MINT_AMOUNT);
        uint256 balanceBefore = vault.balanceOf(address(user));

        user.call_approve(address(vault), address(defrag), 2 * MIN_MINT_AMOUNT);
        user.call_mint(2 * MIN_MINT_AMOUNT);

        uint256 balanceAfter = vault.balanceOf(address(user));

        assertEq(balanceAfter, balanceBefore - 2 * MIN_MINT_AMOUNT);
    }

    function test_returns_token_on_mint() public {
        vault.transfer(address(user), MIN_MINT_AMOUNT);

        assertEq(defrag.balanceOf(address(user)), 0);

        user.call_approve(address(vault), address(defrag), MIN_MINT_AMOUNT);
        user.call_mint(MIN_MINT_AMOUNT);

        assertEq(defrag.balanceOf(address(user)), 1);
    }

    function test_increments_token_id() public {
        vault.transfer(address(user), 2 * MIN_MINT_AMOUNT);

        user.call_approve(address(vault), address(defrag), 2 * MIN_MINT_AMOUNT);
        user.call_mint(MIN_MINT_AMOUNT);
        user.call_mint(MIN_MINT_AMOUNT);

        assertEq(defrag.ownerOf(2), address(user));
    }

    function test_tracks_underlying_fractions() public {
        vault.transfer(address(user), 3 * MIN_MINT_AMOUNT + 1100);

        user.call_approve(
            address(vault),
            address(defrag),
            3 * MIN_MINT_AMOUNT + 1100
        );
        uint256 id1 = user.call_mint(MIN_MINT_AMOUNT);
        uint256 id2 = user.call_mint(MIN_MINT_AMOUNT + 100);
        uint256 id3 = user.call_mint(MIN_MINT_AMOUNT + 1000);

        assertEq(defrag.fractionsFor(id1), MIN_MINT_AMOUNT);
        assertEq(defrag.fractionsFor(id2), MIN_MINT_AMOUNT + 100);
        assertEq(defrag.fractionsFor(id3), MIN_MINT_AMOUNT + 1000);
    }
}
