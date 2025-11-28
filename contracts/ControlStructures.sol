// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract ControlStructures {
    function fizzBuzz(uint _number) external pure returns (string memory) {
        bool div3 = _number % 3 == 0;
        bool div5 = _number % 5 == 0;
        if (div3 && div5) {
            return "FizzBuzz";
        }
        if (div3) {
            return "Fizz";
        }
        if (div5) {
            return "Buzz";
        }
        return "Splat";
    }

    error AfterHours(uint);
    function doNotDisturb(uint _time) external pure returns (string memory) {
        assert(_time < 2400);
        if (_time < 800 || _time > 2200) {
            revert AfterHours(_time);
        }
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }
        if (_time >= 1200 && _time <= 1259) {
            return "At lunch!";
        }
        if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }
        return "Evening!";
    }
}
