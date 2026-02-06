// SPDX-License-Identifier: GPL-3.0 
pragma solidity >= 0.4.16 < 0.9.0;

contract Voting{
    struct Vote{
        address receiver;
        uint timestamp;
    }
    mapping(address => Vote) public votes;
    bool public voting;
    event AddVote(address indexed voter, address indexed receiver, uint256 timestamp);
    event RemoveVote(address indexed voter);
    event StartVoting(address indexed startedby);
    event StopVoting(address indexed stoppedby);

    constructor(){
        voting = false;
    }
    function startVoting() external returns (bool){
        voting = true;
        emit StartVoting(msg.sender);
        return true;
    }
    function stopVoting() external returns(bool){
        voting = false;
        emit StopVoting(msg.sender);
        return true;
    }
    function addVote(address receiver) external returns(bool){
        require(voting == true, "Voting is not active");
        votes[msg.sender] = Vote (receiver, block.timestamp);
        emit AddVote(msg.sender, receiver, block.timestamp);
        return true;
        
    }
    function removeVote() external returns(bool){
        require(voting, " voting is not active");
        delete votes[msg.sender];
        emit RemoveVote(msg.sender);
        return true;
    }
    function getVote(address voterAddress) external view returns(address candidateAddress){
        return votes[voterAddress].receiver;
    }

}