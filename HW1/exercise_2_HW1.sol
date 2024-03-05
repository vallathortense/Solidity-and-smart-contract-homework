// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract partA {
    
    // the function takes a string binary as input and returns a decimal number
    function binaryToDecimal(string memory binary) public pure returns (uint256) {
        // store the result in a variable
        uint256 decimalResult = 0;
        // conversion of string to bytes array
        bytes memory binaryBytes = bytes(binary);
        // get the length of input to know when to stop the loop
        uint256 len = binaryBytes.length;
        
        for (uint256 i = 0; i < len; i++) {
            // as the input is positive, we only need to take into account position of the binary number where there is a 1
            if (binaryBytes[i] == '1') {
                decimalResult += 2**(len - i - 1);
            }
        }
        
        return decimalResult;
    }
}


contract PartB {
    
    // the function takes a unit8 (fixed size of 8 bits) as input and returns an array containing values of the position ^ 2
    function getBit(uint8 number) public pure returns (uint256[] memory) {
        uint256[] memory resultArray = new uint256[](8);

        // the loop stops at 8 as we have an uint8 as input
        for (uint8 i = 0; i < 8; i++) {
            uint8 mask = uint8(1) << i;
            // get 0 or 1
            uint8 extractedBit = (number & mask) >> i;
            // Store the in the result array
            resultArray[i] = extractedBit * (2 ** i);
        }

        return resultArray;
    }
}