//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
//把合约权限交给时间锁合约，任何用户都必须等待时间到达才能进行下一步操作
//时间锁合约的主要功能：
//在(min,max)这个区间内，可以把想要执行的合约函数放入时间锁队列并且配上 想在什么时间执行time
//当时间time没到或者超出界限，这个函数谁也无法执行
//如果time到了，时间锁合约可以执行那个函数
contract TimeLock{
    address public owner ;
    mapping(bytes32 => bool) public queued ;

    error NotOwnerError();
    error AlreadyQueuedError(bytes32 txId);
    error TimestampNotInRangeError(uint blockTimestamp, uint timestamp);
    error NotQueuedError(bytes32 txId);
    error TimeStampNotPassedError(uint blockTimestamp, uint timestamp);
    error TimestampExpeiredError(uint blockTimestamp, uint expiresAt);
    error TxFailedError();

    event Queue(bytes32 indexed txId ,
                address indexed target , 
                uint value , 
                string  func , 
                bytes  data , 
                uint timestamp);
    event Execute(bytes32 indexed txId ,
                address indexed target , 
                uint value , 
                string  func , 
                bytes  data , 
                uint timestamp);
    event Cancel(bytes32 indexed txId);

    uint public constant MIN_DELAY = 10 ;
    uint public constant MAX_DELAY = 1000 ;
    uint public constant GRACE_PERIOD = 1000 ;
    constructor(){
        owner = msg.sender ;
    }

    receive() external payable{

    }

    modifier onlyOwner(){
        if(msg.sender != owner){
            revert NotOwnerError();
        }
        _;
    }

    function getTxId(
        address _target , uint _value , string calldata _func , bytes calldata _data , uint _timestamp)
        public returns(bytes32 txId){
            return keccak256(
                abi.encode(_target, _value, _func, _data, _timestamp)
            );
    }

    function queue(
        address _target , uint _value , string calldata _func , bytes calldata _data , uint _timestamp
        ) external onlyOwner {
            //create txId
            bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
            //check txId is unique
            if(queued[txId]){
                revert AlreadyQueuedError(txId);
            }
            //check timestamp 必须在min--max这个区间之内才是有效的
            //---|------------|--------------|----
            // block     block + min   block + max
            if(
                _timestamp < block.timestamp + MIN_DELAY ||
                _timestamp > block.timestamp + MAX_DELAY
            ){
                revert TimestampNotInRangeError(block.timestamp, _timestamp);
            }

            //queue tx
            queued[txId] = true ;
            emit Queue(txId, _target, _value, _func, _data, _timestamp);
        
    }

    function execute(
        address _target , uint _value , string calldata _func , bytes calldata _data , uint _timestamp) 
        external payable onlyOwner returns(bytes memory){
            bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
            //check tx is unique
            if(!queued[txId]){
                revert NotQueuedError(txId);
            }
            //check block.timestamp > _timestamp
            if(block.timestamp < _timestamp){
                revert TimeStampNotPassedError(block.timestamp , _timestamp);
            }
            //-----|----------------------|---------------(在宽限期之内执行都可以，超过宽限期无法执行)
            //    timestamp     timestamp + grace period
            if(block.timestamp > _timestamp + GRACE_PERIOD){
                revert TimestampExpeiredError(block.timestamp , _timestamp + GRACE_PERIOD);
            }
            //delete tx from queue
            queued[txId] = false ;
            
            bytes memory data ;
            if(bytes(_func).length > 0){
                data = abi.encodePacked(
                    bytes4(keccak256(bytes(_func))), _data
                );
            }else{//假如这个函数是对方合约的回退函数
                data = _data ;
            }

            //execute the tx
            (bool ok , bytes memory res) = _target.call{value:_value}(data);
            if (!ok){
                revert TxFailedError() ;

            }
            emit Execute(txId, _target, _value, _func, _data, _timestamp);
            return res ;
    }
    //合约拥有者可以取消任何tx
    function cancel(bytes32 _txId) external onlyOwner {
        if(!queued[_txId]){
            revert NotQueuedError(_txId);
        }
        queued[_txId] = false ;
        emit Cancel(_txId) ;
    }
}

contract TestTimeLock {
    address public timeLock ;

    constructor(address _timeLock){
        timeLock = _timeLock;
    }

    function test() external{
        require(msg.sender == timeLock);
        //more code here such as:
        //-upgrade contract
        //-transfer funds
        //-switch price oracle
    }

    function getTimestamp()external view returns(uint){
        return block.timestamp + 100 ;
    }
}
