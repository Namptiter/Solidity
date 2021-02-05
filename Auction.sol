pragma solidity 0.8.1;
contract Contract {
    struct User{
        address diaChi;
    }
    User[] Users;
    uint counterUser;
    uint voteCount;
    bool down;
    
    mapping (address => bool) votedBall;
    mapping (address => bool) votedBatminton;
    mapping (address => uint8) voteAmountToBall;
    mapping (address => uint8) voteAmountToBatminton;
    mapping (address => uint256) userAmount;
    
    address payable Boss = payable(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
    
    modifier joinnOnce(){
        bool check = false;
        for(uint8 i=0; i<counterUser; i++){
            if(Users[i].diaChi == msg.sender){
                check = true;
            }
        }
        require(check == false,"You are joined");
        _;
    }
    modifier isDown(){
        require(down==false, "Session is downed!");
        _;
    }
    function showContractBalance() public view returns(uint256){
        return (address(this).balance);
    }

    function join() payable joinnOnce isDown public{
        require(msg.sender != Boss, "You cannot join!");
        require(msg.value >= 1 ether && msg.value <= 10 ether, "Commit more than 1 and less than 10 ether to play");
        uint256 t = msg.value / 10**18;
        Users.push(User(msg.sender));
        userAmount[msg.sender] = t;
        counterUser += 1;
        voteCount += 2;
    }
    
    function voteToBall(uint8 amount) public isDown{
        require(votedBall[msg.sender]==false, "You voted Ball before!");
        require(userAmount[msg.sender] >= amount, "Not enough money!");
        voteAmountToBall[msg.sender] += amount;
        userAmount[msg.sender] -= amount;
        votedBall[msg.sender] = true;
        voteCount -= 1;
    }
    
    function voteToBatminton(uint8 amount) public isDown{
        require(votedBatminton[msg.sender]==false, "You voted Batminton before!");
        require(userAmount[msg.sender] >= amount, "Not enough money!");
        voteAmountToBatminton[msg.sender] += amount;
        userAmount[msg.sender] -= amount;
        votedBatminton[msg.sender] = true;
        voteCount -= 1;
    }
    
    function giveUp() payable public {
        require(msg.sender!=Boss && votedBall[msg.sender]==false && votedBatminton[msg.sender]==false, 
        "You cannot stop or you never join with us!");
        for(uint8 i=0;i<counterUser;i++){
            if(Users[i].diaChi==msg.sender){
                delete Users[i];
                break;
            }
        }
        voteCount-=2;
        counterUser--;
        address payable out = payable(msg.sender);
        out.transfer(userAmount[msg.sender]*(10**18));
        userAmount[msg.sender] = 0;
    }
    
    function Down() payable public isDown{
        require(msg.sender == Boss, "You dont have this permission!");
        require(voteCount == 0, "Session is not gone");
        
        uint8 totalAmountA = 0;
        uint8 totalAmountB = 0;
        address winA=Boss; 
        uint8 amountWinA=0;
        address winB=Boss;
        uint8 amountWinB=0;
        
        for(uint8 i=0;i<counterUser;i++){
            totalAmountA += voteAmountToBall[Users[i].diaChi];
            totalAmountB += voteAmountToBatminton[Users[i].diaChi];
            if(voteAmountToBall[Users[i].diaChi] > amountWinA){
                winA = Users[i].diaChi;
                amountWinA = voteAmountToBall[Users[i].diaChi];
            }
            if(voteAmountToBatminton[Users[i].diaChi] > amountWinB){
                winB = Users[i].diaChi;
                amountWinB = voteAmountToBatminton[Users[i].diaChi];
            }
        }
        
        address payable wA = payable(winA);
        address payable wB = payable(winB);
        
        wA.transfer((amountWinA + (totalAmountA-amountWinA)/2)*(10**18));
        wB.transfer((amountWinB + (totalAmountB-amountWinB)/2)*(10**18));
        Boss.transfer(address(this).balance);
        down = true;
    }
    receive() external payable { }
}
