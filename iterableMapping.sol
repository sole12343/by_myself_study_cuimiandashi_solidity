//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//迭代映射

contract InterableMapping {
    mapping (address => uint) public balances ;//记录地址的余额 
    mapping (address => bool) public inserted ;//记录该地址是否被计入，是否有余额
    address[] public keys ;//存储所有的 被记录的地址

    function set(address _key , uint _val) external {
        balances[_key] = _val ;

        if(!inserted[_key]){
            inserted[_key] = true ;
            keys.push(_key) ;
        }
    }

    function Getsize() external view returns (uint) {
        return keys.length ;
    }
    function firstbalance() external view returns(uint) {
        return balances[keys[0]] ;
    }
    function lastbalance() external view returns(uint) {
        return balances[keys[keys.length -1]] ;
    }
    function get(uint _i) external view returns(uint) {
        return balances[keys[_i]] ;
    }



}
