//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

contract Counter {

    uint public counter ;

    //外部函数 只允许外部的合约调用，合约内部无法调用
    function inc() external {
        counter += 1 ;
    }
    function dec() external {
        counter -= 1 ;
    }
}
