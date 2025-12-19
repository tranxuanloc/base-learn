// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    // Struct to store Haiku data
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    // Public array to store all haikus
    Haiku[] public haikus;

    // Mapping to relate shared haikus from address to haiku IDs
    mapping(address => uint256[]) public sharedHaikus;

    // Counter for haiku IDs and total count
    uint256 public counter = 1;

    // Mapping to track used lines for uniqueness check
    mapping(string => bool) private usedLines;

    // Custom errors
    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    // Constructor
    constructor() ERC721("HaikuNFT", "HAIKU") {
        // Push empty haiku at index 0 so IDs start at 1
        haikus.push(Haiku(address(0), "", "", ""));
    }

    // Mint a new Haiku NFT
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external {
        // Check uniqueness - all lines must be unique across all haikus
        if (usedLines[_line1] || usedLines[_line2] || usedLines[_line3]) {
            revert HaikuNotUnique();
        }

        // Mark lines as used
        usedLines[_line1] = true;
        usedLines[_line2] = true;
        usedLines[_line3] = true;

        // Create the haiku
        Haiku memory newHaiku = Haiku({
            author: msg.sender,
            line1: _line1,
            line2: _line2,
            line3: _line3
        });

        // Add to haikus array
        haikus.push(newHaiku);

        // Mint the NFT with current counter as ID
        _mint(msg.sender, counter);

        // Increment counter for next haiku
        counter++;
    }

    // Share a haiku with another address
    function shareHaiku(address _to, uint256 _haikuId) public {
        // Check if caller is the owner of the haiku NFT
        if (ownerOf(_haikuId) != msg.sender) {
            revert NotYourHaiku(_haikuId);
        }

        // Add the haiku ID to the recipient's shared haikus
        sharedHaikus[_to].push(_haikuId);
    }

    // Get all haikus shared with the caller
    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] memory sharedIds = sharedHaikus[msg.sender];

        // Revert if no haikus have been shared with caller
        if (sharedIds.length == 0) {
            revert NoHaikusShared();
        }

        // Create array to hold the actual haiku structs
        Haiku[] memory sharedHaikusArray = new Haiku[](sharedIds.length);

        // Populate the array with haikus
        for (uint256 i = 0; i < sharedIds.length; i++) {
            sharedHaikusArray[i] = haikus[sharedIds[i]];
        }

        return sharedHaikusArray;
    }
}
