//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

contract MultiSigWallet{
    event Deposit(address indexed sender , uint amount ) ;
    event Submit(uint indexed txId) ;//提交交易事件，就是把交易打包的操作
    event Approve(address indexed owner , uint indexed txId) ;
    event Revoke(address indexed owner , uint indexed txId) ;//取消授权
    event Execute(uint indexed txId) ;

    struct Transaction{
        address to ;
        uint value ;
        bytes data ;
        bool execute ;
    }

    address[] public owners ;
    mapping (address => bool) public isOwner ;
    uint public required ;

    Transaction[] public transactions ;
    mapping(uint => mapping (address => bool)) public approved ;

    constructor(address[] memory _owners , uint _required){
        require(_owners.length > 0, "owners required") ;
        require(_required > 0 && _required < _owners.length, "invalid required number") ;

        for(uint i ; i < _owners.length ; i++){
            address owner = _owners[i] ;
            require(owner != address(0) , "invalid owner") ;
            require(!isOwner[owner] , "owner is not unique") ;

            isOwner[owner] = true ;
            owners.push(owner) ;
        }
        required = _required ;
    }

    receive() external payable{
        emit Deposit(msg.sender , msg.value) ;
    }
    //多个函数修改器
    modifier onlyOwner() {
        require(isOwner[msg.sender] , "not owner") ;
        _;
    }
    modifier txExists(uint _txId) {
        require(_txId < transactions.length , "tx does not exist") ;
        _;
    }
    modifier notApprove(uint _txId) {
        require(!approved[_txId][msg.sender] , "tx already approve") ;
        _;
    }
    modifier notExecuted(uint _txId) {
        require(transactions[_txId].execute , "tx  already executed") ;
        _;
    }

    function submit(address _to , uint _value , bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            execute: false
        }));
        emit Submit(transactions.length -1) ;
    }

    function approve(uint _txId) external onlyOwner txExists(_txId) notApprove(_txId) notExecuted(_txId) {
        approved[_txId][msg.sender] = true ;
        emit Approve(msg.sender , _txId) ;
    }
    function _getApproveCount(uint _txId) private view returns(uint count){
        for (uint i ; i < owners.length ; i++){
            if(approved[_txId][owners[i]]){count += 1 ;}
        }
    } 
    function execute(uint _txId) external txExists(_txId) notExecuted(_txId) {
        require(_getApproveCount(_txId) > required , "approvals < required") ;
        Transaction storage transaction = transactions[_txId] ;
        transaction.execute = true ;
        (bool success ,) = transaction.to.call{value: transaction.value} (transaction.data) ;
        require(success , "tx failed") ;
        emit Execute(_txId) ;
    }
    function revoke(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId)  {
        require(approved[_txId][msg.sender] , "tx not approve") ;
        approved[_txId][msg.sender] = false ;
        emit Revoke(msg.sender , _txId) ;
    }

}
