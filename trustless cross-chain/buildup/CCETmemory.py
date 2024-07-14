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
N = np.array([10, 15, 20, 25, 30])
k_max = np.array([2, 4, 6, 8, 10])
mu = 10

NN, KK = np.meshgrid(N, k_max)

# 计算内存开销
our_scheme_overhead = (600 * KK) * NN / 2
pidce_overhead = (k_max * 1000000 * NN) / 2

fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')
# ax.set_title('Memory Overhead for Different Schemes', fontsize=18)
ax.set_xlabel('External blockchains number', fontsize=28, labelpad=10)
ax.set_ylabel('$k_{max}$ (minutes)', fontsize=28, labelpad=10)
ax.set_zlabel('Memory cost (bytes)', fontsize=28, labelpad=10)

# 调整标签旋转和位置
ax.zaxis.label.set_rotation(90)
ax.zaxis.labelpad = 10  # 调整标签与轴的距离
ax.zaxis.set_rotate_label(False)
ax.zaxis.set_label_coords(1.02, 0.5)  # 调整Z轴标签位置

# 定义颜色（更适合学术论文并区分度高）
colors = ['#1f77b4', '#ff7f0e']  # 蓝色、橙色

# 条形图宽度和位置
width = depth = 0.2  # 修正宽度和深度以适合图形

# 绘制3D条形图
for i in range(len(N)):
    for j in range(len(k_max)):
        ax.bar3d(i - 0.3, j, 0, width, depth, np.log10(our_scheme_overhead[j, i]), color=colors[0], edgecolor='k')
        ax.bar3d(i, j, 0, width, depth, np.log10(pidce_overhead[j, i]), color=colors[1], edgecolor='k')

ax.set_xticks(np.arange(len(N)))
ax.set_xticklabels(N, fontsize=23)
ax.set_yticks(np.arange(len(k_max)))
ax.set_yticklabels(k_max, fontsize=20)
ax.zaxis.set_tick_params(labelsize=20)

# 自定义Z轴标记格式
def scientific_format(x, pos):
    if x == 0:
        return "0"
    exponent = int(np.log10(10**x))
    return r'$10^{{{}}}$'.format(exponent)

# 添加非零检查以避免 NaN 错误
def safe_scientific_format(x, pos):
    if x > 0:
        exponent = int(np.log10(10**x))
        return r'$10^{{{}}}$'.format(exponent)
    else:
        return "0"

ax.zaxis.set_major_formatter(FuncFormatter(safe_scientific_format))

# 设置Z轴刻度和标签
zTickData = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000]
ax.set_zticks(np.log10(zTickData))
ax.set_zticklabels([f'$10^{{{int(np.log10(tick))}}}$' for tick in zTickData], fontsize=20)

# 调整图例位置
legend = ax.legend([r'$\Pi_{CCTE}$', r'$\Pi_{DCE}$'], loc='upper right', bbox_to_anchor=(1.16, 0.87), fontsize=22)

plt.grid(True)
plt.show()