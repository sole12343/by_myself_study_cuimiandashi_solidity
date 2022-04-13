//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

contract A {
    //有关键字virtual代表支持重写，可以被覆盖修改函数的逻辑
    function foo() public pure virtual returns (string memory) { 
        return "A" ;
    }

    function bar() public pure virtual returns (string memory) {
        return "A" ;
    }

    function baz() public pure returns (string memory) {
        return "A" ;
    }
    //more code
}

contract B is A {
    //override 关键字代表，此函数将会被覆盖，用最新的逻辑，不用继承函数的逻辑
    function foo() public pure override returns (string memory) { 
        return "B" ;
    }

    function bar() public pure override virtual returns (string memory) {
        return "B" ;
    }
    //more code
}

contract C is B {
    function bar() public pure override returns (string memory) {
        return "C" ;
    }
}
