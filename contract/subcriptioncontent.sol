// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SubscriptionPlatform is Ownable {
    struct Subscriber {
        uint256 start;
        uint256 duration;
        bool isActive;
    }

    mapping(address => Subscriber) public subscribers;
    uint256 public fee = 0.01 ether;
    uint256 public duration = 30 days;

    event Subscribed(address indexed user, uint256 start, uint256 duration);
    event SubscriptionCancelled(address indexed user);

    constructor() Ownable(msg.sender) {} // <-- Pass deployer as the owner

    // Function 1: Subscribe to the platform
    function subscribe() external payable {
        require(msg.value == fee, "Incorrect fee");
        subscribers[msg.sender] = Subscriber(block.timestamp, duration, true);
        emit Subscribed(msg.sender, block.timestamp, duration);
    }

    // Function 2: Check if user is subscribed
    function isSubscribed(address user) public view returns (bool) {
        Subscriber memory sub = subscribers[user];
        return sub.isActive && (block.timestamp <= sub.start + sub.duration);
    }

    // Function 3: Cancel subscription manually
    function cancelSubscription() external {
        require(subscribers[msg.sender].isActive, "No active subscription");
        subscribers[msg.sender].isActive = false;
        emit SubscriptionCancelled(msg.sender);
    }

    // Function 4: Owner can update fee
    function updateFee(uint256 newFee) external onlyOwner {
        fee = newFee;
    }

    // Function 5: Withdraw contract balance
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

