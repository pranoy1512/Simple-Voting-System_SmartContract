# SimpleVotingSystem Contract - Ownership Logic

## Overview
This smart contract implements a simple voting system between two candidates, with administrative controls managed by a single administrator.

## Ownership Implementation

### 👑 **Administrator Assignment**
- The contract deployer becomes the permanent administrator during contract creation
- Administrator address is stored in a public variable for transparency
- Implemented via: `Administrator = msg.sender` in constructor

### 🔐 **Administrator-Only Functions**

| Function | Purpose | Access Control |
|----------|---------|----------------|
| `Voter_Details()` | View detailed voter information | `require(msg.sender == Administrator)` |
| `OpenVoting()` | Open voting period | `require(msg.sender == Administrator)` |
| `CloseVoting()` | Close voting period | `require(msg.sender == Administrator)` |

### 📊 **Access Control Summary**

| User Type | Permissions |
|-----------|-------------|
| **Administrator** | - View detailed voter information<br>- Open/close voting period<br>- Set name during registration |
| **Registered Voters** | - Register to vote (once)<br>- Cast vote (once)<br>- Check personal voting status<br>- View election status<br>- View vote counts<br>- View results (after voting closes) |
| **Unregistered Users** | - View election status<br>- View vote counts (but not who voted for whom) |

### 🔒 **Security Features**
1. **Immutable Administrator**: Once set, administrator role cannot be changed or transferred
2. **Private Data**: Voter details stored in private mapping (`VoterMapping`)
3. **Registration Requirements**: 
   - Must register before voting
   - Can only register once
   - Can only vote once
4. **Voting Period Control**: Only administrator can open/close voting
5. **Candidate Validation**: Votes only accepted for candidate 1 or 2
