// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract ArraysExercise {
    uint[] public numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    address[] public senders;
    uint[] public timestamps;
    uint countY2K;

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    function resetNumbers() public {
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    function appendToNumbers(uint[] calldata _append) public {
        for (uint i = 0; i < _append.length; i++) {
            numbers.push(_append[i]);
        }
    }

    function saveTimestamp(uint _timestamp) public {
        if (_timestamp > 946702800) {
            countY2K++;
        }
        senders.push(msg.sender);
        timestamps.push(_timestamp);
    }

    function afterY2K() public view returns (uint[] memory, address[] memory) {
        address[] memory _senders = new address[](countY2K);
        uint[] memory _timestamps = new uint[](countY2K);
        uint index = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                _senders[index] = senders[i];
                _timestamps[index] = timestamps[i];
                index++;
            }
        }
        return (_timestamps, _senders);
    }

    function resetSenders() public {
        delete senders;
        countY2K = 0;
    }

    function resetTimestamps() public {
        delete timestamps;
        countY2K = 0;
    }
}
