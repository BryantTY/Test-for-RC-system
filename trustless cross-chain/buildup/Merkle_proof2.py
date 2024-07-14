from eth_utils import keccak

def keccak256(data):
    return keccak(data).hex()

def merkle_tree(leaves):
    if len(leaves) % 2 != 0:
        leaves.append(leaves[-1])  # 如果叶子数量是奇数，重复最后一个叶子
    
    tree = [leaves]
    while len(leaves) > 1:
        new_level = []
        for i in range(0, len(leaves), 2):
            new_level.append(keccak256(bytes.fromhex(leaves[i][2:]) + bytes.fromhex(leaves[i + 1][2:])))
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

# 生成叶子
addresses = [
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
    "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
    "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"
]
leaves = [keccak256(bytes.fromhex(address[2:])) for address in addresses]

# 构建 Merkle 树
tree = merkle_tree(leaves)

# 获取 Merkle 树的根
root = "0x" + tree[-1][0]

# 选择一个索引生成 proof
index = 0

# 为选择的叶子生成 proof
proof = get_proof(tree, index)

leaf = leaves[index]

print("Root:", root)
print("Proof:", ["0x" + p for p in proof])
print("Leaf:", "0x" + leaf)
