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

# CCFDT latency
CCFDT_latency_det = 4 * np.ones_like(k_max)  # deterministic consensus context
CCFDT_latency_prob = 4 + k_max  # probabilistic consensus context

# Π_DCE latency
Pi_DCE_latency_prob = 2 + 2 +10 + 2 + 10+ 2*k_max + 2  # probabilistic consensus context
Pi_DCE_latency_det = 2 + 2 +10 + 2 + 10 + 2  # deterministic consensus context

# HTLC latency with different delta_t
delta_t = np.array([30, 60])  # 去掉∆t=30
HTLC_latency = [2 + 2 + dt + 2 * k_max + 2 for dt in delta_t]  # updated

# 创建图形
fig, ax = plt.subplots(figsize=(12, 8))

# 设置柱状图宽度和位置
width = 0.2
x = np.arange(N) * 2  # 增加间隔

# 定义颜色和填充模式
colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#3f63ce']  # 缩减到5种颜色
patterns = ['/', '\\', '|', '-', '+', 'x', '\\\\']

# 绘制柱状图
rects1 = ax.bar(x - 2*width, CCFDT_latency_det, width, label=r'$\Pi_{CCTE}$ - deterministic', color=colors[0], hatch=patterns[0], edgecolor='black')
rects2 = ax.bar(x - width, CCFDT_latency_prob, width, label=r'$\Pi_{CCTE}$ - probabilistic', color=colors[1], hatch=patterns[1], edgecolor='black')
rects3 = ax.bar(x, Pi_DCE_latency_prob, width, label=r'$\Pi_{DCE}$ - probabilistic', color=colors[2], hatch=patterns[2], edgecolor='black')
rects4 = ax.bar(x + width, Pi_DCE_latency_det * np.ones_like(k_max), width, label=r'$\Pi_{DCE}$ - deterministic', color=colors[3], hatch=patterns[3], edgecolor='black')

# 添加不同delta_t的HTLC延迟
for i, dt in enumerate(delta_t):
    ax.bar(x + (i + 2)*width, HTLC_latency[i], width, label=f'HTLC, $\\Delta t={dt}$', color=colors[4], hatch=patterns[4+i], edgecolor='black')

# 自定义图形外观
ax.set_xlabel(r'$k_{max}$ (minutes)', fontsize=44)
ax.set_ylabel('Latency cost (minutes)', fontsize=44)
ax.set_xticks(x)
ax.set_xticklabels(k_max, fontsize=30)

# 设置Y轴刻度
y_ticks = [1, 5, 10, 20, 50]
ax.set_yticks(y_ticks)
ax.set_yticklabels(y_ticks, fontsize=30)

# 调整图例位置和布局
legend = ax.legend(loc='upper left', bbox_to_anchor=(0.38, 1.03), fontsize=28, ncol=1)
legend._legend_box.align = "left"

ax.grid(True)
ax.tick_params(axis='both', which='major', labelsize=30)

plt.show()