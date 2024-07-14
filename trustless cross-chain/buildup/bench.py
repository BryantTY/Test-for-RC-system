import os
import time
from web3 import Web3, HTTPProvider
from eth_utils import keccak

# Ethereum provider
provider = 'https://mainnet.infura.io/v3/fc19af40a47449f8a5d8864b17eac6bb'
w3 = Web3(HTTPProvider(provider))

# Merkle proof functions
def merkle_tree(elements):
    leaves = [keccak(bytes.fromhex(element[2:])) for element in elements]
    tree = [leaves]
    while len(leaves) > 1:
        if len(leaves) % 2 == 1:
            leaves.append(leaves[-1])
        leaves = [keccak(leaves[i] + leaves[i + 1]) for i in range(0, len(leaves), 2)]
        tree.append(leaves)
    return tree

def merkle_proof(tree, index):
    proof = []
    for level in tree[:-1]:
        sibling_index = index - 1 if index % 2 == 1 else index + 1
        proof.append(level[sibling_index])
        index = index // 2
    return proof

def verify_proof(proof, leaf, root):
    computed_root = leaf
    for sibling in proof:
        computed_root = keccak(computed_root + sibling) if computed_root < sibling else keccak(sibling + computed_root)
    return computed_root == root

# Benchmark functions
def benchmark_merkle_proof(iterations, elements, index):
    tree = merkle_tree(elements)
    leaf = tree[0][index]
    root = tree[-1][0]
    proof = merkle_proof(tree, index)
    
    start_time = time.time()
    for _ in range(iterations):
        verify_proof(proof, leaf, root)
    end_time = time.time()
    
    return (end_time - start_time) / iterations

# Run the benchmarks
iterations = 1000
data = b"test data"
message = b"test message"

# ... (Your existing benchmark code)

# Get Ethereum block data for Merkle tree
block_number = w3.eth.block_number
block = w3.eth.get_block(block_number)
transaction_hashes = [tx.hex() for tx in block.transactions]

# Run Merkle proof benchmark
# Run Merkle proof benchmark
index = 0  # You can change this index to test a different transaction in the block
avg_merkle_proof_time = benchmark_merkle_proof(iterations, transaction_hashes, index)

# Calculate and print the depth of the Merkle proof
#tree = merkle_tree(transaction_hashes)
#proof = merkle_proof(tree, index)
#depth = len(proof)
#print(f"Depth of the Merkle proof: {depth}")

#print(f"Avg. time for Merkle proof: {avg_merkle_proof_time:.6f} seconds")

# Run Merkle proof benchmarks for different indices
indices = [0, 2, 3, 4, 5, 6, 7]

for index in indices:
    avg_merkle_proof_time = benchmark_merkle_proof(iterations, transaction_hashes, index)

    # Calculate and print the depth of the Merkle proof
    tree = merkle_tree(transaction_hashes)
    proof = merkle_proof(tree, index)
    depth = len(proof)
    
    print(f"Index: {index}")
    print(f"Depth of the Merkle proof: {depth}")
    print(f"Avg. time for Merkle proof: {avg_merkle_proof_time:.6f} seconds")
    print()


