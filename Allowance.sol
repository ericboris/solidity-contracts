// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    mapping(address => uint) public allowances;

    event AllowanceChanged(address indexed _byWhom, address indexed _forWhom, uint _amount, uint _newBalance);

    /**
     * @dev Used by the owner to increase someone's allowance.
     */
    function increase(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(msg.sender, _who, _amount, allowances[_who] + _amount);
        allowances[_who] += _amount;
    }

    /**
     * @dev Used by the owner to reduce someone's allowance. 
     */
    function reduce(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(msg.sender, _who, _amount, allowances[_who] - _amount);
        allowances[_who] -= _amount;
    }

    /** 
     * @dev Used by non-owners to collect their allowance.
     */
    function collect(uint _amount) internal {
        emit AllowanceChanged(msg.sender, msg.sender, _amount, allowances[msg.sender] - _amount);
        allowances[msg.sender] -= _amount;
    }

    /**
     * @dev Overides OpenZeppelin's Ownable renounceOwnership.
     */
    function renounceOwnership() override public virtual onlyOwner {
        revert("Ownership cannot be renounced.");
    }
}
