#!/usr/bin/env python3
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import rc

# 设置字体为Times New Roman
rc('font', family='Times New Roman')
rc('text', usetex=True)  # 启用Latex风格

# 定义参数范围
kmax = np.array([2, 4, 6, 8, 10])
N_values = np.array([10, 20, 30])

K, N = np.meshgrid(kmax, N_values, indexing='ij')

# 计算通信复杂度（转换为bytes）
ccdi_overhead = N * K * 300
ibc_overhead = N * (N - 1) * K * 300
xcmp_overhead = N * K * 100000000

# 创建三维图形
fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')
#ax.set_title('Communication Overhead for Different Protocols', fontsize=18)
ax.set_xlabel('External blockchains number', fontsize=26, labelpad=10)
ax.set_ylabel( r'$k_{max}$ (minutes)', fontsize=26, labelpad=20)
ax.set_zlabel('Memory cost (bytes)', fontsize=26, labelpad=10)

# 调整标签旋转和位置
ax.zaxis.label.set_rotation(90)
ax.zaxis.labelpad = 10  # 调整标签与轴的距离
ax.zaxis.set_rotate_label(False)
ax.zaxis.set_label_coords(1.02, 0.5)  # 调整Z轴标签位置

# 定义颜色（更适合学术论文并区分度高）
colors = ['#1f77b4', '#ff7f0e', '#2ca02c']  # 蓝色、橙色、绿色
scheme_names = [r'$\Pi_{CCDI}$', 'IBC', 'XCMP']

# 条形图宽度和位置
width = depth = 0.2  # 修正宽度和深度以适合图形

# 绘制3D条形图
for i in range(len(N_values)):
    for j in range(len(kmax)):
        ccdi = np.log10(ccdi_overhead[j, i])
        ibc = np.log10(ibc_overhead[j, i])
        xcmp = np.log10(xcmp_overhead[j, i])
        ax.bar3d(i - 1.5 * width, j, 0, width, depth, ccdi, color=colors[0], edgecolor='k')
        ax.bar3d(i - 0.5 * width, j, 0, width, depth, ibc, color=colors[1], edgecolor='k')
        ax.bar3d(i + 0.5 * width, j, 0, width, depth, xcmp, color=colors[2], edgecolor='k')

# 设置刻度标签
ax.set_xticks(np.arange(len(N_values)))
ax.set_xticklabels(N_values, fontsize=22)
ax.set_yticks(np.arange(len(kmax)))
ax.set_yticklabels(kmax, fontsize=22)
ax.zaxis.set_tick_params(labelsize=22)

# 设置Z轴刻度和标签
zTickData = [1, 10**2, 10**4, 10**6, 10**8]
ax.set_zticks(np.log10(zTickData))
ax.set_zticklabels([r'$10^0$', r'$10^2$', r'$10^4$', r'$10^6$', r'$10^8$'], fontsize=22)

# 调整图例位置
legend = ax.legend(scheme_names, loc='upper left', bbox_to_anchor=(0.85, 0.8), fontsize=19)

plt.grid(True)
plt.show()