// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./Employee.sol";

contract Hourly is Employee {
    uint public hourlyRate;

    // 20,55555,12345
    constructor(
        uint _hourlyRate,
        uint _idNumber,
        uint _managerId
    ) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }
    function getAnnualCost() public view override returns (uint) {
        return hourlyRate;
    }
}

contract Salesperson is Hourly {
    constructor(
        uint _idNumber,
        uint _managerId,
        uint _hourlyRate
    ) Hourly(_idNumber, _managerId, _hourlyRate) {}
}
