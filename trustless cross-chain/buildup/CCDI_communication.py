#!/usr/bin/env python3
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import rc

# 设置字体为Times New Roman
rc('font', family='Times New Roman')
rc('text', usetex=True)  # 启用Latex风格

# 定义N和p的范围
N_values = np.array([10, 20, 30])
p_values = np.array([20, 40, 60])

N, P = np.meshgrid(N_values, p_values, indexing='ij')

# 计算通信复杂度（转换为bytes）
def ibc_complexity(N, p):
    return (((160 + p * (256 * 5 + 160) + 160) * N) + ((256 + 7 * 256 + 160 + 160) * N**2) * 3) / 8

def xcmp_complexity(N, p):
    return ((160 + p * (256 * 5 + 160) + 160 + 160) + ((160 + p * (256 * 5 + 160) + 160 + 160) * N) + ((256 + 160 + 160) * N) * 3) / 8

def layerzero_complexity(N, p, l):
    return (((160 + p * (256 * 5 + 160) + 160) * N) + ((256 + 160 + (7 * 256 + 600 + 320) * l) * N**2) * 3) / 8

def pi_ccdi_complexity_N(N, p):
    return (((256 * 5 + 320 ) * p) + (((256 * 5 + 320) + 5 * 256 +480) * N * p) + ((256 * 5 + 160 + 256) * p) + ((5 * 256 + 256 * 5 + 160 + 256 + 320 ) * N * p)) / 8

def pi_ccdi_complexity_1(N, p):
    return (((256 * 5 + 320 ) * p) + (((256 * 5 + 320) + 5 * 256 +480)  * p) + ((256 * 5 + 160 + 256) * p) + ((5 * 256 + 256 * 5 + 160 + 256 + 320 ) * p)) / 8

# 创建三维图形
fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')
# ax.set_title('Communication Overhead for Different Protocols', fontsize=24)
ax.set_xlabel('External blockchains number', fontsize=24, labelpad=10)
ax.set_ylabel('SD number', fontsize=24, labelpad=20)
ax.set_zlabel('Communication costs (bytes)', fontsize=24, labelpad=10)

# 调整标签旋转和位置
ax.zaxis.label.set_rotation(90)
ax.zaxis.labelpad = 10  # 调整标签与轴的距离
ax.zaxis.set_rotate_label(False)
ax.zaxis.set_label_coords(1.02, 0.5)  # 调整Z轴标签位置

# 定义颜色（更适合学术论文并区分度高）
colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd']  # 蓝色、橙色、绿色、红色、紫色

# 条形图宽度和位置
width = depth = 0.15  # 修正宽度和深度以适合图形

# 绘制3D条形图
for i in range(len(N_values)):
    for j in range(len(p_values)):
        ibc = np.log10(ibc_complexity(N_values[i], p_values[j]))
        xcmp = np.log10(xcmp_complexity(N_values[i], p_values[j]))
        layerzero = np.log10(layerzero_complexity(N_values[i], p_values[j], 10))  # 假设 l=10
        pi_ccdi_N = np.log10(pi_ccdi_complexity_N(N_values[i], p_values[j]))
        pi_ccdi_1 = np.log10(pi_ccdi_complexity_1(N_values[i], p_values[j]))
        ax.bar3d(i - 2 * width, j, 0, width, depth, ibc, color=colors[0], edgecolor='k')
        ax.bar3d(i - width, j, 0, width, depth, xcmp, color=colors[1], edgecolor='k')
        ax.bar3d(i, j, 0, width, depth, layerzero, color=colors[2], edgecolor='k')
        ax.bar3d(i + width, j, 0, width, depth, pi_ccdi_N, color=colors[3], edgecolor='k')
        ax.bar3d(i + 2 * width, j, 0, width, depth, pi_ccdi_1, color=colors[4], edgecolor='k')

# 设置刻度标签
ax.set_xticks(np.arange(len(N_values)))
ax.set_xticklabels(N_values, fontsize=18)
ax.set_yticks(np.arange(len(p_values)))
ax.set_yticklabels(p_values, fontsize=18)
ax.zaxis.set_tick_params(labelsize=18)

# 设置Z轴刻度和标签
zTickData = [1, 10**2, 10**4, 10**6, 10**8]
ax.set_zticks(np.log10(zTickData))
ax.set_zticklabels([r'$10^0$', r'$10^2$', r'$10^4$', r'$10^6$', r'$10^8$'], fontsize=18)

# 调整图例位置
legend = ax.legend(['IBC', 'XCMP', 'LayerZero', r'$\Pi_{CCDI} (\epsilon K=N)$', r'$\Pi_{CCDI} (\epsilon K=1)$'], loc='upper left', bbox_to_anchor=(0, 0.98), fontsize=18)

plt.grid(True)
plt.show()