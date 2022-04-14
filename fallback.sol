//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//当调用的函数合约中不存在和直接向合约打以太的时候会调用回退函数
//回退函数分两种fallback()和receive()
//两种函数的选择： is msg.data empty ?
//                  /           \
//                 yes           no
//                /               \
//         is receive()resist?   fallback()
//              /     \
//             /       \
//            yes       no 
//          receive()   fallback()
contract Fallback{
    event Log(string func , address sender ,uint value, bytes data) ;
    fallback() external payable {
        emit Log("fallback", msg.sender , msg.value , msg.data) ;
    }
    receive() external payable {
        emit Log("receive", msg.sender , msg.value , "") ;
    }
}
