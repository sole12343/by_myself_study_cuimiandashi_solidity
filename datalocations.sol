//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;


//datalocations: storage , memory and calldata

contract Datalocations{
    struct Mystruct {
        uint foo ;
        string text ;
    }
    mapping (address => Mystruct) public myStructs ;

    function examples(uint[] calldata y , string calldata s) external returns (uint , uint ){
        myStructs[msg.sender] = Mystruct({foo: 123 , text :"bar"}) ;

        Mystruct storage myStruct = myStructs[msg.sender] ;//状态变量存进存储，就可以放在链上
        myStruct.text = "foo" ;//修改存储中的变量

        Mystruct memory readyOnly = myStructs[msg.sender] ;//局部变量放进内存，不会永久保留，运行完消失
        readyOnly.foo = 456 ;//修改局部变量

        uint[] memory memArr = new uint[](3) ;//将数组放入内存中，这时必须是固定长度数组，并且数组的未赋值位置的数据为默认值0
        memArr[0] = 234 ;//修改内存中数组的值
        memArr[1] = 2 ;

        uint x =_internal(y)  ;

        return (memArr[1] , x) ;
    }

    function _internal(uint[] calldata y) public returns(uint) {//calldata本质上和memory一样
        uint x = y[0] ;                                         //不过如果使用calldata就不需要复制值到内存中，那么就可以节约gas
        return x ;                                              //建议全部数据局部变量都使用 calldata
    }
}
