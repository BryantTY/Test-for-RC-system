import hashlib
from eth_utils import keccak, to_hex

def keccak256(data):
    return to_hex(keccak(data.encode('utf-8')))

def merkle_tree(leaves, hash_func):
    if len(leaves) % 2 != 0:
        leaves.append(leaves[-1])  # If odd number of leaves, duplicate the last one
    
    tree = [leaves]
    while len(leaves) > 1:
        if len(leaves) % 2 != 0:
            leaves.append(leaves[-1])  # If odd number of leaves, duplicate the last one
        new_level = []
        for i in range(0, len(leaves), 2):
            new_level.append(hash_func(leaves[i] + leaves[i + 1]))
        leaves = new_level
        tree.append(leaves)
    
    return tree

def get_proof(tree, index):
    proof = []
    for level in tree[:-1]:
        sibling_index = index ^ 1
        proof.append(level[sibling_index])
        index //= 2
    return proof

# Generate leaves
leaves = ['leaf1', 'leaf2', 'leaf3', 'leaf4', 'leaf5', 'leaf6']
leaves = [keccak256(leaf) for leaf in leaves]

# Build the Merkle tree
tree = merkle_tree(leaves, keccak256)

# Get the root of the tree
root = tree[-1][0]

# Choose an index to generate a proof for
index = 0

# Generate the proof for the chosen leaf
proof = get_proof(tree, index)

leaf = leaves[index]

print("Root:", root)
print("Proof:", proof)
print("Leaf:", leaf)