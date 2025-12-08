// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract FavoriteRecords {
    mapping(string => bool) public approvedRecords;
    mapping(address => string[]) public userFavorites;
    mapping(address => mapping(string => bool)) public userFavoritesUnique;
    string[] nameOfApproveRecords = [
        "Thriller",
        "Back in Black",
        "The Bodyguard",
        "The Dark Side of the Moon",
        "Their Greatest Hits (1971-1975)",
        "Hotel California",
        "Come On Over",
        "Rumours",
        "Saturday Night Fever"
    ];

    error NotApproved(string _name);

    constructor() {
        for (uint8 i = 0; i < nameOfApproveRecords.length; i++) {
            approvedRecords[nameOfApproveRecords[i]] = true;
        }
    }

    function getApprovedRecords() public view returns (string[] memory) {
        return nameOfApproveRecords;
    }

    function addRecord(string memory _name) public {
        if (!approvedRecords[_name]) {
            revert NotApproved(_name);
        }
        if (!userFavoritesUnique[msg.sender][_name]) {
            userFavoritesUnique[msg.sender][_name] = true;
            userFavorites[msg.sender].push(_name);
        }
    }

    function getUserFavorites(
        address _address
    ) public view returns (string[] memory) {
        return userFavorites[_address];
    }

    function resetUserFavorites() public {
        string[] memory records = userFavorites[msg.sender];
        mapping(string => bool) storage recordMap = userFavoritesUnique[
            msg.sender
        ];
        for (uint8 i = 0; i < records.length; i++) {
            delete recordMap[records[i]];
        }
        delete userFavorites[msg.sender];
    }
}
