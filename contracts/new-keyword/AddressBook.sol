// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts@4.9.0/access/Ownable.sol";

contract AddressBook is Ownable {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    mapping(uint => Contact) contacts;
    mapping(uint => uint) idIndex;
    uint[] ids;

    error ContactNotFound(uint id);

    constructor(address initialOwner) Ownable() {
        transferOwnership(initialOwner);
        ids.push(0);
    }

    //208631, 174431
    //167078,167078
    function addContact(
        uint id,
        string memory firstName,
        string memory lastName,
        uint[] memory phoneNumbers
    ) external onlyOwner {
        if (idIndex[id] > 0) {
            return;
        }
        Contact memory contact = Contact({
            id: id,
            firstName: firstName,
            lastName: lastName,
            phoneNumbers: phoneNumbers
        });
        contacts[id] = contact;
        ids.push(id);
        idIndex[id] = ids.length - 1;
    }

    modifier onlyExists(uint id) {
        if (idIndex[id] < 1) {
            revert ContactNotFound(id);
        }
        _;
    }

    // 61097,
    //46506
    function deleteContact(uint id) external onlyOwner onlyExists(id) {
        delete contacts[id];
        delete idIndex[id];
        uint index = idIndex[id];
        uint lastId = ids[ids.length - 1];
        ids.pop();
        if (lastId == id) {
            return;
        }
        idIndex[lastId] = index;
    }

    function getContact(
        uint id
    ) external view onlyExists(id) returns (Contact memory) {
        return contacts[id];
    }

    //26326
    function getAllContacts() external view returns (Contact[] memory) {
        Contact[] memory listContacts = new Contact[](ids.length - 1);
        for (uint i = 1; i < ids.length; i++) {
            listContacts[i] = contacts[ids[i]];
        }
        return listContacts;
    }
}

contract AddressBookFactory {
    function deploy() external returns (address) {
        AddressBook ab = new AddressBook(msg.sender);
        return address(ab);
    }
}
