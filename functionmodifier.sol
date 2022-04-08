//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

//function modifier 函数修改器，可以修饰函数、复用函数
//三种 ： basic inputs sandwich

contract FunctionModifier{

    bool public paused ;
    uint public count ;

    function setPause(bool _paused) external {
        paused = _paused ;
    }


    //1 basic类型函数修饰符
    modifier whenNotPaused() {
        require(!paused , "paused"); //require必须里面是true，那么也就是paused 为false 
        _;  //不能省略，代表着其他原函数之后的代码
    }

    //whenNotPaused作为函数修饰符，作用是每次进行加减之前判断pause是否为false
    function inc() external whenNotPaused {
        count += 1 ;
    }

    function dec() external whenNotPaused {
        count -= 1 ;
    }

    //2.inputs类型函数修饰符
    modifier cap(uint _x) {
        require (_x < 100 , "x >= 100");
        _;
    }

    function incBy(uint _x) external whenNotPaused cap(_x) {
        count += _x;
    }

    //3.sandwich类型函数修饰符
    //count 原来是0 ， 点击一次foo函数，count 应该变成22
    modifier sandwich(){
        count += 10 ;
        _;  //原函数代码先运行，之后再运行sandwich最后的代码
        //more code
        count *= 2 ; 
    }
    function foo() external sandwich {
        count += 1 ;
    }

}
