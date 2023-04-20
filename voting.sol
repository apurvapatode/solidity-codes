//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{

    struct Voter{
        uint weight;
        uint vote;
        address delegate;
        bool voted;
    }
    struct Proposal{
        bytes32 name;
        uint voteCount;
    }
    address public Chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames){
        Chairperson == msg.sender;
        voters[Chairperson].weight=1;
        for(uint i=0;i<proposalNames.length;i++){
            proposals.push(Proposal({
                name:proposalNames[i],
                voteCount:0        
            }));
        }
    }
    function giveRightToVote(address voter) external{
        require(msg.sender==Chairperson);
        require(!voters[voter].voted);
        require(voters[voter].weight==0);
        voters[voter].weight=1;
    }
    function delegate(address to) external{
        Voter storage sender = voters[msg.sender];
        require(sender.weight!=0,"You have no right to vote");
        require(!sender.voted,"You have already voted");
        require(to!=msg.sender,"Self delegation is not allowed");
        while(voters[to].delegate !=address(0)){
            to = voters[to].delegate;
            require(to!=msg.sender,"loop");
        }
        Voter storage delegate_ = voters[to];
        require(delegate_.weight>=1,"Cannot vote to the not delegated account");
        sender.voted = true;
        sender.delegate=to;
        if(delegate_.voted){
            proposals[delegate_.vote].voteCount+=sender.weight;
        }
        else{
            delegate_.weight += sender.weight;
        }
    }
    function vote(uint proposal) external{
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0,"Cannot vote");
        require(!sender.voted,"Already voted");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;

    } 
    function winningProposal() public view returns(uint winningProposal_){
        uint winningVoteCount =0;
        for(uint p=0;p<proposals.length;p++){
            if(proposals[p].voteCount>winningVoteCount){
                winningVoteCount = proposals[p].voteCount;
                winningProposal_=p;
            }
        }
        }
        function winnerName() external view returns(bytes32 winnerName_){
            winnerName_ = proposals[winningProposal()].name;
        }
    
}