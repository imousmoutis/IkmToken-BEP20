// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * @notice The Stakeable contract is used to provide rewards for the holders.
 */
contract Stakeable {

    /**
     * @notice A Stake contains the amount staked to a user and the timestamp.
     */
    struct Stake {
        address user;
        uint256 amount;
        uint256 since;
        uint256 claimable;
    }

    /**
     * @notice A Stakeholder is a Staker with ongoing stakes.
     */
    struct Stakeholder {
        address user;
        Stake[] addressStakes;
    }

    /**
    * @notice A StakingSummary contains all the stakes done by an account.
    */
    struct StakingSummary {
        uint256 totalAmount;
        Stake[] stakes;
    }

    //an array holding all the current stakeholders
    Stakeholder[] internal stakeholders;

    //the addresses of the stakeholders
    mapping(address => uint256) internal stakes;

    //the reward per hour of stakes is 0.1%
    uint256 internal hourlyReward = 1000;

    /**
     * @notice The Staked Event will be logging the action of staking tokens by a holder.
     */
    event Staked(address indexed user, uint256 index, uint256 amount, uint256 timestamp);

    /**
     * @notice The constructor is called during the creation of the smart contract.
     */
    constructor() {
        stakeholders.push();
    }

    /**
     * @notice This function is called to add a new stakeholder in the array and returns the new index in the array.
     * The function can only be called from inside the contract.
     */
    function _addStakeholder(address stakeholder) internal returns (uint256) {
        stakeholders.push();
        uint256 stakeholderIndex = stakeholders.length - 1;

        stakeholders[stakeholderIndex].user = stakeholder;
        stakes[stakeholder] = stakeholderIndex;

        return stakeholderIndex;
    }

    /**
     * @notice This function is called to add stakes for the message sender.
     * The function can only be called from inside the contract.
     *
     * Events
     * - Staked
     *
     * Requires
     * - Amount to be staked should be more than zero.
     */
    function _stake(uint256 amount) internal {
        require(amount > 0, "Stake amount must be higher than zero.");

        address stakeHolder = msg.sender;
        uint256 index = stakes[stakeHolder];
        uint256 timestamp = block.timestamp;

        //condition check if the stakeholder is new
        if (index == 0) {
            index = _addStakeholder(stakeHolder);
        }

        stakeholders[index].addressStakes.push(Stake(stakeHolder, amount, timestamp, 0));
        emit Staked(stakeHolder, index, amount, timestamp);
    }

    /**
     * @notice This function is used to to calculate the total amount of stake amount of a staker.
     * The function can only be called from inside the contract.
     */
    function hasStake(address _staker) public view returns(StakingSummary memory){
        // totalStakeAmount is used to count total staked amount of the address
        uint256 totalStakeAmount;
        // Keep a summary in memory since we need to calculate this
        StakingSummary memory summary = StakingSummary(0, stakeholders[stakes[_staker]].addressStakes);
        // Itterate all stakes and grab amount of stakes
        for (uint256 s = 0; s < summary.stakes.length; s += 1){
            uint256 availableReward = calculateStakeReward(summary.stakes[s]);
            summary.stakes[s].claimable = availableReward;
            totalStakeAmount = totalStakeAmount+summary.stakes[s].amount;
        }
        // Assign calculate amount to summary
        summary.totalAmount = totalStakeAmount;
        return summary;
    }

    /**
     * @notice This function is called to calculate the amount of rewards a stakeholder should receive.
     * The function can only be called from inside the contract.
     */
    function calculateStakeReward(Stake memory stake) internal view returns (uint256) {
        return (((block.timestamp - stake.since) / 1 hours) * stake.amount) / hourlyReward;
    }

    /**
     * @notice This function is called to withdraw the provided amount from a staker and also adds the hourly reward
     * amount in the returnings.
     * The function can only be called from inside the contract.
     *
     * Requires
     * - The staker withdraws amount that has already been staked and not more.
     */
    function _withdrawStake(uint256 amount, uint256 index) internal returns (uint256) {
        uint256 stakeholderIndex = stakes[msg.sender];
        Stake memory currentStake = stakeholders[stakeholderIndex].addressStakes[index];

        require(currentStake.amount >= amount, "You cannot withdraw more than you have staked.");

        uint256 stakeReward = calculateStakeReward(currentStake);
        currentStake.amount = currentStake.amount - amount;

        //Remove staker if amount is zero or update the decreased amount
        if (currentStake.amount == 0) {
            delete stakeholders[stakeholderIndex].addressStakes[index];
        } else {
            stakeholders[stakeholderIndex].addressStakes[index].amount = currentStake.amount;
            stakeholders[stakeholderIndex].addressStakes[index].since = block.timestamp;
        }

        return amount + stakeReward;
    }

}
