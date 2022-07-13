pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

contract SplitProtocol {
    mapping(address => int) public balances;
    address[] public members;

    function addMember(address member) public {
        members.push(member);
    }

    function getMembers() public view returns (address[] memory) {
        return members;
    }

    // here we have to deposit different tokens of varying value either multichain or ERC20s
    function deposit() public payable {
        balances[msg.sender] += int(msg.value);
    }

    // Take loans, pay back with deposit() - optional function where users can take back thier money prior to swap 
    function withdraw(uint amount) public {
        require(amount <= address(this).balance, "Contract does not have enough funds to loan");
        balances[msg.sender] -= int(amount);
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send");
    }


    //we need to wrap matic, eth etc 
    //if there is a way to do test erc20s maybe we do that
    //we need a way to assess if the total deposit amount eqauls the amount reqauested by the landlord they may have to overdeposit
    //WE ALSO NEED TO USE CHAINLINK PRICE ORACLES OR UNISWAP TO FETCH PRICE 

    //we then should implement UNISWAP FUNCTIONS GO HERE 


    //FINALLY Run Check Function To See If Amount Is eqaul Before Setling The Debt

    // Track debt transactions between two partites
    function adjust(address debtor, address payer, int amount) public {
        balances[debtor] -= amount;
        balances[payer] += amount;
    }

    // Settle debt
    function settle(address payable addr) public payable {
        deposit();
        balances[addr] -= int(msg.value);
        (bool sent, ) = addr.call{value: msg.value}("");
        require(sent, "Failed to send");
    }
}