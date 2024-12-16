// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title SimpleDEX
 * @notice A smart contract that serves as a decentralized exchange for educational purposes.
 * @dev This contract allows users to:
 * - Add liquidity to the pool
 * - Remove liquidity from the pool
 * - Swap between TokenA and TokenB
 * - Retrieve prices and reserves
 * @author Marco Godoy (Eth Kipu comisión 3)
 */
contract SimpleDEX {
    // State Variables
    address public tokenA;
    address public tokenB;
    address public owner;
    address public contractAddress;
    uint256 public liquidityTokenA;
    uint256 public liquidityTokenB;

    // Event Emitters
    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event TokenSwapped(address indexed trader, address inputToken, uint256 inputAmount, address outputToken, uint256 outputAmount);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);

    // Constructor
    /**
     * @notice Initializes the contract with token addresses and sets the owner.
     * @param _tokenA Address of TokenA.
     * @param _tokenB Address of TokenB.
     */
    constructor(address _tokenA, address _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        owner = msg.sender;
        contractAddress = address(this);
    }

    // Modifier
    /**
     * @dev Restricts access to the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Denied, must be owner");
        _;
    }

    // Functions

    /**
     * @notice Allows owner to add liquidity to the pool.
     * @param amountA The amount of TokenA to deposit.
     * @param amountB The amount of TokenB to deposit.
     */
    function addLiquidity(uint256 amountA, uint256 amountB) onlyOwner external {
        require(amountA > 0 && amountB > 0, "Amount of each token must be greater than 0");
        
        liquidityTokenA += amountA;
        liquidityTokenB += amountB;

        IERC20(tokenA).transferFrom(msg.sender, contractAddress, amountA);
        IERC20(tokenB).transferFrom(msg.sender, contractAddress, amountB);

        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    /**
     * @notice Allows users to swap TokenA for TokenB.
     * @param amountAIn The amount of TokenA to exchange.
     */
    function swapAforB(uint256 amountAIn) external {
        require(amountAIn > 0, "Amount must be greater than 0");

        uint256 amountToGive = liquidityTokenB - (liquidityTokenA * liquidityTokenB) / (liquidityTokenA + amountAIn);

        require(amountToGive > 0, "Not enough token in liquidity");

        liquidityTokenA += amountAIn;
        liquidityTokenB -= amountToGive;

        IERC20(tokenA).transferFrom(msg.sender, contractAddress, amountAIn);
        IERC20(tokenB).transfer(msg.sender, amountToGive);

        emit TokenSwapped(msg.sender, tokenA, amountAIn, tokenB, amountToGive);
    }

    /**
     * @notice Allows users to swap TokenB for TokenA.
     * @param amountBIn The amount of TokenB to exchange.
     */
    function swapBforA(uint256 amountBIn) external {
        require(amountBIn > 0, "Amount must be greater than 0");

        uint256 amountToGive = liquidityTokenA - (liquidityTokenA * liquidityTokenB) / (liquidityTokenB + amountBIn);

        require(amountToGive > 0, "Not enough token in liquidity");

        liquidityTokenA -= amountToGive;
        liquidityTokenB += amountBIn;

        IERC20(tokenB).transferFrom(msg.sender, contractAddress, amountBIn);
        IERC20(tokenA).transfer(msg.sender, amountToGive);

        emit TokenSwapped(msg.sender, tokenB, amountBIn, tokenA, amountToGive);
    }

    /**
     * @notice Allows owner to remove liquidity from the pool.
     * @param amountA The amount of TokenA to withdraw.
     * @param amountB The amount of TokenB to withdraw.
     */
    function removeLiquidity(uint256 amountA, uint256 amountB) onlyOwner external {
        require(amountA <= liquidityTokenA, "Insufficient reserves in tokenA");
        require(amountB <= liquidityTokenB, "Insufficient reserves in tokenB");
        
        liquidityTokenA -= amountA;
        liquidityTokenB -= amountB;

        IERC20(tokenA).transfer(msg.sender, amountA);
        IERC20(tokenB).transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

    /**
     * @notice Retrieves the current price of TokenA in terms of TokenB.
     * @return The price of TokenA.
     */
    function getPriceA() external view returns (uint256) {
        return (liquidityTokenA * 1e18) / liquidityTokenB;
    }

    /**
     * @notice Retrieves the current price of TokenB in terms of TokenA.
     * @return price of TokenB.
     */
    function getPriceB() external view returns (uint256) {
        return (liquidityTokenB * 1e18) / liquidityTokenA;
    }

    /**
     * @notice Retrieves the current reserves of TokenA and TokenB in the liquidity pool.
     * @return reserveA The amount of TokenA in the pool.
     * @return reserveB The amount of TokenB in the pool.
     */
    function getReserves() external view returns (uint256 reserveA, uint256 reserveB) {
        return (liquidityTokenA, liquidityTokenB);
    }
}
