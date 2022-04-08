//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
//array  dynamic or fixed size
//Initialization 
// Insert (push) , get , update , delete , pop , length
//Creating array in memory 
//Return array from function

contract Array {
    uint[] public nums = [1, 2, 3] ; //动态数组
    uint[3] public numsFixed = [4, 5, 6] ; //固定长度数组

    function examples() external {
        nums.push(4) ;     //[1, 2, 3, 4]
        uint x = nums[1] ; //get 2
        nums[2] = 7 ;      //[1, 2, 777, 4]
        delete nums[1] ;   //[1, 0, 777, 4]
        nums.pop() ;       //[1, 0, 777] 
        uint len = nums.length ;//length  3

        //create array in memory 
        //固定长度数组不能进行pop和push操作，因为会改变数组的长度
        uint[] memory a = new uint[](5) ;
        a[1] = 123 ;
    }

    function returnArray() external view returns (uint[] memory) {
        return nums ; 
    }
}
