// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableContract {
    // Integer Overflow/Underflow vulnerability
    uint256 public balance;

    function addBalance(uint256 amount) public {
        // Vulnerable to overflow in versions before 0.8.0
        balance += amount;
    }

    function subtractBalance(uint256 amount) public {
        // Vulnerable to underflow in versions before 0.8.0
        balance -= amount;
    }

    // Reentrancy vulnerability
    mapping(address => uint256) public userBalances;

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amount = userBalances[msg.sender];
        require(amount > 0, "Insufficient balance");

        // Vulnerable to reentrancy attack
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        userBalances[msg.sender] = 0;
    }

    // Time Dependency vulnerability
    uint256 public constant deadline = 7 days;
    uint256 public startTime;

    function start() public {
        startTime = block.timestamp;
    }

    function performAction() public view returns (string memory) {
        require(block.timestamp >= startTime + deadline, "Action not allowed yet");
        return "Action performed";
    }
}
