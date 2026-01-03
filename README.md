1. SimpleVotingSystem – Administrator Logic


Who is the Administrator?
- The administrator is the Ethereum address that deploys the contract.
- It is set once in the constructor
- In Solidity: First, I defined a state variable called Administrator of the type address
- Its visibility is set public so that anyone can see who the administrator is
- Then in the constructor, I assign the address "msg.sender" to the Administrator
- Therefore, whenever the contract is deployed, the deployer becomes the Administrator of the contract


What powers does the Administrator have?

The administrator has exclusive control over:
- Opening the election
- Closing the election
- Viewing voter details

These actions are protected using require checks such as: "require(msg.sender == Administrator, "Only Administrator can access this");"


What regular users can and cannot do?

Any Ethereum address can:
- Register itself as a voter (when voting is open)
- Cast exactly one vote
- Check its own voting status
- View public vote counts
- View election results after voting closes

Regular users cannot:
- View other voters’ details
- Change the election status
