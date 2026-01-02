// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract SimpleVotingSystem
{
     struct VoterDetails
     {
        address Voter_Address;
        string Name;
        bool Voting_Status;
        bool Registration_Status;
        uint8 Voted_Candidate;   // 0 = not voted, 1 or 2 = candidate
     }
     
     bool private isVotingOpen = true;
     address public Administrator;
     mapping ( address => VoterDetails ) private Voters;
     mapping ( uint8 => uint ) private Votes;

     constructor()
     {
        Administrator = msg.sender;
     }
     
     function Register(string memory _name) public
     {
        require(isVotingOpen == true, "Registration closed");
        require(Voters[msg.sender].Registration_Status == false, "Already registered");
        Voters[msg.sender] = VoterDetails
                             ({
                                Voter_Address: msg.sender,
                                Name: _name,
                                Voting_Status: false,
                                Registration_Status: true,
                                Voted_Candidate: 0
                             });
    }
     
     
     function Vote(uint8 _CandidateId) public
     {
        require(Voters[msg.sender].Registration_Status == true, "You must register before voting");
        require(isVotingOpen == true, "Voting is closed");
        require(Voters[msg.sender].Voting_Status == false, "You have already voted");
        require(_CandidateId == 1 || _CandidateId == 2, "Invalid Candidate");
        Votes[_CandidateId] += 1;
        Voters[msg.sender].Voting_Status = true;
        Voters[msg.sender].Voted_Candidate = _CandidateId;
     }

     function Voter_Details(address _Voter) public view returns (string memory)
     {
        require(msg.sender == Administrator, "Only Administrator can access voter details");
        require(Voters[_Voter].Registration_Status, "Voter not registered");
        
        string memory status;

        if (!Voters[_Voter].Voting_Status)
        {
            status = "Not voted yet";
        }
        else if (Voters[_Voter].Voted_Candidate == 1)
        {
            status = "Voted for Candidate 1";
        }
        else
        {
            status = "Voted for Candidate 2";
        }

        return string(abi.encodePacked("Name: ",Voters[_Voter].Name,"\nVoting Status: ",status));
     }

     function VoteCount_1() public view returns(uint)
     {
        return Votes[1];
     }

     function VoteCount_2() public view returns(uint)
     {
        return Votes[2];
     }

     function Voter_Status() public view returns(string memory)
     {
        if(Voters[msg.sender].Voting_Status == true)
        {
            return "You have already voted";
        }else
        {
            return "You have not voted yet";
        }
     }

     function Results() public view returns(string memory)
     {
        require(isVotingOpen == false, "Voting is still open");
        
        if(Votes[1] > Votes[2])
        {
            return "Candidate 1 is the Winner";
        }
        else if(Votes[2] > Votes[1])
        {
            return "Candidate 2 is the Winner";
        }
        else
        {
            return "Tie";
        }
     } 

     function Open_Voting() public
     {
        require(msg.sender == Administrator, "Only the Administrator can change Election Status");
        isVotingOpen = true;
     }

     function Close_Voting() public
     {
        require(msg.sender == Administrator, "Only the Administrator can change Election Status");
        isVotingOpen = false;
     }

     function Election_Status() public view returns(string memory)
     {
        if(isVotingOpen == true)
        {
            return "Voting is Open";
        }
        else
        {
            return "Voting is Closed";
        }
     }
}
