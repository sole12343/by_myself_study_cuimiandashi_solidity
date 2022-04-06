//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

contract GlobalVariables {
    function globalvars() external view returns (address , uint , uint){
        //这是三个常见的全局变量
        address sender = msg.sender ; //这是调用当前合约方法的 账户，可能是合约地址也可能是一个账户地址
        uint timestamp = block.timestamp ;
        uint blockNum = block.number ;
        return (sender , timestamp , blockNum);
    }
}
