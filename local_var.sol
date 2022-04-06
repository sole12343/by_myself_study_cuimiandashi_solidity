//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
contract LocalVariables {
    uint public i;
    bool public b;
    address public myAddress;

    function foo() external {
        //x 和 f 是局部变量，他们的状态不会在链上展示
        uint x = 123;
        bool f = false ;
        x += 456 ;
        f = true ;
        
        //i b myAddress 都是状态变量，在合约部署后，当调用foo函数，状态变量状态将发生永久改变
        i = 123 ;
        b = true;
        myAddress = address(1);
    }
}
