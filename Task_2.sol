// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

// Simple voting system between two candidates
contract SimpleVotingSystem
{
     struct VoterDetails
     {
        string Name;
        bool Voting_Status;  // Whether the voter has voted or not
        bool Registration_Status;  // Whether the voter is registered or not
        uint8 Voted_Candidate;   // 0 = not voted, 1 or 2 = candidate
     }
     
     bool private isVotingOpen = true;  // Controls election status
     address public Administrator;
     mapping ( address => VoterDetails ) private VoterMapping;  //Maps voter address to their details
     mapping ( uint8 => uint ) private Votes;  // Stores vote count for each candidate

     constructor()  // Sets the deployer as the administrator
     {
        Administrator = msg.sender;
     }
     
     // Registers a voter with their name
     function Register(string memory _name) public
     {
        require(isVotingOpen == true, "Registration closed");  // Registration allowed only when voting is open
        require(VoterMapping[msg.sender].Registration_Status == false, "Already registered");  // Prevent double registration
        
        // Stores voter's name, sets the voter as having not vote by default and registers the voter
        VoterMapping[msg.sender] = VoterDetails
                             ({
                                Name: _name,
                                Voting_Status: false,
                                Registration_Status: true,
                                Voted_Candidate: 0
                             });
     }
     
     // Function that allows a user to cast a vote for either Candidate
     function Vote(uint8 _candidateId) public
     {
        require(VoterMapping[msg.sender].Registration_Status == true, "You must register before voting");  // Registration is compulsary in order to Voting
        require(isVotingOpen == true, "Voting is closed");  // Voting allowed only when open
        require(VoterMapping[msg.sender].Voting_Status == false, "You have already voted");  // Prevent double voting
        require(_candidateId == 1 || _candidateId == 2, "Invalid Candidate");  //Validate candidate ID
        
        // Increment vote count
        Votes[_candidateId] += 1;  
        
        // Mark voter as voted
        VoterMapping[msg.sender].Voting_Status = true;
        VoterMapping[msg.sender].Voted_Candidate = _candidateId;
     }

     // Returns voter details (admin-only)
     function Voter_Details(address _voter) public view returns (string memory)
     {
        require(msg.sender == Administrator, "Only Administrator can access voter details");  // Restrict access to administrator
        require(VoterMapping[_voter].Registration_Status, "Voter not registered");  // Ensure voter is registered
        
        string memory status;

        // Determine voting status
        if (VoterMapping[_voter].Voting_Status == false)
        {
            status = "Not voted yet";
        }
        else if (VoterMapping[_voter].Voted_Candidate == 1)
        {
            status = "Voted for Candidate 1";
        }
        else
        {
            status = "Voted for Candidate 2";
        }

        return string(abi.encodePacked("Name: ",VoterMapping[_voter].Name,"\nVoting Status: ",status));
     }

     // Returns vote count for candidate 1
     function VoteCount_1() public view returns(uint)
     {
        return Votes[1];
     }

     // Returns vote count for candidate 2
     function VoteCount_2() public view returns(uint)
     {
        return Votes[2];
     }

     // Returns voting status of the user
     function VotingStatus() public view returns(string memory)
     {
        if(VoterMapping[msg.sender].Voting_Status == true)
        {
            return "You have already voted";
        }else
        {
            return "You have not voted yet";
        }
     }

     // Returns election result after voting closes
     function Results() public view returns(string memory)
     {
        require(isVotingOpen == false, "Voting is still open");  // Results available only after voting closes
        
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

     // Opens voting (admin-only)
     function OpenVoting() public
     {
        require(msg.sender == Administrator, "Only the Administrator can change Election Status");
        isVotingOpen = true;
     }

     // Closes voting (admin-only)
     function CloseVoting() public
     {
        require(msg.sender == Administrator, "Only the Administrator can change Election Status");
        isVotingOpen = false;
     }

     // Returns current election status (ie. Voting is open or not )
     function ElectionStatus() public view returns(string memory)
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
