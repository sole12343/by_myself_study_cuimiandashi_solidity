//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

/* 常规调用和委托调用的区别
常规调用：A calls B , send 100 wei
                B calls C , send 50 wei
A --> B --> C
            C的视角：
                msg.sender = B
                msg.value  = 50
                execute code on C's state variables
                use ETH in C

委托调用：A calls B , send 100 wei
                B delegateCall C
A --> B --> C
            C的视角：
                msg.sender = A
                msg.value  = 100
                execute code on B's state variables
                use ETH in C

*/
//1.要想委托调用必须同时保持调用者的上下文变量（包括存储）不会变。因为这是线式栈式存储，并不会检查变量修改，
//一旦变量修改，里面的数据就会对应不上
//2.可以通过重新部署TestDelegateCall来改变DelegateCall同样输入的输出，这是一种升级合约的方法
contract TestDelegateCall {
    uint public num ;
    address public sender ;
    uint public value ;
    function setVars(uint _num) external payable {
        num = _num ;
        sender = msg.sender ;
        value = msg.value ;
    }
}
//用 DelegateCall 去委托调用 TestDelegateCall，两种写法
contract DelegateCall{
    uint public num ;
    address public sender ;
    uint public value ;
    function setVars(address _test , uint _num) external payable {
        //委托调用写法1
        // _test.delegatecall(
        //     abi.encodeWithSignature("setVars(uint256)", _num) 
        //     );
        //委托调用写法2
        //选用select方法是合约名+函数名+selector
        (bool success , bytes memory data) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
        );

    }
}
