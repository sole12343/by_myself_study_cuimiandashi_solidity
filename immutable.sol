//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//Immutable 可以定义变量类似于常量，但是不需要一开始确定常量的值
//也可以在构造函数内给定这个不变量的值，但是一定要赋值
contract Immutable{
    //定义immutable变量gas: 43585 
    //定义变量gas: 45718  
    //写法1：直接命名的时候赋值
    address public immutable owner  ;
    //写法2：构造函数赋值
    constructor() {
        owner = msg.sender ;
    }
    
    uint public x ;
    function foo() external {
        require(msg.sender == owner) ;
        x += 1 ;
    }
}
