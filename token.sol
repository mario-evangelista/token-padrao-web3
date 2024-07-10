// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

// ERC Token Standard #20 Interface
interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(
        address tokenOwner
    ) external view returns (uint256 balance);
    function allowance(
        address tokenOwner,
        address spender
    ) external view returns (uint256 remaining);

    function transfer(
        address to,
        uint256 tokens
    ) external returns (bool success);
    function approve(
        address spender,
        uint256 tokens
    ) external returns (bool success);
    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );
}

// Actual token contract
contract DIOToken is ERC20Interface {
    string public constant symbol = "DIO";
    string public constant name = "DIO Coin";
    uint8 public constant decimals = 2;
    uint256 public _totalSupply = 1_000_000;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    constructor() {
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address tokenOwner
    ) public view override returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function transfer(
        address to,
        uint256 tokens
    ) public override returns (bool success) {
        require(to != address(0), "Invalid address");
        require(tokens <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(
        address spender,
        uint256 tokens
    ) public override returns (bool success) {
        require(spender != address(0), "Invalid address");

        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function allowance(
        address tokenOwner,
        address spender
    ) public view override returns (uint256 remaining) {
        return allowed[tokenOwner][spender];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) public override returns (bool success) {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(tokens <= balances[from], "Insufficient balance");
        require(tokens <= allowed[from][msg.sender], "Allowance exceeded");

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
}
