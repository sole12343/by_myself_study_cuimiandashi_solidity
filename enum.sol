//SPDX-License-Identifier:MIT
pragma solidity ^0.8.3 ;

contract Eunm {
    enum Status { //枚举结构，类似于bool变量，是下面几个中的一个
        None ,
        Pending ,
        Shipped ,
        Completed ,
        Rejected , 
        Canceled
    }

    Status public status ;//创建一个枚举结构的变量

    struct Order { //将枚举结构和地址变量一起 命名成一个新的结构体
        address buyer ;
        Status status ;
    }

    Order[] public orders ;
    function get() view external returns(Status) { //取枚举结构的值
        return status ;
    } 

    function set(Status _status) external  { //设置status的值
        status =  _status ;
    } 

    function ship() external  { 
        status = Status.Shipped ;
    } 

    function reset() external  { //删除是指 将status的值变成枚举结构中的第一个的值, 此处为None
        delete status ;
    } 

}
