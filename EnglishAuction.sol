// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface IERC721{
    function transferFrom(address _from , address _to  , uint _nftId) external ;
}

contract EnglishAuction {
    event Start() ;
    event Bid(address indexed sender ,uint amount) ;
    event Withdraw(address indexed bidder ,uint amount) ;
    event End(address highestBidder ,uint amount) ;

    IERC721 public immutable nft ; 
    uint public immutable nftId ;

    address public  immutable seller ; //部署合约的人就是想卖NFT的人
    uint32 public  endAt ;     //结束时间
    bool public started ;      //是否开始
    bool public ended ;        //是否结束

    address public highestBidder ; //最高出价人地址
    uint public highestBid ;       //最高出价价格
    mapping (address => uint ) public bids ;//出价人对应出价的映射

    constructor(address _nft, uint _nftId , uint _startingBid ){
        nft = IERC721(_nft) ;
        nftId = _nftId ;
        seller = payable(msg.sender) ;
        highestBid = _startingBid ;
    }
    //开始 将NFT转到此合约
    function start() external {
        require(msg.sender == seller , "not seller") ;
        require(!started , "already started");

        started = true ;
        endAt = uint32(block.timestamp + 120) ;
        nft.transferFrom(seller , address(this) , nftId) ;
        emit Start() ;
    }
    //出价 出一个大于最高价的价格，计入映射
    function bid() external payable{
        require(started, "not started") ;
        require(block.timestamp < endAt , "ended") ;
        require(msg.value > highestBid ,"value < highestBid") ;
        if (highestBidder != address(0)){       //不是0地址，代表有人出价
            bids[highestBidder] += highestBid ; //如果同一个人多次出价，那么最高价购买nft，其余出价的钱也需要统计，最后归还，用+=
        }
        highestBid = msg.value ;
        highestBidder =msg.sender ;
        emit Bid(msg.sender , msg.value) ;
    }

    function withdraw() external {
        uint bal = bids[msg.sender] ;
        bids[msg.sender] = 0 ;              //先将bids值改为0，再转账，否则有安全问题
        payable(msg.sender).transfer(bal) ;
        emit Withdraw(msg.sender , bal) ;
    }

    function end() external {
        require(started , "not start") ;
        require(!ended , "ended") ;
        require(block.timestamp > endAt , "not ended") ;

        ended = true ;
        if(highestBidder != address(0)){          //代表有人出价，把nft发给这个出价的
            nft.transferFrom(address(this) , highestBidder , nftId) ;
            payable(seller).transfer(highestBid) ;//把最高出价数量的ETH发给seller
        }else{
            nft.transferFrom(address(this) , seller , nftId) ;//代表没有人出价，把nft返回给自己
        }
        emit End(highestBidder , highestBid) ;
        
    }

}
