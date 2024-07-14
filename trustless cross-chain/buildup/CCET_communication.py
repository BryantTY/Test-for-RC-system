#!/usr/bin/env python3
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import rc
from matplotlib.ticker import FuncFormatter

# 设置字体为Times New Roman
rc('font', family='Times New Roman')
rc('text', usetex=True)  # 启用Latex风格

# 定义数据
n = np.array([200, 400, 600, 800, 1000])
Nc = np.array([10, 15, 20, 25, 30])

N, NC = np.meshgrid(n, Nc, indexing='ij')

# 计算通信开销
ccfdt_overhead = 780 * N
pidce_overhead = (140 + 50 * 6 + 4* 40 * NC) * N
htlc_overhead = 688 * N

fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')
# ax.set_title('Communication Overhead for Different Schemes', fontsize=18)
ax.set_xlabel('Transaction number', fontsize=24, labelpad=10)
ax.set_ylabel('Nodes number', fontsize=24, labelpad=10)
ax.set_zlabel('Communication cost (bytes)', fontsize=24, labelpad=10)

# 调整标签旋转和位置
ax.zaxis.label.set_rotation(90)
ax.zaxis.labelpad = 10  # 调整标签与轴的距离
ax.zaxis.set_rotate_label(False)
ax.zaxis.set_label_coords(1.02, 0.5)  # 调整Z轴标签位置

# 定义颜色（更适合学术论文并区分度高）
colors = ['#1f77b4', '#ff7f0e', '#2ca02c']  # 蓝色、橙色、绿色

# 条形图宽度和位置
width = depth = 0.2  # 修正宽度和深度以适合图形

# 绘制3D条形图
for i in range(len(n)):
    for j in range(len(Nc)):
        ax.bar3d(i - 0.3, j, 0, width, depth, ccfdt_overhead[i, j], color=colors[0], edgecolor='k')
        ax.bar3d(i, j, 0, width, depth, pidce_overhead[i, j], color=colors[1], edgecolor='k')
        ax.bar3d(i + 0.3, j, 0, width, depth, htlc_overhead[i, j], color=colors[2], edgecolor='k')

ax.set_xticks(np.arange(len(n)))
ax.set_xticklabels(n, fontsize=20)
ax.set_yticks(np.arange(len(Nc)))
ax.set_yticklabels(Nc, fontsize=20)
ax.zaxis.set_tick_params(labelsize=20)

# 自定义Z轴标记格式
def scientific_format(x, pos):
    if x == 0:
        return "0"
    exponent = int(np.log10(x))
    return r'$10^{{{}}}$'.format(exponent)

# 添加非零检查以避免 NaN 错误
def safe_scientific_format(x, pos):
    if x > 0:
        exponent = int(np.log10(x))
        return r'$10^{{{}}}$'.format(exponent)
    else:
        return "0"

ax.zaxis.set_major_formatter(FuncFormatter(safe_scientific_format))

# 调整图例位置
legend = ax.legend([r'$\Pi_{CCTE}$', r'$\Pi_{DCE}$', 'HTLC'], loc='upper right', bbox_to_anchor=(1.05, 0.8), fontsize=18)

plt.grid(True)
plt.show()