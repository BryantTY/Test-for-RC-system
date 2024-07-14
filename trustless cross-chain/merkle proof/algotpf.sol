pragma solidity ^0.8.0;

interface IToken {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract CrossChainTransactions {
    address public stableCoinAddress;
    address public relayChainAccount;
    uint256 public T = 1 hours;

    struct Transaction {
        int256 value;
        address tokenAddress;
    }

    struct Node {
        mapping(address => uint256) balances;
        uint256 stakedAmount;
        uint256 unlockTime;
    }

    Transaction[] public transactions;
    mapping(address => Node) public nodes;
    address[] public nodeList;

    constructor(address _stableCoinAddress, address _relayChainAccount) {
        stableCoinAddress = _stableCoinAddress;
        relayChainAccount = _relayChainAccount;
    }

    function addTransaction(int256 _value, address _tokenAddress) external {
        transactions.push(Transaction({value: _value, tokenAddress: _tokenAddress}));
    }

    function addNode(address _nodeAddress) external {
        nodeList.push(_nodeAddress);
    }

    function updateNodeBalance(address _nodeAddress, address _tokenAddress, uint256 _newBalance) external {
        nodes[_nodeAddress].balances[_tokenAddress] = _newBalance;
    }

    function stake(address _nodeAddress, uint256 _amount) external {
        IToken stableCoin = IToken(stableCoinAddress);
        stableCoin.transferFrom(msg.sender, address(this), _amount);
        nodes[_nodeAddress].stakedAmount += _amount;
        nodes[_nodeAddress].unlockTime = block.timestamp + 2 * T;
    }

    // Other functions ...

    function selectNode(address _tokenAddress, uint256 _amount) private view returns (address) {
        address selectedNode = address(0);
        uint256 selectedNodeScore = type(uint256).max;

        for (uint256 i = 0; i < nodeList.length; i++) {
            address nodeAddress = nodeList[i];
            Node storage node = nodes[nodeAddress];

            if (node.stakedAmount >= _amount &&
                node.balances[_tokenAddress] >= _amount &&
                node.unlockTime >= block.timestamp + T) {

                uint256 score = node.stakedAmount - _amount;
                if (score < selectedNodeScore) {
                    selectedNode = nodeAddress;
                    selectedNodeScore = score;
                }
            }
        }

        require(selectedNode != address(0), "No suitable node found");
        return selectedNode;
    }

    // Other functions ...
    function unstake(address _nodeAddress, uint256 _amount) external {
    Node storage node = nodes[_nodeAddress];
        require(block.timestamp >= node.unlockTime, "Node's staked assets are still locked");
        require(node.stakedAmount >= _amount, "Insufficient staked amount");

        IToken stableCoin = IToken(stableCoinAddress);
        stableCoin.transfer(_nodeAddress, _amount);

        node.stakedAmount -= _amount;
}

}
