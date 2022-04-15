//SPDX-License-Identiifer:MIT
pragma solidity ^0.8.7 ;
//先定义接口
interface Icounter {
    function count() external view returns(uint) ;
    function inc() external ;
}

contract callInterface{
    uint public count ;
    function example(address _counter) external {
        //注意接口的调用，需要传入接口函数所在的合约地址
        Icounter(_counter).inc() ;
        count = Icounter(_counter).count() ;
    } 
}
//接口调用的合约
//SPDX-License-Identiifer:MIT
// pragma solidity ^0.8.7 ;
// contract Count{
//     uint public count ;
//     function inc() external {
//         count += 1 ;
//     }
//     function dec() external{
//         count -= 1 ;
//     }   
// }
