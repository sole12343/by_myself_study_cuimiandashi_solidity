//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

contract ArrayReplaceLast{
    uint[] public arr ;

    //第二种remove方法：将想要删除元素与最后一个元素互换位置，再弹出最后一个元素
    //[1, 2, 3, 4] --- remove(1) --- [1, 4, 3]
    //[1, 4, 3] --- remove(2) --- [1, 4]
    function remove(uint _index) public {
        require(_index < arr.length , "index out of bound") ;
        arr[_index] = arr[arr.length-1] ;
        arr.pop() ;
    }


    function test() external {
        arr = [1, 2, 3, 4] ;
        remove(1) ;

        //[1, 4, 3]
        require(arr.length == 3) ;
        require(arr[0] == 1) ;
        require(arr[1] == 4) ;
        require(arr[2] == 3) ;
        
        //[1, 4]
        remove(2) ;
        require(arr.length == 2) ;
        require(arr[0] == 1) ;
        require(arr[1] == 4) ;
    }

}
