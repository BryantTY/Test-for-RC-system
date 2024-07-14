#!/usr/bin/env python3
def calculate_formula(p):
    result = ((256 * 5 + 160 + 640) * p) + \
             (((256 * 5 + 160 + 640) + 640 + 160) * p) + \
             ((256 * 5 + 160 + 256 + 320) * p) + \
             ((7 * 256 + 256 * 5 + 160 + 256 + 320 + 320) * p)
    return result

# 获取用户输入的 p 值
p = int(input("请输入 p 的值: "))
# 计算并输出结果
result = calculate_formula(p)
print(f"公式计算结果为: {result} bits")
print(f"公式计算结果为: {result / 8} bytes")