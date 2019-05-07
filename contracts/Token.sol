pragma solidity ^0.5.0;

contract Token {
    uint256 public totalSupply; // Total token
    uint256 public issuedSupply; // Total token that was issued
    mapping (address => uint256) balances;

    address owner;
    uint price = 100; // 1 ETH = 100 Token

    event Transfer(address indexed _from, address indexed _to, uint256 _amount);

    // Modifier that checks if the sender is the owner or not
    modifier onlyOwner() {
        require(msg.sender == owner,"Only owner");
        _;
    }

    // Constructor
    constructor(uint256 _totalSupply) public {
        totalSupply = _totalSupply;
        owner = msg.sender;
    }

    // Delete smart contract
    function destroy() public onlyOwner {
        selfdestruct(msg.sender);
    }

    // Fallback function
    function () external payable {
        uint256 amount = price * msg.value / 1 ether;
        uint256 canIssue = totalSupply - issuedSupply;

        require(canIssue > 0, "There are no token to buy");

        if (amount > canIssue) {
            amount = canIssue;
        }

        // Issue token
        balances[msg.sender] += amount;
        emit Transfer(address(0x0), msg.sender, amount);

        // Refund ETH
        msg.sender.transfer(msg.value - amount*1 ether/price);
    }

    // Return balance of the given address
    function balanceOf(address _addr) public view returns (uint256) {
        return balances[_addr];
    }

    // Transfer token to given address
    function transfer(address receiver, uint256 amount) public returns (bool){
        // Check sender token balance
        require(balances[msg.sender] > amount, "Not enough balance");

        // Subtract sender balance
        balances[msg.sender] -= amount;

        // Add receiver balance
        balances[receiver] += amount;

        // Emit event transfer
        emit Transfer(msg.sender, receiver, amount);
    }
}