//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//此案例用Create2Factory合约去部署DeployWithCreate2合约
contract DeployWithCreate2 {
    address public owner ;
    constructor(address _owner) {
        owner = _owner ;
    }
}

contract Create2Factory{
    event Deploy(address addr) ;

    //create2部署合约函数，主要就是通过salt部署，可以提前计算出合约的地址
    function deploy(uint _salt) external {
        DeployWithCreate2 _contract = new DeployWithCreate2{
            salt : bytes32(_salt)
        }(msg.sender);
        emit Deploy(address(_contract));
    }

    //提前预知用create2部署的合约的地址
    function getAddress(bytes memory bytecode , uint _salt) public view returns(address) {
        //bytecode是源代码合约的机器码哈希值
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff) , address(this) , _salt, keccak256(bytecode)));
        return address(uint160(uint(hash))) ;
    }

    //获取合约的机器码
    function getBytecode(address _owner) public pure returns(bytes memory){
        bytes memory bytecode = type(DeployWithCreate2).creationCode;
        return abi.encodePacked(bytecode , abi.encode(_owner)) ;
    }

}
