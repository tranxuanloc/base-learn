// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./Employee.sol";

contract Salaried is Employee {
    uint public annualSalary;

    //200000,54321,11111
    constructor(
        uint _annualSalary,
        uint _idNumber,
        uint _managerId
    ) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }
    function getAnnualCost() public view override returns (uint) {
        return annualSalary;
    }
}

contract Manager {
    uint[] public employeeIds;
    function addReport(uint _id) public {
        employeeIds.push(_id);
    }
    function resetReports() public {
        delete employeeIds;
    }
}

contract EngineeringManager is Salaried, Manager {
    constructor(
        uint _idNumber,
        uint _managerId,
        uint _annualSalary
    ) Salaried(_idNumber, _managerId, _annualSalary) {}
}
