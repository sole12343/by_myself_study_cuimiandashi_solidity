////SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
import "./todolist.sol";

//利用工厂合约来部署合约，必须要在同一个文件里或者import进来
contract Account {
    address public bank ;
    address public owner ;
    constructor(address _owner) payable {
        //用工厂合约部署合约，那么bank就是工厂合约的地址
        bank = msg.sender ;
        //owner 是传入地址变量owner的地址
        owner = _owner ;
    }
}

contract AccountFactory{
    Account[] public accounts ;
    //可以多次调用这个函数部署Account合约
    function createAccount(address _owner) external payable {
        //命名Account变量account，由于构造函数需要传参，那么部署这个合约也就需要传参
        Account account = new Account{value: 111}(_owner) ;
        accounts.push(account) ;
    }
}
