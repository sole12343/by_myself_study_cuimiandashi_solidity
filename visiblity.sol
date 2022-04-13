//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;
//visibility 
//private  只有合约内可见
//internal 只有合约内 和 继承的子合约 可见
//public   合约内和合约外都可见
//external 只有合约外部可见，只能被其他调用该合约的合约访问，合约内部无法访问，重写也不行

/*  
A:                      <-----外部的合约B能见的只有
private                       public 
internal                      external
public
external


B is A 继承的子合约B能看见的只有
internal
public
*/

contract VisibilityBase {
    uint private x = 0 ;
    uint internal y = 1 ;
    uint public z = 2 ;

    function privateFunc() private pure returns(uint){return 1 ;}
    function internalFunc() internal pure returns(uint){return 10 ;}
    function publicFunc() public pure returns(uint){return 100 ;}
    function externalFunc() external pure returns(uint){return 1000 ;}

    function example() external view {
        x + y + z ;
        privateFunc() ;
        internalFunc() ;
        publicFunc() ;
        this.externalFunc() ;//运用this方法可以访问本合约的外部函数，但是也是通过合约外访问的，会增加gas
    }
}

contract VisibilityChild is VisibilityBase {
    function example2() external view {
        y + z ;
        internalFunc() ;
        publicFunc() ;
    }

}
