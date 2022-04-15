//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//练习，简单的钱包合约，只可以存钱取钱查余额，没有什么功能
contract etherwallet{
    address payable public owner ;

    constructor(){
        owner = payable(msg.sender) ;
    }

    receive() external payable{}

    function withdrow(uint _amount) external {
        require(owner == msg.sender,"caller not owner") ;
        owner.transfer(_amount) ;
    } 

    function getBalance() external view returns(uint) {
        return address(this).balance ;
    }

}
