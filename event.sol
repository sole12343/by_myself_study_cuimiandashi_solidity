//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

contract Event {
    event Log(string message , uint val ) ;//里面输入想要报告的数据

    event IndexedLog(address indexed sender , uint val ) ;//indexed变量一个event最多三个，加了indexed那么可以在etherscan上检索到这个事件

    function example() external {
        emit Log("foo" , 1234) ; //触发事件
        emit IndexedLog(msg.sender , 789) ;
    }

    event Message(address indexed _from , address indexed _to , string message ) ;

    function sendMessage(address _to , string calldata message ) external {
        emit Message(msg.sender , _to , message) ;
    } 


}
