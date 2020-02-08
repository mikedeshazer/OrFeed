pragma solidity ^0.5.0;

/** 
 * @title VotingContract
 * @dev Implements a voting contract will be used by judges serving as oracles in a market such as https://www.floater.market 
 */

 contract VotingContract {
    
    // a vote window, which is a period in days which should be set in the future
    uint private votingStartDate;
    uint private votingEndDate;
    
    // a variable that shows the voting status, by default it shows the voting hasn't began
    string public votingStatus = "VOTENOTREADY";
    
    // the details whats being voted for
    string public voteDetailsName;
    // and the description
    string public voteDetailsDescription;

    // represents a single vote
    struct Vote {
        string name; // i.e. "TRUE" , "UNDECIDED" or "FALSE"
        string _event; // the event being voted for
    }
    
    // a judge in the voting process
    struct Judge {
        string name;
        string description;
        address judgeAddress;
    }
    
    // the votes
    mapping (address => Vote) public votes;
    
     // the judges
    mapping (address => Judge) public judges;
    
    //  the various events being voted for and the final vote result
    mapping(string => string[]) events;
     
    // the owner of the contract
    address owner;
    
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
    
    modifier onlyOwnerAndJudge() {
        require(msg.sender == owner 
            && judges[msg.sender].judgeAddress == msg.sender
            && judges[msg.sender].judgeAddress != address(0), 
            "Only the owner or judge can edit an exisiting judge"); 
        _;
    }
    
    modifier votePeriodMustBeSet() {
        // set a valid voting period
        require( votingStartDate > 0 && votingEndDate > 0, "A valid vote window must be set");
        _;
    }
    
    modifier votingShouldNotHaveStarted() {
        // no changes should be allowed when voting has started 
        require(now < votingStartDate , "Can't modify variable(s) because voting has already started");
        _;
    }
    
    modifier futureVotingDate(uint _votingDate) {
        // make sure any of the voting date set is in the future
        require(_votingDate > now, "voting date must be in the future");
        _;
    }
    
    modifier validVotingPeriod(uint _votingStartDate, uint _votingEndDate) {
        // make sure any of the voting date set is in the future
        require(_votingEndDate > _votingStartDate, "Voting end date should be greater than the voting start date");
        _;
    }
    
    modifier votingEligible() {
        // make sure the voting period is in range and the voter is already added as a judge
        require(votingStartDate > 0 
            && votingEndDate > 0
            && now >= votingStartDate 
            && now <= votingEndDate 
            &&  judges[msg.sender].judgeAddress == msg.sender
            && judges[msg.sender].judgeAddress != address(0), 
            "Voting not eligible! make sure you are in the voting period, the voting period is valid and are added as a judge");
        _;
    }
    
     
    modifier validVote(string memory _vote) {
        // make sure a vote is valid
        require(compareStrings(_vote, "TRUE")
            || compareStrings(_vote, "FALSE") 
            || compareStrings(_vote, "UNDECIDED") , 
            "Please cast a valid vote of either TRUE, FALSE or UNDECIDED");
        _;
    }
    
    // set the contract owner, the name of whats being voted for and the description
    constructor(string memory _voteDetailsName, string memory _voteDetailsDescription) public {
        owner = msg.sender;
        voteDetailsName = _voteDetailsName;
        voteDetailsDescription = _voteDetailsDescription;
    }
    
    // function to set a voting period before the voting starts by setting the start and end dates
    function setVotingPeriodByDates(uint _startDate, uint _endDate) 
        external 
        futureVotingDate(_startDate)
        futureVotingDate(_endDate)
        validVotingPeriod(_startDate, _endDate)
        votingShouldNotHaveStarted()
        onlyOwner()
    {
        votingStartDate = _startDate;
        votingEndDate = _endDate;
    }
    
    // function to set a voting period before the voting starts
    function setVotingPeriod(uint _daysToVoteStart, uint _votingDurationDays) 
        external 
        votingShouldNotHaveStarted()
        onlyOwner()
    {
        votingStartDate = now + _daysToVoteStart * 1 days;
        votingEndDate = now + _daysToVoteStart * 1 days + _votingDurationDays * 1 days;
    }
    
    // function to reset a voting period before the voting starts
    function resetVotingPeriod() 
        external 
        votingShouldNotHaveStarted() 
        onlyOwner()
    {
        votingStartDate = 0;
        votingEndDate = 0;
    }
    
    // function to add a judge before voting starts
    function addJudge(string memory _name, string memory desc, address judgeAddress) 
        public 
        votingShouldNotHaveStarted() 
        onlyOwner() 
    {
        judges[judgeAddress] = Judge(_name, desc, judgeAddress);
    }
    
     // function to edit a judge before voting starts
    function editJudge(string memory _name, string memory desc, address judgeAddress) 
        public 
        votingShouldNotHaveStarted() 
        onlyOwnerAndJudge() 
    {
        judges[judgeAddress] = Judge(_name, desc, judgeAddress);
    }
    
    // function to remove a judge before voting starts
    function removeJudge(address judgeAddress) 
        public 
        votingShouldNotHaveStarted() 
        onlyOwner()
    {
        delete judges[judgeAddress];
    }
    
    // function to modify whats being voted on and the description
    function changeVotingDetails(string memory _voteDetailsName, string memory _voteDetailsDescription)
        public 
        votingShouldNotHaveStarted() 
        onlyOwner()
    {
        voteDetailsName = _voteDetailsName;
        voteDetailsDescription = _voteDetailsDescription;
    }
    
    function voteForEvent(string memory _theEvent, string memory _vote ) 
        public 
        votingEligible()
        validVote(_vote)
    {
        // flag the voting process has having been started
        votingStatus = "VOTEINPROGRESS";
        
        // save the vote by a particular judge
        votes[msg.sender] = Vote(_vote, _theEvent);
        
        // push the vote for the event in the event array
        events[_theEvent].push(_vote);
    }
    
    function getResultFromOracle(string memory _theEvent, uint _dataIndex) public view returns (string memory) { 
        
        string memory votingResult = "";
        
        // voting has not yet started
        if (now < votingStartDate ) {
            votingResult = votingStatus;
        }
        
        // if in voting period, return the voting status
        if (now >= votingStartDate && now <= votingEndDate ) {
            votingResult = votingStatus;
        }
        
        // voting period has ended, then aggregate all the results
        if (now > votingEndDate) {
            
            uint trueCount = 0;
            uint falseCount = 0;
            uint undecidedCount = 0;
            
            for (uint i = 0; i < events[_theEvent].length; i++) {
                
                string memory vote = events[_theEvent][i];
                
                if (compareStrings(vote,"TRUE")) {
                    trueCount = trueCount + 1;
                }
                
                if (compareStrings(vote,"FALSE")) {
                    falseCount = falseCount + 1;
                }
                
                if (compareStrings(vote,"UNDECIDED")) {
                    undecidedCount = undecidedCount + 1;
                }
                 
            }
            
            // aggregate the results
            if (trueCount > falseCount && trueCount > undecidedCount) {
                votingResult = "TRUE";
            }
            else if (falseCount > trueCount && falseCount > undecidedCount) {
                votingResult = "FALSE";
            }
            else if (undecidedCount > trueCount && undecidedCount > falseCount) {
                votingResult = "UNDECIDED";
            }
            else {
                votingResult =  events[_theEvent][_dataIndex];
            }
        }
        
        return votingResult; 
    }
    
    // function to get the time till vote
    function getTimeTilVote() external view  returns (uint){
        uint timeTilVote = 0;
        
        if (votingStartDate > now) {
            timeTilVote = votingStartDate - now;
        }
        return timeTilVote;
    }
    
    // helper function to compare strings
    function compareStrings (string memory a, string memory b) internal pure 
       returns (bool) {
       return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
     
 }