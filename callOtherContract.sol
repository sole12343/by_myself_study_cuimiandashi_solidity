//SPDX-License-Identiifer:UNLICENSED
pragma solidity ^0.8.7 ;
//怎么调用其他合约的函数
contract CallOtherContract{
    function setX(Testconstract _text, uint _x) external {
        _text.setX(_x) ;
    }
    function getX(address _text) external returns(uint x){
        //调用其他合约的函数只需要把这个合约当作类型传入其地址即可
        x = Testconstract(_text).getX() ;
    }
    //注意这里对于传递多参数的合约函数的调用
    function setXandValue(address _text, uint _x) external payable{
        Testconstract(_text).setXandValue{value: msg.value}(_x) ;
    }
    function getXandValue(address _text) external returns(uint, uint){
        (uint x , uint value) = Testconstract(_text).getXandValue();
        return (x, value) ;
    }
}

contract Testconstract{
    uint public x ; 
    uint public value = 123 ;
    function setX(uint _x) external {
        x = _x ;
    }
    function getX() external view returns(uint){
        return x ;
    } 
    function setXandValue(uint _x) external payable{
        x = _x ;
        value = msg.value ;
    }
    function getXandValue()external view returns(uint, uint){
        return (x, value) ;
    }
}
