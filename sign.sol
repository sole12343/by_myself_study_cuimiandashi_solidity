//SPDX-License-Identifier:MIT
pragma solidity ^0.8.3 ;
//通过智能合约验证签名
/*步骤：
0. message to sign
1. hash(message)
2. hash(hash(message) , private key) ||off chain
3. ecrecover(hash(message), signature) == signer
*/


contract verifySig {
    //验证签名地址、签名的信息、签名码是否一致，一致返回true
    function verify(address _signer , string memory _message , bytes memory _sig ) external pure returns(bool) {
        bytes32 messageHash = getMessageHash(_message) ;
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash) ;

        return recover(ethSignedMessageHash, _sig) == _signer ;
    }

    //获得信息的哈希值
    function getMessageHash(string memory _message) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_message)) ;
    }
    //要对message增加字符串进行第二次哈希，因为一次哈希是不安全的，获得eth签名
    function getEthSignedMessageHash(bytes32  _messageHash) public pure returns(bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",_messageHash)) ;
    }
    //根据eth签名和签名码，解析出签名地址
    function recover(bytes32 _ethSignedMessageHash , bytes memory _sig) public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v ) = _split(_sig) ;
        return ecrecover(_ethSignedMessageHash , v, r, s) ;
    }
    //内联汇编代码，根据bytes字符位置，解析出r,s,v
    function _split(bytes memory _sig ) internal pure returns(bytes32 r, bytes32 s, uint8 v ){
        require(_sig.length == 65 , "invalid signature length ") ;
        assembly {
            r := mload(add(_sig , 32)) 
            s := mload(add(_sig , 64)) 
            v := byte(0, mload(add(_sig , 96))) 
        }
    }

}
