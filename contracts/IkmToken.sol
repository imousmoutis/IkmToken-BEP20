// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Ownable.sol";

/**
 * @notice The smart contract for the IkmToken which is following the BEP20 interface.
 * @author imousmoutis
 */
contract IkmToken is Ownable {

    //the token required variables
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint private _totalSupply;

    //a mapping containing all the holders' balances (key: address, value: balance)
    mapping(address => uint256) private _balances;

    //a mapping containing all the available allowances (key: holder, value: (key: spender, value: amount))
    mapping(address => mapping(address => uint256)) private _allowances;

    /**
     * @notice The Transfer Event will be logging the action of new transactions.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @notice The Approval Event will be logging the action of adding or removing allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @notice The constructor is called during the creation of the smart contract and sets the token related variables.
     *
     * Events
     * - Transfer
     */
    constructor(string memory token_name, string memory short_symbol, uint8 token_decimals, uint256 token_total_supply){
        _name = token_name;
        _symbol = short_symbol;
        _decimals = token_decimals;
        _totalSupply = token_total_supply;

        _balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    /**
     * @notice This function returns the number of decimal precision of the Token.
     */
    function decimals() external view returns (uint8) {
        return _decimals;
    }

    /**
     * @notice This function returns the symbol of the Token.
     */
    function symbol() external view returns (string memory){
        return _symbol;
    }

    /**
     * @notice This function returns the name of the Token.
     */
    function name() external view returns (string memory){
        return _name;
    }

    /**
     * @notice This function returns the total supply of the Token.
     */
    function totalSupply() external view returns (uint256){
        return _totalSupply;
    }

    /**
     * @notice This function returns the amount in the provided address.
     */
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    /**
     * @notice This function returns the owner of the contract.
     */
    function getOwner() external view returns (address) {
        return owner();
    }

    /**
    * @notice This function returns the allowance of the provided spender.
     */
    function allowance(address _owner, address spender) external view returns (uint256) {
        return _allowances[_owner][spender];
    }

    /**
     * @notice This function is called to create new tokens in the provided address and increase the total supply of
     * the Token.
     * The function can only be called from inside the contract.
     *
     * Events
     * - Transfer
     *
     * Requires
     * - Tokens cannot be mint to the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "IkmToken: cannot mint to zero address");

        _totalSupply = _totalSupply + (amount);
        _balances[account] = _balances[account] + amount;

        emit Transfer(address(0), account, amount);
    }

    /**
     * @notice This function is called to create new tokens in the provided address and increase the total supply of
     * the Token.
     * The function can only be called by the owner of the contract.
     *
     * Events
     * - Transfer
     *
     * Requires
     * - Tokens cannot be mint to the zero address.
     */
    function mint(address account, uint256 amount) public onlyOwner returns (bool){
        _mint(account, amount);
        return true;
    }

    /**
     * @notice This function is called to burn the provided amount of tokens from the provided address.
     * The function can only be called from inside the contract.
     *
     * Events
     * - Transfer
     *
     * Requires
     * - Tokens cannot be burnt from the zero address.
     * - Tokens cannot be burnt from an address if the balance is inefficient.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "Tokens cannot be burnt from the zero address.");
        require(_balances[account] >= amount, "The amount of Tokens to be burnt does not exist in the account.");

        _totalSupply = _totalSupply - amount;
        _balances[account] = _balances[account] - amount;

        emit Transfer(account, address(0), amount);
    }

    /**
     * @notice This function is called to burn the provided amount of tokens from the provided address.
     * The function can only be called by the owner of the contract.
     *
     * Events
     * - Transfer
     *
     * Requires
     * - Tokens cannot be burnt from the zero address.
     * - Tokens cannot be burnt from an address if the balance is inefficient.
     */
    function burn(address account, uint256 amount) public onlyOwner returns (bool) {
        _burn(account, amount);
        return true;
    }

    /**
     * @notice This function is called to transfer the given amount from one address to another.
     * The function can only be called from inside the contract.
     *
     * Events
     * - Transfer
     *
     * Requires
     * - Sender or Recipient cannot be the zero address.
     * - Sender and recipient must be different addresses.
     * - The sender must have enough balance in their account to transfer.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Tokens cannot be transferred from the zero address.");
        require(recipient != address(0), "Tokens cannot be transferred to the zero address.");
        require(sender != recipient, "Tokens cannot be transferred to the same address");
        require(_balances[sender] >= amount, "The amount of Tokens to be transferred does not exist in the account.");

        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] = _balances[recipient] + amount;

        emit Transfer(sender, recipient, amount);
    }

    /**
     * @notice This function is called to transfer the given amount from one address to another.
     *
     * Events
     * - Transfer
     *
     * Requires
     * - Sender or Recipient cannot be the zero address.
     * - Sender and recipient must be different addresses.
     * - The recipient mush have enough balance in their account to transfer.
     */
    function transfer(address recipient, uint256 amount) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @notice This function is called to add the provided amount as allowance from the owner to the spender.
     * The function can only be called from inside the contract.
     *
     * Events
     * - Approval
     *
     * Requires
     * - Owner or Spender cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "Tokens cannot be approved by the zero address.");
        require(spender != address(0), "Tokens cannot be approved to the zero address.");
        // Set the allowance of the spender address at the Owner mapping over accounts to the amount
        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }

    /**
     * @notice This function is called to add the provided amount as allowance from the owner to the spender.
     *
     * Events
     * - Approval
     *
     * Requires
     * - Owner or Spender cannot be the zero address.
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice This function is called to transfer the provided amount of tokens from the allowance of the sender.
     *
     * Events
     * - Transfer
     * - Approval
     *
     * Requires
     * - Sender or Recipient cannot be the zero address.
     * - Sender and recipient must be different addresses.
     * - The sender must have enough balance in their account to transfer.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
        require(_allowances[sender][msg.sender] >= amount, "The amount of Tokens to be transferred does not exist in the allowance of the sender.");

        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);

        return true;
    }

    /**
     * @notice This function is called to increase the allowance based on the provided amount to the spender.
     *
     * Events
     * - Approval
     *
     * Requires
     * - Caller or Spender cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + amount);
        return true;
    }

    /**
     * @notice This function is called to decrease the allowance based on the provided amount to the spender.
     *
     * Events
     * - Approval
     *
     * Requires
     * - Caller or Spender cannot be the zero address.
     */
    function decreaseAllowance(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] - amount);
        return true;
    }

}
