//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

//self destruct
//两个功能：删除合约
//强迫转ETH去任何地址

contract Kill{
    constructor() payable {}

    function kill() external {
        //自毁函数里面传入 把剩余币转入的地址
        selfdestruct(payable(msg.sender)) ;
    }

    function testCall() external pure returns(uint) {
        return 123 ;//合约自毁后，无法返回任何值
    }
}
//这是助手合约，用助手合约去让Kill合约自毁，剩余的eth全部转入助手合约中
contract Helper{
    function getBalance()external returns(uint) {
        return address(this).balance ;
    }

    function kill(Kill _kill) external {
        _kill.kill() ;
    }
}
