// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract PoroonToken{
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    uint256 public _totalSupply;
    mapping (address => uint256) public _balanceMap;
    mapping (address => mapping (address => uint256)) public _allowanceMap;
    address public owner;

    constructor() {
        owner = msg.sender;
        _totalSupply = 1000000* 10**18;
        _balanceMap[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"only owner can call this");
        _;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account)public view returns(uint256){
        return _balanceMap[account];
    }
    
    function transfer(address to, uint256 amount) public returns(bool){
        require(_balanceMap[msg.sender] >= amount, "Insufficient balance");
        _balanceMap[msg.sender] -= amount;
        _balanceMap[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address _owner, address spender) public view returns (uint256) {
        return _allowanceMap[_owner][spender];
    }
    
    function approve(address spender, uint256 amount)public returns(bool){
        _allowanceMap[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount)public returns(bool){
        require(_allowanceMap[from][msg.sender]>=amount,"Insufficient allowance");
        require(_balanceMap[from] >= amount, "Insufficient balance");
        _allowanceMap[from][msg.sender] -= amount;
        _balanceMap[from] -= amount;
        _balanceMap[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function name() public pure returns(string memory){
        return "Poroon Token";
    }

    function symbol() public pure returns(string memory){
        return "PTK";
    }

    function decimals()public pure returns(uint){
        return 18;
    }

    function mint(address to,uint256 amount)public onlyOwner returns ( bool){
        require(to!= address(0),"mint address can`t be 0");
        _totalSupply += amount;
        _balanceMap[to] += amount;
        emit Transfer(address(0),to,amount);
        return true;
    }
}
