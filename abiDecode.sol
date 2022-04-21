//SPDX-License-Identifier:MIT
pragma solidity ^0.8.10 ;
//解码一定要提前知道数据的类型，否则无法解码
contract AbiDecode{
    struct MyStruct{
        string  name ;
        uint[2] nums; 
    }
    function encode(uint x, address addr, uint[] calldata arr, MyStruct memory mystruct) external pure returns (bytes memory) {
        return abi.encode(x, addr, arr, mystruct) ;
    }

    function decode(bytes calldata data) external pure returns(uint x, address addr, uint[] memory arr, MyStruct memory mystruct) {
        (x, addr, arr, mystruct) =  abi.decode(data , (uint , address , uint[], MyStruct ));
    }
}
