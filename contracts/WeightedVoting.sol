// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public maxSupply = 1000000;

    // Errors
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    // Struct for Issue (variables must be in this exact order)
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    // Struct for returning issue data (without EnumerableSet)
    struct ReturnableIssue {
        address[] voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }


    // Enum for Vote
    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    // Array of issues
    Issue[] issues;

    // Track who has claimed tokens
    mapping(address => bool) public hasClaimed;

    // Constructor
    constructor() ERC20("WeightedVoting", "WV") {
        // Burn the zeroeth element by pushing an empty issue
        issues.push();
    }

    // Claim function
    function claim() public {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (totalSupply() >= maxSupply) {
            revert AllTokensClaimed();
        }

        hasClaimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    // Create Issue function
    function createIssue(string calldata _issueDesc, uint256 _quorum) 
        external 
        returns (uint256) 
    {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        newIssue.passed = false;
        newIssue.closed = false;

        return issues.length - 1;
    }

    // Get Issue function
    function getIssue(uint256 _id) 
        external 
        view 
        returns (ReturnableIssue memory) 
    {
        Issue storage issue = issues[_id];
        
        // Convert EnumerableSet to array
        uint256 voterCount = issue.voters.length();
        address[] memory voterArray = new address[](voterCount);
        for (uint256 i = 0; i < voterCount; i++) {
            voterArray[i] = issue.voters.at(i);
        }

        return ReturnableIssue({
            voters: voterArray,
            issueDesc: issue.issueDesc,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            totalVotes: issue.totalVotes,
            quorum: issue.quorum,
            passed: issue.passed,
            closed: issue.closed
        });
    }

    // Vote function
    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage issue = issues[_issueId];

        if (issue.closed) {
            revert VotingClosed();
        }
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 voterBalance = balanceOf(msg.sender);
        
        // Add voter to the set
        issue.voters.add(msg.sender);

        // Add votes based on vote type
        if (_vote == Vote.FOR) {
            issue.votesFor += voterBalance;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else {
            issue.votesAbstain += voterBalance;
        }

        issue.totalVotes += voterBalance;

        // Check if quorum is reached
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}