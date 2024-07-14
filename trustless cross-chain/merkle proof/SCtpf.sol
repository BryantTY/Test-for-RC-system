// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./CrossChainSwap.sol";

contract CrossChainTransfer {
    struct Transaction {
        address user;
        int256 value;
        address token;
        uint256 deadline;
    }

    struct Node {
        uint256 receivedAmount;
        uint256 sentAmount;
    }

    address public stableCoinAddress;
    Transaction[] public transactions;
    mapping(address => Node) public nodes;
    address[] public nodeList;
    CrossChainSwap public crossChainSwap;

    constructor(address _stableCoinAddress, address _crossChainSwapAddress) {
        stableCoinAddress = _stableCoinAddress;
        crossChainSwap = CrossChainSwap(_crossChainSwapAddress);
    }

    function addNode(address node) public {
        nodeList.push(node);
    }

    function addTransaction(address user, int256 value, address token, uint256 deadline) public {
        Transaction memory tx = Transaction(user, value, token, deadline);
        transactions.push(tx);
    }

    function executeTransactions() public {
    for (uint256 i = 0; i < transactions.length; i++) {
        Transaction memory tx = transactions[i];
        require(block.timestamp <= tx.deadline, "Transaction deadline has passed.");

        int256[] memory values = new int256[](1);
        values[0] = tx.value;

        address[] memory tokens = new address[](1);
        tokens[0] = tx.token;

        uint256[] memory selectedNodes = crossChainSwap.selectNodes(values, tokens);

        for (uint256 j = 0; j < selectedNodes.length; j++) {
            address selectedNode = nodeList[selectedNodes[j]];
            ERC20 token = ERC20(tx.token);

            if (tx.value < 0) {
                uint256 amount = uint256(-tx.value);
                token.transferFrom(tx.user, selectedNode, amount);
                nodes[selectedNode].receivedAmount += amount;
            } else {
                uint256 amount = uint256(tx.value);
                token.transferFrom(selectedNode, tx.user, amount);
                nodes[selectedNode].sentAmount += amount;
            }
        }
    }
}


    function settleNodes() public {
        for (uint256 i = 0; i < nodeList.length; i++) {
            Node storage node = nodes[nodeList[i]];
            ERC20 stableCoin = ERC20(stableCoinAddress);

            if (node.receivedAmount > node.sentAmount) {
                uint256 difference = node.receivedAmount - node.sentAmount;
                stableCoin.transferFrom(nodeList[i], stableCoinAddress, difference);
            } else if (node.sentAmount > node.receivedAmount) {
                uint256 difference = node.sentAmount - node.receivedAmount;
                stableCoin.transferFrom(stableCoinAddress, nodeList[i], difference);
            }
        }
    }
}
