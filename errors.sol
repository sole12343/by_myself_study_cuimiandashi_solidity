//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
//require revert assert
//这些报错控制会 返回gas ，回滚交易和状态 ，还原

contract Error {
    //要求_i小于10，否则会报错，输出_i > 10
    function testRequire(uint _i) public pure {
        require(_i <= 10 , "i > 10" );
        //code
    }

    //如果_i 大于10，那么会报错，并且回滚交易，返回初始状态
    function testRevert (uint _i) public pure {
        if (_i > 10 ){
            revert ("i > 10");
        }
    }

    //assert只有断言作用，判断所给的条件是否为真
    //如果输入foo 11, 交易会报错，require无法满足，如果foo 8，foo交易成功，testAssert交易回滚退还gas
    uint public num = 123 ;
    function testAssert() public view {
        assert (num == 123);
    }
    function foo(uint _i) public {
        num += 1 ;
        require(_i < 10);
    }

    //可以自定义报错，并且返回特定的变量，用revert函数返回自定义报错
    error MyError(string _s ,address caller , uint i);
    function testCustomError(uint _i) public view {
        if (_i > 10){
            revert MyError("oh my god" , msg.sender , _i);
        }
    }


}
