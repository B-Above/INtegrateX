import datetime
import re
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm

def read_file_and_find_gas(filename,s):
    lines_with_gas = []  # 创建一个空列表来存储包含"gas"的行
    try:
        with open(filename, 'r') as file:  # 使用with语句打开文件，保证文件会被正确关闭
            for line in file:  # 逐行读取文件
                if s in line:  # 检查该行是否包含字符串"gas"
                    if 'pier' not in line:
                        lines_with_gas.append(line.strip())  # 如果包含，则添加到列表中
    except FileNotFoundError:  # 处理文件未找到错误
        print(f"Error: The file '{filename}' does not exist.")
        return []
    except Exception as e:  # 处理其他可能的错误
        print(f"An error occurred: {e}")
        return []

    return lines_with_gas

def parse_time_from_log(line):
    current_year = datetime.datetime.now().year
    try:
        if 'time="' in line:
            # 处理形如 time="2024-05-07T12:14:45.903" 的时间戳
            start = line.index('time="') + len('time="')
            end = line.index('"', start)
            time_str = line[start:end]
            return datetime.datetime.strptime(time_str, "%Y-%m-%dT%H:%M:%S.%f")
        elif '[' in line and '|' in line:
            # 处理形如 [05-07|12:14:13.725] 的时间戳
            start = line.index('[') + 1
            end = line.index(']', start)
            time_str = line[start:end]
            time_str = f"{current_year}-{time_str.replace('|', 'T')}"
            return datetime.datetime.strptime(time_str, "%Y-%m-%dT%H:%M:%S.%f")
    except ValueError:
        # 时间格式无法解析
        return None

def calculate_time_difference(filepath):
    first_time = None
    last_time = None
    
    with open(filepath, 'r') as file:
        for line in file:
            time = parse_time_from_log(line)
            if time is not None:
                if first_time is None:
                    first_time = time
                last_time = time  # 每次循环更新，循环结束时，将是最后一行
    
    if not first_time or not last_time:
        return "File is empty, does not contain valid timestamps, or there is an error reading the file"
    
    # 计算时间差
    time_difference = last_time - first_time
    return time_difference

def decide_which(s):
    if 'ethereum-1' in s:
        return 0
    elif 'ethereum-2' in s:
        return 1
    elif 'ethereum-3' in s:
        return 2
    else: 
        return 3
    
def calculate_onchain(ethline):
    res = [0.0,0.0,0.0,0.0,0.0,0.0]
    #print(ethline)
    # for i in ethline:
    #     print(i)
    # print(len(ethline))
    k = int(len(ethline)/7)
    for i in range(k):
        # print (ethline[i*7])
        # print(ethline[i*7+6])
        t1 = parse_time_from_log(ethline[i*7])
        t2 = parse_time_from_log(ethline[i*7+6])
        s = decide_which(ethline[i*7])
        dt = t2-t1
        res[s] += dt.total_seconds()*1e6
    res[3] = res[0]+res[1]+res[2]
    return res

# 使用函数
# file_path = ['1.txt','2.txt','3cChain.txt']
file_path = ['1.txt','2.txt','3cChain.txt']
#file_path = ['3c1.txt','3c2.txt','1.txt','2.txt','chain_mode.txt','3cChain.txt']
# file_path = ['chain_mode.txt','lock_p.txt','receive_bank.txt','receive_hotel.txt','buy_p.txt']
#file_path = ['3c1.txt']
#file_path = ['./4/4l2.txt','./4/4e2.txt','./4/4l1.txt','./4/4e1.txt','./4/4l3.txt','./4/4e3.txt','./4/4l4.txt','./4/4e4.txt','./4/4c1.txt','./4/4c3.txt','./4/4c4.txt','./4/4c5.txt','./4/4c6.txt']
file_path = ['./5/5l2.txt','./5/5e2.txt','./5/5l1.txt','./5/5e1.txt','./5/5l3.txt','./5/5e3.txt']
file_path = ['./3/3l1.txt','./3/3e1.txt','./3/3l2.txt','./3/3e2.txt','./3/3l3.txt','./3/3e3.txt']
file_path = ['./t/1.txt']
k = []    
rest = []
for i in file_path:
    print(i)
    k = read_file_and_find_gas(i,'INFO')
    res = calculate_onchain(k)
    time_diff = calculate_time_difference(i)
    res[5] = time_diff.total_seconds()*1e6
    res[4] = res[5] - res[3]
    print(res)
    rest.append(res)
# print(file_path)
# print(res)
print(rest)
# print('INtegrateX:')
# for i in range(3):
#     m = (np.array(rest[2*i]))+np.array(rest[2*i+1])
#     m[4] = m[4]/2
#     m[5] = m[5]/2
#     print(m.tolist())
# print('chain mode:')
# # for i in range(5):
# #     m = np.array(rest[8+i])
# #     k = m[4]/9
# #     m[5] = m[5]-2*k
# #     print(m.tolist())
# m = np.array(rest[2])
# m[5] = m[5] - 5000000
# m[4] = m[4] - 5000000
# print(m.tolist())
#print(rest[5])
# print("Time for chain mode:", res[0])
# k = max(res[2],res[3])
# t = res[1]+res[4]+k
# print("Time for integration:", t)    
# facility_names = ['区块链1', '区块链2', '区块链3', '区块链上总时间', '跨链传输时间', '总时间']
# data_set_1 = m
# data_set_2 = np.array(rest[2])

# font_path = '/usr/share/fonts/truetype/wqy/wqy-microhei.ttc'  # 适用于Linux系统
# # font_path = 'C:/Windows/Fonts/simhei.ttf'  # 适用于Windows系统
# my_font = fm.FontProperties(fname=font_path)

# # 设置柱的宽度
# bar_width = 0.35

# # 设置每个柱在x轴上的位置
# index = np.arange(len(facility_names))

# # 创建图形
# fig, ax = plt.subplots()

# # 绘制数据集1的柱状图
# bars1 = ax.bar(index, data_set_1, bar_width, label='数据集1')

# # 绘制数据集2的柱状图，位置右移一个柱宽
# bars2 = ax.bar(index + bar_width, data_set_2, bar_width, label='数据集2')

# # 设置图表标题和标签
# ax.set_title('不同设施的时间消耗', fontproperties=my_font)
# ax.set_xlabel('设施名称', fontproperties=my_font)
# ax.set_ylabel('时间消耗（微秒）', fontproperties=my_font)

# # 设置x轴刻度，并将其标签设置为设施名称
# ax.set_xticks(index + bar_width / 2)
# ax.set_xticklabels(facility_names, fontproperties=my_font)

# # 显示图例
# ax.legend(prop=my_font)

# # 显示图形
# plt.xticks(rotation=45, fontproperties=my_font)  # 旋转横轴标签以避免重叠
# plt.tight_layout()  # 自动调整子图参数以使图形更美观
# plt.show()
