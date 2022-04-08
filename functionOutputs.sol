//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

//return multiple outputs
//named outputs 给返回值命名 可以知道返回值的含义
//destructuring assignment 隐性赋值

contract functionOutputs {
    uint public a;
    bool public d;

    //return multiple outputs 返回多个值
    function returnMany() public pure returns (uint , bool) {
        return (1, true) ;
    }

    //named outputs 给返回值命名 可以知道返回值的含义
    function named() public pure returns (uint x , bool b){
        return (1 , true) ;
    }

    //destructuring assignment 隐性赋值
    function assigned() public pure returns (uint x , bool b) {
        x = 1 ;
        b = true ;
    }

    function destructuringAssigments() public  {
        (a , d) = returnMany() ;
        // (, bool b) = named() ;  如果只想取值一个，第一个元素不用，直接逗号+第二个元素就行
    }

}
