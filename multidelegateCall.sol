//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//委托调用合约不能单独存在，只能委托调用自己的合约
contract MultiDelegateCall {
    error DelegatecallFailed() ;
    function multiDelegatecall(bytes[] calldata data) 
    external payable returns(bytes[] memory results){
        results = new bytes[](data.length) ;

        for (uint i ; i < data.length ; i++ ){
            (bool ok , bytes memory res) = address(this).delegatecall(data[i]) ;
            if(!ok){
                revert DelegatecallFailed() ;
            }
            results[i] = res ;
        }
        return results;
    }
}
//why use multi delegatecall ? why not multicall ?
//alice -> multicall --- call -->test(msg.sender = multicall )
//alice -> test --- delegate call -->test(msg.sender = alice )
//让测试合约继承委托调用合约，用委托调用是因为显示出调用者是我自己而不是合约地址
contract TestMultiDelegateCall is MultiDelegateCall {
    event Log(address caller , string func , uint i) ;
    function func1(uint x , uint y) external {
        emit Log(msg.sender , "func1" , x+y ) ;
    }

    function func2() external returns ( uint ) {
        emit Log(msg.sender , "func2" , 2 ) ;
        return 111 ;
    }
}
//委托调用也需要传入 函数的机器码，这个合约可以获得机器码
contract Helper{
    function getfunc1Data(uint x , uint y) external pure returns(bytes memory){
        //下面代码等价于abi.encodeWithSignature("func1()")
        return abi.encodeWithSelector(TestMultiDelegateCall.func1.selector,x,y) ;
    }
    function getfunc2Data() external pure returns(bytes memory){
        //下面代码等价于abi.encodeWithSignature("func1()")
        return abi.encodeWithSelector(TestMultiDelegateCall.func2.selector) ;
    }
}
