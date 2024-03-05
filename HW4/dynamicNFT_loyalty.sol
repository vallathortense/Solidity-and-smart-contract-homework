// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// @title Dynamic NFT with loyalty reawrds
// @dev As users become more loyal, they get more tokens. When users have a loyalty level higher than 20 then the contract emits a reward for an exclusive party

contract DynamicNFT is ERC721, AccessControl {

    // Addresses authorized to have evolving tokens (encrypt the EVOLVE_ROLE with hash)
    bytes32 public constant EVOLVE_ROLE = keccak256("EVOLVE_ROLE");

    // Token ID counter to keep track of the token IDs
    uint256 private tokenIdCounter;

    // Associate each user's address to their loyalty level and the additional tokens they earn
    mapping(address => uint256) private loyaltyLevels;
    mapping(address => uint256) private additionalTokens;

    // @dev Constructor that sets up the contract by initializing the ERC token.
    // @param defaultAdmin The address to be granted the default admin role.
    constructor(address defaultAdmin) ERC721("DynamicNFT", "dNFT") {
        _setupRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
    }

    // @dev Function to mint a new dNFT to a user.
    // @param to The address to which the NFT will be minted.
    // @param tokenIdCounter The token ID to be assigned.
    function safeMint(address to, uint256 tokenIdCounter) external {
        _safeMint(to, tokenIdCounter);
        tokenIdCounter++;
        _RewardAction(to, loyaltyLevels[to]);
    }

    // @dev Function to evolve the NFT rewards for a specific user. Only authorized addresses with the EVOLVE_ROLE can call this function.
    // @param user The user's address to evolve the rewards.
    function evolve(address user) external onlyRole(EVOLVE_ROLE) {
        // Increase the loyalty level for the user and get the reward associated to this level of loaylty
        loyaltyLevels[user]++;
        _RewardAction(user, loyaltyLevels[user]);
    }

    // @dev Internal function to perform the reward action based on loyalty level.
    // @param user The user's address to receive the reward.
    // @param loyaltyLevel The loyalty level of the user.
    function _RewardAction(address user, uint256 loyaltyLevel) internal {
        // Give additional tokens based on loyalty level
        uint256 additionalTokenAmount = loyaltyLevel * 2;
        additionalTokens[user] += additionalTokenAmount;

        // Check if the loyalty level is high enough to grant access to an exclusive party
        if (loyaltyLevel > 20) { // I took 20 as an example
            emit ExclusivePartyAccessGranted(user);
        }

        emit RewardAction(user, loyaltyLevel, additionalTokenAmount);
    }

    // @dev Function to get the additional tokens for a user.
    // @param user The user's address.
    // @return The amount of additional tokens for the user.
    function getAdditionalTokens(address user) external view returns (uint256) {
        return additionalTokens[user];
    }

    // @dev Event to track loyalty reward actions.
    // @param user The user's address.
    // @param loyaltyLevel The loyalty level of the user.
    // @param additionalTokens The additional tokens rewarded to the user.
    event RewardAction(address indexed user, uint256 loyaltyLevel, uint256 additionalTokens);
    // @dev Event to track exclusive access party granted.
    // @param user The user's address.
    event ExclusivePartyAccessGranted(address indexed user);
}