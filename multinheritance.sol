//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//多线继承
//继承的顺序是按照 继承合约数目最少的依次定义合约，此处顺序是X，Y，Z（X没有继承，Y继承X ，Z继承X和Y）
//    X
//   /|
//  Y |
//   \|
//    Z
//这个顺序是X , A, Y , B, Z
//     X
//    / \
//   Y   A
//   |   |
//   |   B 
//    \ /
//     Z

contract X {
    //有关键字virtual代表支持重写，可以被覆盖修改函数的逻辑
    function foo() public pure virtual returns (string memory) { 
        return "X" ;
    }

    function bar() public pure virtual returns (string memory) {
        return "X" ;
    }

    function baz() public pure virtual returns (string memory) {
        return "X" ;
    }
    //more code
}

contract Y is X {
    function foo() public pure override virtual returns (string memory) { 
        return "Y" ;
    }

    function bar() public pure override virtual returns (string memory) {
        return "Y" ;
    }

    function baz() public pure override virtual returns (string memory) {
        return "Y" ;
    }
    //more code
}

contract Z is X, Y { //注意多线继承格式
    function foo() public pure override(X, Y)  returns (string memory) { //注意这里覆盖也是覆盖两个合约的函数
        return "Z" ;
    }

    function bar() public pure override(X, Y)  returns (string memory) {
        return "Z" ;
    }

    function baz() public pure override(X, Y)  returns (string memory) {
        return "Z" ;
    }
}
