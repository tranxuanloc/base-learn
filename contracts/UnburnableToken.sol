// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract UnburnableToken {
    mapping(address => uint) public balances;
    uint public totalSupply;
    uint public totalClaimed;

    uint AMOUNT = 1000;

    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address);

    constructor() {
        totalSupply = 100_000_000;
    }

    function claim() external {
        if (balances[msg.sender] > 0) {
            revert TokensClaimed();
        }
        if (totalClaimed == totalSupply) {
            revert AllTokensClaimed();
        }
        balances[msg.sender] = AMOUNT;
        totalClaimed += AMOUNT;
    }

    function safeTransfer(address _to, uint amount) external {
        if (address(0) == _to || _to.balance <= 0) {
            revert UnsafeTransfer(_to);
        }
        balances[msg.sender] -= amount;
        balances[_to] += amount;
    }
}
