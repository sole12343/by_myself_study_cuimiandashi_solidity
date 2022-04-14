//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
contract Payable{
    //地址添加payable关键字 才能发送以太
    address payable public owner ;

    constructor(){
        owner = payable(msg.sender) ;//此处需要注意msg.sender也必须要添加payable关键字，否则调用地址无法作为payable地址
    } 
    //函数添加payable关键字，才能接受和发送以太
    function deposit() external payable {}
    function getbalance() external view returns(uint) {
        return address(this).balance ;
    }
}
