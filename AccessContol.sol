//SPDX-License-Identifier:MIT
pragma solidity ^0.8.10 ;
//利用智能合约修改权限
contract AccessControl {
    //授予权限事件
    event GrantRole(bytes32 indexed role , address indexed account) ;
    //解除权限事件
    event RevokeRole(bytes32 indexed role , address indexed account) ;
    //role => account => bool
    mapping(bytes32 => mapping(address => bool)) public roles ;
    //先设定public获取ADMIN的哈希，再设置为private可以降低gas
    //0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant ADMIN  = keccak256(abi.encodePacked("ADMIN")) ;
    //0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private constant USER  = keccak256(abi.encodePacked("USER")) ;
    //函数修改器，限制没有权限的人调用外部函数
    modifier onlyRole(bytes32 _role ){
        require(roles[_role][msg.sender],"not authorized") ;
        _;
    }
    constructor(){
        //构造函数要给自己ADMIN权限，否则所有人都没有ADMIN权限
        //此处可以看出为什么要写内部函数+外部函数，没有内部函数无法给自己权限的同时保证安全
        _grantRole(ADMIN , msg.sender) ;
    }
    //内部函数授权
    function _grantRole(bytes32 _role , address _account) internal {
        roles[_role][_account] = true ;
        emit GrantRole(_role , _account) ;
    }
    //外部函数授权
    function grantRole(bytes32 _role , address _account) external onlyRole(ADMIN) {
        _grantRole(_role, _account) ;
    }
    //外部函数取消授权
    function _revokeRole(bytes32 _role , address _account) external onlyRole(ADMIN) {
        emit RevokeRole(_role , _account) ;
        roles[_role][_account] = false ;
        emit RevokeRole(_role , _account) ;
    }

}
