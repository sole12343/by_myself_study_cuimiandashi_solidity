//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

//删除数组元素delete只能将该元素变成0，并不能改变数组的长度
//写一个可以直接删除掉指定序号的元素的函数remove
contract ArrayShift{
    uint[] public arr ;
    uint[3] public arr2 ;

    function example() public {
        arr = [1, 2, 3] ;
        delete arr[1] ; //[1, 0, 3]
    }

    //原理：先让从序号开始的元素等于后面一个元素，再pop把最后一个元素弹出
    //[1, 2, 3] ---> remove(1) --->[1, 3, 3] ---> [1. 3]
    //[1] ---> remove(0) ---> [1] ---> [] 
    function remove(uint _index) public {
        require(_index < arr.length , "index out of bound") ;
        for (uint i = _index ; i < arr.length - 1 ; i++) {
            arr[i] = arr[i + 1] ;
        }
        arr.pop() ;
    }
    //测试,成功运行，代表 remove操作正常
    function test() external {
        arr = [1, 2, 3, 4, 5] ;
        remove(2) ;
        require(arr[0] == 1,"0") ; 
        require(arr[1] == 2,"1") ; 
        require(arr[2] == 4,"2") ; 
        require(arr[3] == 5,"3") ; 
        require(arr.length == 4,"4") ;

        arr = [1] ;
        remove(0) ;
        require(arr.length == 0,"5");
    }

}
