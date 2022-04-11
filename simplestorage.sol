//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

contract Simplestorage{
    string public text ;

    //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    //gas对比memory 和 calldata
    //calldata 89626 gas  
    //memory 90114 gas

    function set(string memory _text) external {
        text = _text ;
    }
    function get() external view returns (string memory) {
        return text ;
    }
}
