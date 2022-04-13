//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

//这里有两个父合约S和T ， 子合约继承S和T，那么构造函数传参有两种方法
contract S {
    string public name ;
    constructor(string memory _name){
        name = _name ;
    }
}

contract T {
    string public text ;
    constructor(string memory _text) {
        text = _text ;
    }
}
//方法1，直接将构造函数需要传的参数传入合约，特点：必须要提前知道S和T合约的内容
contract U is S("s") , T("t"){
}
//方法2，在子合约内部写构造函数，传入参数
contract V is S, T {
    constructor(string memory _name , string memory _text ) S(_name) T(_text){}
}
//两种方法混合
contract W is S("s") , T {
    constructor(string memory _text) T(_text){
    }
}
//继承的顺序？还是按照继承的顺序进行初始化
//例如顺序：1.S  2.T  3.V0 修改下面命名的顺序和传参的顺序都没有意义
contract V0 is S, T {
    constructor(string memory _name , string memory _text ) S(_name) T(_text){}
}
//例如顺序：1.S  2.T  3.V0 
contract V1 is T, S {
    constructor(string memory _name , string memory _text ) T(_text) S(_name) {}
}
//例如顺序：1.T  2.S  3.V0 如果继承顺序发生改变，那么下面的顺序不用动，也会自动修改传参的顺序的
contract V2 is S, T {
    constructor(string memory _name , string memory _text ) S(_name) T(_text){}
}
