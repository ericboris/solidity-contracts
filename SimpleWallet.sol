// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./Allowance.sol";

contract SimpleWallet is Ownable, Allowance {
    event Deposit(address indexed _sender, uint _amount, uint _newBalance);
    event Withdrawl(address indexed _sender, uint _amount, uint _newBalance);

    /**
     * @dev Deposit funds to contract.
     */
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    /**
     * @dev Return the funds in the contract.
     */
    function getFunds() public view onlyOwner returns(uint) {
        return address(this).balance;
    }

    /**
     * @dev Withdraw funds from contract.
     */
    function withdraw(uint _amount) public {
        require(msg.sender == owner() || allowances[msg.sender] > 0, "Must be owner or have an allowance.");
        require(address(this).balance >= _amount, "Insufficient funds in contract.");
        // A non-owner withdrawl decreases that account's allowance.
        if (msg.sender != owner()) {
            require(allowances[msg.sender] >= _amount, "Insufficient funds in allowance.");
            collect(_amount);
        }
        payable(msg.sender).transfer(_amount);
        emit Withdrawl(msg.sender, _amount, address(this).balance);
    }

    /**
     * @dev Overide OpenZeppelin's Ownable and Allowance's renounceOwnership.
     */
    function renounceOwnership() override(Ownable, Allowance) public virtual onlyOwner {
        revert("Ownership cannot be renounced.");
    }
}
