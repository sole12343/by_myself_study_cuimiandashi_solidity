//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
contract StateVariables {
    uint public myUnit = 123 ; //这是状态变量，一旦命名将永远存在链上

    function foo() external {
        uint notStateVariables = 456; //这是局部变量，只有被别的合约调用的时候，才会在以太坊的虚拟机出现
    }
}
