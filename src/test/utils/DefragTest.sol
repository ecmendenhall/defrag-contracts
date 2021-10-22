// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "ds-test/test.sol";
import "fractional/ERC721VaultFactory.sol";

import "./MockERC721.sol";
import "./Hevm.sol";

import "../../Defrag.sol";
import "../../DefragFactory.sol";

contract User {
    DefragFactory public defragFactory;
    Defrag internal defrag;

    constructor(address _defrag, address _defragFactory) {
        defrag = Defrag(_defrag);
        defragFactory = DefragFactory(_defragFactory);
    }

    function eleven() public returns (uint256) {
        return defrag.eleven();
    }

    function call_defrag(address vault) public returns (uint256) {
        return defragFactory.defrag(vault);
    }
}

contract Curator {
    TokenVault public vault;
    DefragFactory public defragFactory;

    constructor(address _vault, address _defragFactory) {
        vault = TokenVault(_vault);
        defragFactory = DefragFactory(_defragFactory);
    }

    function call_defrag(address _vault) public returns (uint256) {
        return defragFactory.defrag(_vault);
    }
}

abstract contract DefragTest is DSTest {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);

    // contracts
    Settings internal settings;
    ERC721VaultFactory internal vaultFactory;
    MockERC721 internal nft;
    TokenVault internal vault;
    DefragFactory internal defragFactory;
    Defrag internal defrag;

    // users
    Curator internal curator;
    User internal user;

    function setUp() public virtual {
        settings = new Settings();
        vaultFactory = new ERC721VaultFactory(address(settings));
        nft = new MockERC721("Test NFT", "NFT");

        nft.mint(address(this), 1);
        nft.setApprovalForAll(address(vaultFactory), true);
        vaultFactory.mint(
            "Test Fractions",
            "FRX",
            address(nft),
            1,
            100e18,
            1 ether,
            50
        );

        vault = TokenVault(vaultFactory.vaults(0));

        defragFactory = new DefragFactory();
        defrag = new Defrag();
        user = new User(address(defrag), address(defragFactory));

        curator = new Curator(address(vaultFactory), address(defragFactory));
        vault.updateCurator(address(curator));
    }
}
