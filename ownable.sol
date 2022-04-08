//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

//复习之前所学的内容
//状态变量，全局变量，函数修改器，函数，报错处理

contract Ownable {
    address public owner ;
    constructor(){
        owner = msg.sender ; 
    }
    modifier onlyOwner () {
        require(msg.sender == owner) ;
        _;
    }
    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0) , "invalid address!");
        owner = _newOwner ;
    }

    //测试onlyOwner函数修饰符是否起作用

    function onlyOwnercancallthisfunc() external onlyOwner {
        //code
    }

    function anyOnecancall() external {
        //code
    }
}
