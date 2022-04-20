//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//静态调用不会涉及到写入，动态调用可能需要写入，函数标注是view
//案例：先部署TestMultiCall，再用MultiCall合约多重调用TestMultiCall


contract TestMultiCall{
    function func1() external view returns(uint , uint) {
        return (1, block.timestamp) ;
    }
    function func2() external view returns(uint , uint) {
        return (2, block.timestamp) ;
    }
    function getData1() external pure returns(bytes memory){
        //下面代码等价于abi.encodeWithSignature("func1()")
        return abi.encodeWithSelector(this.func1.selector) ;
    }
    function getData2() external pure returns(bytes memory){
        //下面代码等价于abi.encodeWithSignature("func1()")
        return abi.encodeWithSelector(this.func2.selector) ;
    }
}

contract MultiCall{
    //targets[]这个地址数组是想要调用的函数所在的合约的地址
    function multiCall(address[] calldata targets , bytes[] calldata data) 
    external 
    view 
    returns(bytes[] memory){
        require(targets.length == data.length , "targets != data" );
        bytes[] memory results = new bytes[](data.length) ;

        for (uint i ; i < targets.length ; i++){
            //对——对应地址的合约下的函数采取静态调用
            (bool success , bytes memory result) = targets[i].staticcall(data[i]) ;
            require(success , "call failed");
            results[i] = result ;
        }
        return results ;
    }
}
