//SPDX-License-Identifier:MIT
pragma solidity ^0.8.3 ;

//先定义库的函数功能
library ArrayLib{
    function find(uint[] storage arr , uint x) internal view returns(uint ){
        for(uint i = 0 ; i < arr.length ; i++){
            if (arr[i] == x ){
                return i ;
            }
        }
        revert("not found") ;
    }
}
//
contract TestArray{
    //此处功能将库函数全部应用于uint数组，那么数组全都支持find功能
    using ArrayLib for uint[] ;
    uint[] public arr = [3, 2, 1] ;

    function testfind() external view returns(uint i) {
        //第一种写法：没有上面的using情况下
        //return ArrayLib.find(arr , 2) ;
        //第二种写法：加了using 
        return arr.find(2) ;
    }
}

library Math{
    function max(uint x , uint y) internal pure returns(uint) {
        return x > y ?  x : y ;
    }
} 
contract Test{
    function testmax(uint x , uint y) external pure returns(uint){
        return Math.max(x, y) ;
    }
}
