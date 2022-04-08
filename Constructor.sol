//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

//构造函数constructor是合约部署直接会运行的函数，构造函数只有一个
contract Constructor{
    address public owner ;
    uint public x ;

    constructor(uint _x) {
        owner = msg.sender ;
        x = _x ;
    }

}
