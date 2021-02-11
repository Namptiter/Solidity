pragma solidity ^0.8.0;

contract Contract{
    bool strong;
    bool power;
    bool knowleage;
    
    constructor() {
        strong = false;
        power = false;
        knowleage = false;
    }
    
    modifier CheckPremiumStatus(){
        require(strong==true && power==true && knowleage==true, "Dont stop!");
        _;
    }
    
    function PremiumKickStart() public {
        strong = true;
        power = true;
        knowleage = true;
    }
    
    function RunYourWay() CheckPremiumStatus public view returns(string memory){
        string memory t = "Hey bro! I so understand you. I know your advantage, and know your fall. Now, this momment, Power for your mind, Strong for your muscle, and knowleage for your brain!";
        return t;
    }
}
