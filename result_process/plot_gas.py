import matplotlib.pyplot as plt
import numpy as np

data1 = [1419044, 539383, 420000, 2378427]

data2 = [1182843, 1249626, 420000, 2852469]
x = np.arange(len(data1))

# 设置条形宽度
width = 0.4

# 创建一个新的图形
plt.figure()

# 绘制第一个数据集的条形图
plt.bar(x - width/2, data1, width, label='divid', color='g')

# 绘制第二个数据集的条形图
plt.bar(x + width/2, data2, width, label='no divid', color='r')

# 设置图形的标题和标签
plt.title('Bank Contract')
plt.xlabel('Category')
plt.ylabel('Gas')

# 设置 X 轴的刻度和标签
plt.xticks(x, ['bc1', 'bc2', 'relay', 'total'])

# 显示图例
plt.legend()

# 显示图形
plt.show()