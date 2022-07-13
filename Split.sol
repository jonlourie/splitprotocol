pragma solidity >=0.7.0 <0.9.0;
//SPDX-License-Identifier: MIT

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract SplitProtocol {
    mapping(address => int) public balances;
    address[] public members;

    //tokens to swap in 
    //IERC20 apeToken = IERC20(0x4d224452801aced8b2f0aebe155379bb5d594381);
    //IERC20 shibInu = IERC20(0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce);

    //events 
    event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);


    function addMember(address member) public {
        members.push(member);
    }

    function getMembers() public view returns (address[] memory) {
        return members;
    }

    // here we have to deposit different tokens of varying value either multichain or ERC20s
    //function deposit() public payable {
        //balances[msg.sender] += int(msg.value);
    //}

    //deposit erc20 tokens into the contract
    function deposit() public payable {

        //wrap the eth 

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

    //Uniswap Implementation Goes Here

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

    //transfer ERC20 to landlord
    function transferERC20(IERC20 token, address to, uint256 amount) public { 
        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "balance is low");
        token.transfer(to, amount);
        emit TransferSent(msg.sender, to, amount);
    }    
}