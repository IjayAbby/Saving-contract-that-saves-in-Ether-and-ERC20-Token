// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./Interfaces/IERC20.sol";


contract SaveEtherErc {
    address savingToken;
    address owner;

    event WithdrawSuccessful(address receiver, uint256 amount);

    mapping(address => uint256) etherSavings;
    mapping(address => uint256) erc20Savings;
    
    constructor(address _savingToken) public{
        require(_savingToken != address(0),"Zero Address is not allowed");
        owner = msg.sender;
        savingToken = _savingToken;
    }
    
    modifier onlyOwner() { 
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }
    

    function withdrawEther(uint amount) external virtual onlyOwner() {
        payable(owner).transfer(amount);
    }

    function withdrawTokens(address tokenAddress , uint amount) external virtual onlyOwner() {
        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, "Contract does not have enough tokens");
        
        bool success = token.transfer(owner, amount);
        if(!success) {
            revert("Transfer failed");
        }
    }

    function setSavingToken(address _newSavingToken) external virtual onlyOwner() {
        require(_newSavingToken != address(0));
        savingToken = _newSavingToken;
    }

    // function depositToken(uint amount) external virtual {
    //     require(IERC20(savingToken).allowance(msg.sender, address(this)) >= amount,"Please approve first!");
        
    //     IERC20(savingToken).transferFrom(msg.sender, address(this), amount);
    
    //     totalDeposits += amount;
        
    //     deposits[msg.sender] += amount;
        
    //     emit WithdrawSuccessful(msg.sender, amount);
    // }

    // function getUserBalance() public view returns (uint){
    //     return deposits[msg.sender];
    // }

    // function getTotalSupply() public view override returns (uint) {
    //     return totalDeposits;
    // }
}