// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract nftClass is Ownable{
    //class合约继承Ownable，所以可以进行转移owner权限

    bool public burnable;//是否可销毁
    bool public transferable;//是否可转账
    bool public mintable;//是否可增发
    bool public frozen;//属性（1，2，3，4）是否可变更
    uint32 public classId;//classId代表属于类的id号

    mapping(address => uint32) public classIdMap;//将各个nft系列的合约地址映射到classId上

    //将其他的所有NFT集合的属性都加上映射，那么通过class合约可以看到所有nft的性质
    mapping(uint32 =>bool) public idBurnable;
    mapping(uint32 =>bool) public idTransferable;
    mapping(uint32 =>bool) public idMintable;
    mapping(uint32 =>bool) public idFrozen;

    //此函数：更新当前映射，所有的nft的类别在当前合约都可以查询到，当新的Nft创建的时候会自动call此函数，将新的映射加入
    //注意：此函数必须只有owner才可以调用，否则会被人随意改变，但是onlyOwner不能使用
    //因为我们采用call才可以更改当前合约的状态变量，delegatecall的上下文就不是此合约了
    //可是采用call msg.sender也变成了nft合约并不是调用者，所以无法使用onlyOwner
    function update(bool _burnable,
                    bool _transferable,
                    bool _mintable,
                    bool _frozen,
                    uint32 _classId,
                    address _myNft
                    ) public returns(bool,uint) {
                require(tx.origin == owner(), "Not owner");
                //此处可能会被人攻击，不过只要owner有一定的防范意识即可，我不能加上onlyOwner修饰符，因为只能采用call方式来修改map
                classIdMap[_myNft] = _classId;
                idBurnable[_classId] = _burnable;
                idFrozen[_classId] = _frozen;
                idMintable[_classId] = _mintable;
                idTransferable[_classId] = _transferable;
                return(true,1);
    }

}

//这是一个OpenZeppelin上的最简单的NFT合约，作为案例
contract MyNFT is  Ownable, nftClass,ERC721 {
    //此处继承的是最新版本的ERC721合约，支持mint,burn等功能
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //构造函数：需要传入所有属性+classId+nftClass的地址，因为一旦创建新的nft就会修改class合约内部的映射
    constructor(bool _burnable,
                bool _transferable,
                bool _mintable,
                bool _frozen,
                uint32 _classId,
                address _nftClass
                ) ERC721("MyNFT", "NFT") {
                    burnable = _burnable;
                    transferable = _transferable;
                    mintable = _mintable;
                    frozen = _frozen;
                    classId = _classId;
                    callUpdate( _nftClass, _burnable,_transferable, _mintable,_frozen);
                }


    // 是否可增发， false表示该Class的owner不可以再mint归属该系列的新的nft 
    function mint(address _to, uint256 tokenId) external onlyOwner{
        require(mintable,"no mint more!");
        //新铸造nftid号nft到指定地址to
        _mint(_to, tokenId);
    }

    //是否可销毁，false表示归属该Class的nft不允许holder销毁
    function burn( uint tokenId) external {
        require(burnable,"no burn!");
        //将nftid的NFT发送到0地址
        _burn(tokenId);
    }

    //是否可转账， false表示归属该Class的nft都不允许holder转移给他人 （有些nft定义为纪念章的存在，不允许转让）
    //先定义一个函数修改器，限制转移的条件
    modifier Onlytransferable(){
        require(transferable,"no transfer!");
        _;
    }
    //对ERC721中的核心转账语句进行重写，加上转移限制条件，那么ERC721的所有转账方法都需要在这个条件下才能转账
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual override Onlytransferable{
        _transfer(from, to, tokenId);
    }


    //属性（1，2，3，4）是否可变更, 如果frozen是true,可以修改合约的属性值,否则无法修改
    //此函数：call调用nftClass合约的update方法，必须只有owner才可以调用
    function callUpdate(address _nftClass,
                        bool _burnable,
                        bool _transferable,
                        bool _mintable,
                        bool _frozen
                        ) public onlyOwner{
        address myNft = address(this);
        uint32 _classId = classId;
        (bool success, bytes memory data) = _nftClass.call(
             abi.encodeWithSelector(nftClass.update.selector,
             _burnable, _transferable, _mintable, _frozen,_classId,myNft)
        );
        require(success, "call failed") ;
        
    }
    //此函数：改变当前nft的属性，只有owner才可以调用
    function change(
        bool _burnable,
        bool _transferable,
        bool _mintable,
        bool _frozen,
        address _nftClass
    ) external onlyOwner{
        require(frozen,"no change!");
        burnable = _burnable;
        transferable = _transferable;
        mintable = _mintable;
        frozen = _frozen;
        //当发生修改时，映射也要发生相应的修改
        callUpdate( _nftClass, _burnable,_transferable, _mintable,_frozen);
    }
}