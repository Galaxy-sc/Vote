// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.16 <0.9.0;

contract vote{
//state variables
    address public owner;
    enum states{NotStarted,Started,finished}
    states public currentState;
    struct candidate{
        uint8 id;
        string name;
        uint voteCount;
    }
    
    mapping(uint8=>candidate) public candidates;
    mapping(address=>bool) public voters;
    uint8 public candidateNumber;
    
//error functions


//modifiers
    modifier inState(states _state){
        if(currentState != _state)
        revert("invalid state!");
        _;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner,"onlyOwner can call this functions!");
        _;
    }
    
    modifier alreadyVoted(){
        if(voters[msg.sender])
        revert("the voter has already voted!");
        _;
    }
    
    modifier candidateNotFound(uint8 _id){
        if(_id>candidateNumber-1)
        revert("candidate Not Found!");
        _;
        
    }
    
//events
    event winner(uint8 winnerid,uint winnervote);

//constructors
    constructor(){
        owner = msg.sender;
    }

//functions
    function changState(uint8 s)
    public
    onlyOwner{
        if(s == 0){
            currentState = states.NotStarted;
        }if(s == 1){
            currentState = states.Started;
        }else{
            currentState = states.finished; 
        }
    }
    
    function addCandidate(string memory name)
    public
    onlyOwner
    inState(states.NotStarted)
    returns(string memory){
        candidates[candidateNumber] = candidate(candidateNumber,name,0);
        candidateNumber++;
        return "addCandidate is successfully";
    }
    
    function vote1(uint8 _id)
    public
    inState(states.Started)
    alreadyVoted
    candidateNotFound(_id)
    returns(string memory){
        candidates[_id].voteCount++;
        voters[msg.sender] = true;
        return "vote is successfully!";
    }
    
    function getFinalWinner()
    public
    inState(states.finished){
        uint8 winnerid;
        uint winnervote;
        for(uint8 i=0;i<candidateNumber;i++){
            if(candidates[i].voteCount>winnervote){
                winnerid = i;
                winnervote = candidates[i].voteCount;
            }
        }
        emit winner(winnerid,winnervote);
    }
}
