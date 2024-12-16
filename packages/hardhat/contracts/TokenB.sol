// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenB is ERC20 {
    constructor() ERC20("TokenB", "TKB") {
        _mint(msg.sender, 10000 * 1e18);
    }

    function mint (uint256 amount) external {
        _mint(msg.sender, amount);
    }
}