//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//重点是super,继承关系如下：
//     E
//    / \
//   F   G
//    \ /
//     H 

contract E {
    event Log(string message) ;

    function foo() public virtual {
        emit Log("E.foo") ;
    }

    function bar() public virtual {
        emit Log("E.bar") ;
    }
}
//F和G调用E.bar() 和 super.bar() 结果一样
contract F is E {
    function foo() public virtual override {
        emit Log("F.foo") ;
        E.foo() ;
    }
    function bar() public virtual override {
        emit Log("F.bar") ;
        super.bar() ;
    }
}

contract G is E {
    function foo() public virtual override {
        emit Log("G.foo") ;
        E.foo() ;
    }
    function bar() public virtual override {
        emit Log("G.bar") ;
        super.bar() ;
    }
}
//H中两种调用不同，F.foo()调用了E和F ；super.bar()调用了F G E每个合约调用一次bar函数
//super是调用继承父合约中的同名函数，按照继承顺序依次调用
contract H is F, G {
    function foo() public virtual override(F, G) {
        F.foo() ;
    }
    function bar() public virtual override(F, G) {
        super.bar() ;
    }
}
