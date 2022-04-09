//SPDX-Lincense-Identifier:MIT
pragma solidity ^0.8.7 ;

//映射mapping 包括简单映射和嵌套映射
//simple and nested
//Set , Get , Change , delete

//{"0x1..." : 1 , "0x2..." : 2 , "0x3..." : 3} 查询地址余额
contract Mapping {
    mapping(address => uint) public balances ;
    mapping(address => mapping(address => bool)) public isFirend ;

    function examples() external {
        balances[msg.sender] = 123 ;//set
        uint bal = balances[msg.sender] ;//get
        uint bal2 = balances[address(1)] ;//没有赋值的话就是uint的默认值为0

        balances[msg.sender] += 456 ; //change 123+456

        delete balances[msg.sender] ;//delete 0

        isFirend[msg.sender][address(this)] = true ;

    }
}
