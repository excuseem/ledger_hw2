// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(uint256 initialSupply) ERC20("Token", "TKN") {
        _mint(msg.sender, initialSupply);
    }
}

contract Exchange {
    Token public token;
    uint public rate;

    constructor(Token _token, uint _rate) {
        token = _token;
        rate = _rate;
    }

    function buyTokens() public payable {
        require(msg.value > 0, "You need to send some Ether");
        uint256 tokensToBuy = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokensToBuy, "Not enough tokens in the reserve");
        token.transfer(msg.sender, tokensToBuy);
    }

    function sellTokens(uint _amount) public {
        require(_amount > 0, "You need to sell at least some tokens");
        uint256 etherToPay = _amount / rate;
        require(address(this).balance >= etherToPay, "Not enough Ether in the reserve");
        token.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(etherToPay);
    }
}
