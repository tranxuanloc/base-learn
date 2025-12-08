// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    mapping(address => Car[]) garage;

    error BadCarIndex(uint _index);

    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address _address) public view returns (Car[] memory) {
        return garage[_address];
    }

    function addCar(
        string memory make,
        string memory model,
        string memory color,
        uint doors
    ) public {
        Car storage newCar = garage[msg.sender].push();
        newCar.make = make;
        newCar.model = model;
        newCar.color = color;
        newCar.numberOfDoors = doors;
    }

    function updateCar(
        uint index,
        string memory make,
        string memory model,
        string memory color,
        uint doors
    ) public {
        Car[] storage cars = garage[msg.sender];
        if (index >= cars.length) {
            revert BadCarIndex(index);
        }
        Car storage newCar = cars[index];
        newCar.make = make;
        newCar.model = model;
        newCar.color = color;
        newCar.numberOfDoors = doors;
    }

    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
