//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

//常量消耗的gas远比变量的低
//虽然读取view不消耗gas，但是其他合约的读取变量过程是消耗gas的
//gas 	21442
contract constants{
    address public constant MY_ADDRESS = 0x6E361Bd7eab67bcf10b86235E59f399c190111Cd ;
    uint public constant MY_UINT = 100 ;
}
//gas 23553 
contract var2 {
    address public MY_ADDRESS2 = 0xe594955783f72afD89588Eddf271A4F1BCb23b9d ;
}
