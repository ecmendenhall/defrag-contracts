// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./utils/DefragTest.sol";

contract TestDefrag is DefragTest {
    function test_returns_eleven() public {
        assertEq(user.eleven(), 11);
    }
}
