// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./utils/DefragTest.sol";
import "../interfaces/IDefrag.sol";

contract TestDefragFactory is DefragTest {
    function test_curator_can_call_defrag() public {
        curator.call_defrag(address(vault), MIN_MINT_AMOUNT);
    }

    function testFail_user_cannot_call_defrag() public {
        user.call_defrag(address(vault), MIN_MINT_AMOUNT);
    }

    function test_increments_defrag_id() public {
        curator.call_defrag(address(vault), MIN_MINT_AMOUNT);
        assertEq(defragFactory.defragCount(), 1);
    }

    function test_returns_defrag_id() public {
        assertEq(curator.call_defrag(address(vault), MIN_MINT_AMOUNT), 1);
    }

    function test_stores_defrag_address() public {
        assertEq(defragFactory.defrags(1), address(0x0));
        curator.call_defrag(address(vault), MIN_MINT_AMOUNT);
        assertEq(
            defragFactory.defrags(1),
            address(0x73A1564465e54a58De2Dbc3b5032fD013fc95aD4)
        );
    }

    function test_creates_defrag_with_vault_address() public {
        curator.call_defrag(address(vault), MIN_MINT_AMOUNT);
        IDefrag created = IDefrag(defragFactory.defrags(1));

        assertEq(address(created.vault()), address(vault));
    }

    function test_creates_defrag_with_min_mint_amount() public {
        curator.call_defrag(address(vault), MIN_MINT_AMOUNT);
        IDefrag created = IDefrag(defragFactory.defrags(1));

        assertEq(created.minMintAmount(), MIN_MINT_AMOUNT);
    }
}
