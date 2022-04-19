//SPDX-License-Identifier:MIT
pragma solidity ^0.8.10 ;

import "./IERC20.sol"
contract CrowdFund{

    event Launch(uint id, address indexed creator, uint goal, uint32 startAt, uint32 endAt) ;
    event Cancel(uint id) ;
    event Pledge(uint indexed id , address indexed caller , uint amount ) ;
    event UnPledge(uint indexed id , address indexed caller , uint amount ) ;
    event Claim(uint id) ;
    event Refund(uint indexed id , address indexed caller , uint amount ) ;


    struct Campaign {
        address creator ;
        uint goal ;    //目标筹款
        uint pledged ; //已经参与的众筹款
        uint32 startAt ;
        uint32 endAt ;
        bool claimed ; //是否领取众筹款
    }

    IERC20 public immutable token ;
    uint public count ;
    mapping(uint => Campaign) public campaigns ;
    mapping(uint => mapping(address => uint)) public pledgedAmount ;//id-地址-承诺支持的数量

    constructor(address _token){
        token = IERC20(_token) ;
    }
    //发起众筹活动函数
    function launch(uint _goal , uint32 _startAt , uint32 _endAt) external {
        require(_startAt >= block.timestamp , "start at < now") ;
        require(_endAt >= _startAt , "end < start") ;
        require(_endAt <= block.timestamp + 90 days , "end at > max duration") ;
        count += 1 ;
        campaigns[count] = Campaign({
            creator: msg.sender ,
            goal: _goal ,
            pledged: 0 ,
            startAt: _startAt ,
            endAt: _endAt ,
            claimed: false
        });
        emit Launch(count , msg.sender , _goal , _startAt , _endAt) ;
    }
    //发起众筹人取消众筹
    function cancel(uint _id) external {
        Campaign storage campaign = campaigns[_id] ;
        require(campaign.creator == msg.sender , "not creator") ;
        require(block.timestamp < campaign.startAt , "started") ;
        delete campaigns[_id] ;
        emit Cancel(_id) ;
    }
    //出价参与众筹
    function pledge(uint _id , uint _amount) external {
        Campaign storage campaign = campaigns[_id] ;
        require(block.timestamp >= startAt , "not started");
        require(block.timestamp <= endAt, "ended") ;

        campaign.pledged += _amount ;
        pledgedAmount[_id][msg.sender] += _amount ;
        token.transferFrom(msg.sender , address(this) , _amount) ;
        emit Pledge(_id , msg.sender , _amount) ;
    }
    //个人取消众筹份额
    function unpledge(uint _id , uint _amount) external {
        Campaign storage campaign = campaigns[_id] ;
        require(block.timestamp <= campaign.endAt, "ended") ;

        campaign.pledged -= _amount ;
        pledgedAmount[_id][msg.sender] -= _amount ;
        token.transfer(msg.sender , _amount) ;

        emit Unpledge(_id , msg.sender , _amount) ;
    }
    //众筹完美结束后创建者可以领取代币
    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id] ;
        require(msg.sender == campaign.creator , "not creator ") ;
        require(block.timestamp > campaign.endAt , "not ended" ) ;
        require(campaign.pledged >= campaign.goal , "pledged < goal") ;

        campaign.claimed = true ;
        token.transfer(msg.sender , campaign.pledged) ;
        emit Claim(msg.sender , campaign.pledged) ;
    }
    //众筹没有达到目标，用户可以领回代币
    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id] ;
        require(block.timestamp > campaign.endAt , "not ended" ) ;
        require(campaign.pledged < campaign.goal , "pledged > goal") ;

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0 ;
        token.transfer(msg.sender , bal) ;

        emit Refund(_id, msg.sender, bal) ;
    }

}
