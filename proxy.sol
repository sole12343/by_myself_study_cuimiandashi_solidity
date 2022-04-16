//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

contract TestContract1{
    address public owner = msg.sender ;

    function setOwner(address _owner) public{
        require(msg.sender == owner, "not owner") ; 
        owner = _owner ;
    }
}

contract TestContract2 {
    address public owner = msg.sender ;
    uint public value =  msg.value ;
    uint public x ;
    uint public y ;

    constructor (uint _x , uint _y) payable{
        x = _x ;
        y = _y ;
    }
}

contract Proxy {
    event Deploy(address) ;

    fallback() external payable{} 

    function deploy(bytes memory _code) external payable returns(address addr){
        //部署一个合约 new TestContract1() ; 但是想要部署其他多个合约，还需要重新部署proxy合约并且修改合约内容
        //想要：直接可以传入合约的机器码，然后直接部署合约，换个机器码也不需要重新部署proxy
        //这里是内联汇编语言：
        assembly{
            //create(v, p, n)
            //v = amount of ETH to send
            //p = 内存中代码起始的位置
            //n = size of code
            addr := create(callvalue() , add( _code, 0x20) , mload(_code) )
        }
        require(addr != address(0) , "deploy failed") ; 
        emit Deploy(addr) ; 
    }

    function execute(address _target , bytes memory _data) external payable {
        (bool success , ) = _target.call{value: msg.value}(_data) ;
        require(success , "failed") ;
    }
}
//获得想要部署的合约的机器码bytes
contract Helper{
    //对于测试合约1直接获取就可以
    function getBytescode1() external pure returns(bytes memory){
        bytes memory bytecode = type(TestContract1).creationCode;
        return bytecode ;
    }
    //测试合约2的构造函数有两个参数，参数是连在bytecode后面的两个，用这种方法获取
    function getBytescode2(uint _x , uint _y) external pure returns(bytes memory){
        bytes memory bytecode = type(TestContract2).creationCode ;
        return abi.encodePacked(bytecode, abi.encode(_x , _y)) ;
    } 
    function getCalldata(address _owner) external pure returns(bytes memory) {
        return abi.encodeWithSignature("setOwner(address)" , _owner) ;
    }

}
