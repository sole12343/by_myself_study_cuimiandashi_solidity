//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

//循环结构while + for 
//continue break 两种跳出循环
//需要注意solidity进行循环计算，要注意计算量，所有计算都需要花费gas
contract forandwhileloops{
    function loops() external pure{
        for (uint i = 0 ; i < 10 ; i++ ){
            //code
            if (i == 3){
                continue;
            }
            //more code 
            if (i == 5){
                break;
            }
        }
        uint j = 0 ;
        while (j < 10){
            //code
            j++;
        }
    }

    function sum(uint _n) external pure returns (uint){
        uint s ; //初始化默认为0
        for (uint i = 1 ; i <= _n ; i++){
            s += i;
        }
        return s ;
    }
}
