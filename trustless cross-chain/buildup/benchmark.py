import hashlib
import ecdsa
import time

# SHA-256 function
def sha256_hash(data):
    return hashlib.sha256(data).digest()

# ECDSA functions
def generate_keypair():
    sk = ecdsa.SigningKey.generate(curve=ecdsa.SECP256k1)
    vk = sk.get_verifying_key()
    return sk, vk

def sign_message(sk, message):
    signature = sk.sign(message)
    return signature

def verify_signature(vk, message, signature):
    return vk.verify(signature, message)

# Merkle proof functions
# ... (Implement Merkle tree construction, proof generation, and proof verification)

# Benchmark functions
def benchmark_sha256(iterations, data):
    start_time = time.time()
    for _ in range(iterations):
        sha256_hash(data)
    end_time = time.time()
    return (end_time - start_time) / iterations

def benchmark_ecdsa(iterations, message):
    sk, vk = generate_keypair()
    start_time = time.time()
    for _ in range(iterations):
        signature = sign_message(sk, message)
        verify_signature(vk, message, signature)
    end_time = time.time()
    return (end_time - start_time) / iterations

# ... (Implement benchmark functions for Merkle proof)

# Run the benchmarks
iterations = 1000
data = b"test data"
message = b"test message"

avg_sha256_time = benchmark_sha256(iterations, data)
avg_ecdsa_time = benchmark_ecdsa(iterations, message)
# ... (Run benchmark for Merkle proof)

print(f"Avg. time for SHA-256: {avg_sha256_time:.6f} seconds")
print(f"Avg. time for ECDSA: {avg_ecdsa_time:.6f} seconds")
# ... (Print results for Merkle proof)
