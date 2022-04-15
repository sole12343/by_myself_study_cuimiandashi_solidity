//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//3ways send ETH
//transfer 2300gas , revert
//send     2300gas ， return bool
//call     all gas ,  return bool and data
//注意call的写法
//call默认情况下将所有可用的gas传输过去，gas传输量可调。
//transfer和send都是固定传输的gas，其中transfer失败会throw，内置了执行失败的处理
//优先使用transfer,transfer方法将抛出异常到发送合约，并自动恢复所有状态改变。

contract sendEther{
    constructor() payable{}
    receive() external payable {} 
    function sendViatransfer(address payable _to) external payable{
        _to.transfer(123) ;
    }
    function sendViasend(address payable _to) external payable{
        bool sent = _to.send(123) ;
        require(sent , "send failed") ;
    }
    function sendViacall(address payable _to) external payable{
        (bool success, )= _to.call{value: 123}("") ;
        require(success , "call failed") ;
    }
}

contract Ethreceive{
    event Log(uint amount , uint gas) ;
    receive() external payable {
        emit Log(msg.value , gasleft()) ;
    }
}
