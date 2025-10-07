// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BeggingContract {
    address public owner;
    mapping(address=>uint256) private amountMapping;

    event Donated(address indexed donater, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    constructor(){
        owner=msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender==owner,"not owner");
        _;
    }

    function donate () external payable{
        require(msg.value>0,"there must be something be donated");
        amountMapping[msg.sender] +=msg.value;
        emit Donated(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "no eth need to be withdrawn");
        payable(owner).transfer(balance);
        emit Withdrawn(owner, balance);
    }

    function getDonation (address donater) public view returns (uint256){
        return amountMapping[donater];
    }

}