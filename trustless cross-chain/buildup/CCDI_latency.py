#!/usr/bin/env python3
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rc

# 设置字体为Times New Roman
rc('font', family='Times New Roman')
rc('text', usetex=True)  # 启用Latex风格

# 定义数据
k_max = np.array([2, 6])
N = len(k_max)

# CCNFDI latency
CCNFDI_det = 2 + 2 + 2  # deterministic consensus-based blockchain
CCNFDI_prob = 2 + k_max + 2 + 2 + k_max  # probabilistic consensus-based blockchain

# IBC latency
IBC_det = 2 + 2 + 2  # deterministic consensus-based blockchain
IBC_prob = 2 + k_max + 2 + 2 + k_max + k_max  # probabilistic consensus-based blockchain

# XCMP latency
XCMP_det = 2 + 2 + 2 + 2  # deterministic consensus-based blockchain
XCMP_prob = 2 + k_max + 2 + 2 + k_max + 2  # probabilistic consensus-based blockchain

# LayerZero latency
LayerZero_det = 2 + 2 + 2  # deterministic consensus-based blockchain
LayerZero_prob = 2 + k_max + 2 + k_max + 2 + k_max  # probabilistic consensus-based blockchain

# 创建图形
fig, ax = plt.subplots(figsize=(14, 8))

# 设置柱状图宽度和位置
width = 0.12
x = np.arange(N) * 2  # 增加间隔

# 定义颜色和填充模式
colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd']
patterns = ['/', '\\', '|', '-', '+']

# 降低柱子的高度
height_adjustment = 0.9

# 绘制柱状图
rects1 = ax.bar(x - 2.5*width, CCNFDI_det * np.ones_like(k_max) * height_adjustment, width, label=r'$\Pi_{CCDI}$ - deterministic', color=colors[0], hatch=patterns[0], edgecolor='black')
rects2 = ax.bar(x - 1.5*width, CCNFDI_prob * height_adjustment, width, label=r'$\Pi_{CCDI}$ - probabilistic', color=colors[1], hatch=patterns[1], edgecolor='black')
rects3 = ax.bar(x - 0.5*width, IBC_det * np.ones_like(k_max) * height_adjustment, width, label=r'IBC - deterministic', color=colors[2], hatch=patterns[2], edgecolor='black')
rects4 = ax.bar(x + 0.5*width, IBC_prob * height_adjustment, width, label=r'IBC - probabilistic', color=colors[3], hatch=patterns[3], edgecolor='black')
rects5 = ax.bar(x + 1.5*width, XCMP_det * np.ones_like(k_max) * height_adjustment, width, label=r'XCMP - deterministic', color=colors[4], hatch=patterns[4], edgecolor='black')
rects6 = ax.bar(x + 2.5*width, XCMP_prob * height_adjustment, width, label=r'XCMP - probabilistic', color=colors[0], hatch=patterns[3], edgecolor='black')
rects7 = ax.bar(x + 3.5*width, LayerZero_det * np.ones_like(k_max) * height_adjustment, width, label=r'LayerZero - deterministic', color=colors[1], hatch=patterns[3], edgecolor='black')
rects8 = ax.bar(x + 4.5*width, LayerZero_prob * height_adjustment, width, label=r'LayerZero - probabilistic', color=colors[2], hatch=patterns[3], edgecolor='black')

# 自定义图形外观
ax.set_xlabel(r'$k_{max}$ (minutes)', fontsize=42)
ax.set_ylabel('Latency cost (minutes)', fontsize=42)
# ax.set_title('Latency Cost for Different Blockchain Technologies', fontsize=30)
ax.set_xticks(x)
ax.set_xticklabels(k_max, fontsize=26)

# 设置Y轴刻度
ax.set_yscale('log')
y_ticks = [1, 2, 5, 10, 20, 50, 120]
ax.set_yticks(y_ticks)
ax.set_yticklabels(y_ticks, fontsize=26)

# 调整图例位置和布局
legend = ax.legend(loc='upper left', fontsize=28, ncol=2, bbox_to_anchor=(0, 1.027))
legend._legend_box.align = "left"

ax.grid(True)
ax.tick_params(axis='both', which='major', labelsize=26)

plt.show()