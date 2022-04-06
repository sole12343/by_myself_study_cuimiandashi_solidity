//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

//if-else结构 常规写法
contract ifelse{
    function example(uint _x) external pure returns (uint) {
        if (_x < 10){
            return 1 ;
        }else if(_x <20){
            return 2 ;
        }else{
            return 3 ;
        }

    }

    function ternary(uint _x) external pure returns (uint) {

        return _x < 10 ? 1 : 2 ;            //三元运算符，如果小于10，返回1，否则返回2
    }
}
