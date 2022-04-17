//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//实现功能：存钱，只有部署合约的人可以取钱，取到钱后合约销毁

contract PiggyBank{
    event Deposit(uint amount) ;
    event Withdraw(uint amount) ;

    address public owner = msg.sender ;
    //任何人可以存款，存款会触发存款事件
    receive()external payable{
        emit Deposit(msg.value) ;
    }
    //只有部署者可以取款，取款也会触发事件，取款通过合约自毁完成
    function withdraw() external {
        require(msg.sender == owner , "not owner") ;
        emit Withdraw(address(this).balance) ;
        selfdestruct(payable(msg.sender)) ;
    }
}
