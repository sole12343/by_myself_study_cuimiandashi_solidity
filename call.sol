//SPDX-License-Identiifer:MIT
pragma solidity ^0.8.7 ;
contract TestCall{
    string public message ;
    uint public x ;
    event Log(string message) ;
    //当call调用不存在的函数时，会进入回退函数，然后正常运行，最后报事件
    fallback() external payable{
        emit Log("fallback was called") ;
    }
    function foo(string memory _message , uint _x ) external payable returns(bool , uint){
        message = _message ;
        x = _x ;
        return(true , 999) ;
    }
}

contract Call{
    bytes public data ;
    function callfoo(address _test) external payable {
        (bool success , bytes memory _data) = _test.call{value:111 }(
            //注意这里encodeWithSignature里面第一个传的是string，uint必须写uint256
            //后面两个变量是传入的foo函数的值
            abi.encodeWithSignature("foo(string,uint256)","call foo", 123)
        );
        require(success, "call failed") ;
        data = _data ;
    }
    //call一个不存在的函数，如果没有回退函数会直接报错
    function callDoesNotExit(address _test) external {
        (bool success, ) = _test.call(
            abi.encodeWithSignature("doesnotexit()")
        );
        require(success, "call failed2");
    }
}
