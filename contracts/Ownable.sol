// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * @notice The Ownable contract will be inherited by the main contract in order to provide the custom modifier
 * ownerOnly and restrict access to specific functions in order to be callable only by the owner of the contract.
 */
contract Ownable {
    //the current owner of the contract
    address private _owner;

    /**
     * @notice The OwnershipTransferred Event will be logging the action of changing ownership of the smart contract.
     */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @notice The custom modifier for owner-only callable function.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, "Only the Smart Contract owner can call this function.");
        _;
    }

    /**
     * @notice The constructor is called during the creation of the smart contract and sets the contract owner.
     *
     * Events
     * - OwnershipTransferred
     */
    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @notice This function returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @notice This function is called to remove the ownership and assign it to the zero address.
     * Caution: All the ownerOnly functions will not be callable after this.
     *
     * Events
     * - OwnershipTransferred
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @notice This function is called to transfer the Ownership to the provided address.
     * The function can only be called from inside the contract.
     *
     * Events
     * - OwnershipTransferred
     *
     * Requires
     * - The new address should not be the zero address.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    /**
     * @notice This method is called to transfer the Ownership to the provided address.
     * This function can only be called by the owner of the contract.
     *
     * Events
     * - OwnershipTransferred
     *
     * Requires
     * - The new address should not be the zero address.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

}
