//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

contract HashFunc{
    //bytes32是智能合约中的定长的返回值
    function hash(string memory text, uint num, address addr)external pure returns(bytes32){
        return keccak256(abi.encodePacked(text, num, addr)) ;
    }

    //对比一下encodePacked和encode的区别
    //不定长的变量全部都需要写存储的位置memory 还是 storage
    function encode(string memory text0, string memory text1) external pure returns(bytes memory){
        return abi.encode(text0, text1) ;
    }
    //encodePacked是一种不安全的打包方式，它只是把数据加在一起不会补零，encode会补零
    //这样的话“AAA”“ABB”和“AAAA”“BB”打包结果一样，最后生成的哈希也一样，这就产生了哈希碰撞
    //解决方法：可以换encode，或者在两种同类型的变量中间增加一种其他的数据类型，“AAA”, 123, “ABB”
    function encodePacked(string memory text0, string memory text1) external pure returns(bytes memory){
        return abi.encodePacked(text0, text1) ;
    }
}
