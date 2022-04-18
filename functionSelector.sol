//SPDX-License-Identifier:MIT
pragma solidity ^0.8.10 ;

contract functionSelector{
    //"transfer(address,uint256)"
    //对于下面函数输入上面的string，输出0xa9059cbb
    function getSelector(string memory _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}



contract Receive{
    event Log(bytes data) ;

    function transfer(address _to , uint _amount) external {
        //msg.data代表合约向虚拟机传输的data，前4位代表这个函数的名字+传入的变量数据类型
        //0xa9059cbb
        //0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4  地址
        //000000000000000000000000000000000000000000000000000000000000000b  传入的数字
        emit Log(msg.data) ;
    }
}
