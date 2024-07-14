import hashlib
from eth_utils import keccak, to_bytes, to_hex

def sha256(data):
    return hashlib.sha256(data.encode('utf-8')).hexdigest()

def keccak256(data):
    return keccak(data)

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
leaves = [keccak256(sha256(leaf).encode()) for leaf in leaves]

# Convert leaves to bytes
leaves_bytes = [keccak256(leaf) for leaf in leaves]

# Build the Merkle tree
tree = merkle_tree(leaves_bytes, keccak256)

# Get the root of the tree
root = tree[-1][0]

# Choose an index to generate a proof for
index = 1

# Generate the proof for the chosen leaf
proof = get_proof(tree, index)

# Output the results
leaf = leaves_bytes[index]
root_hex = to_hex(root)
proof_hex = [to_hex(p) for p in proof]

print("Root:", root_hex)
print("Proof:", proof_hex)
print("Leaf:", to_hex(leaf))