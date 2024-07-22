import datetime
import re
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm


def extrat(filename):
    lines_with_gas = []  # 创建一个空列表来存储包含"gas"的行
    try:
        with open(filename, 'r') as file:  # 使用with语句打开文件，保证文件会被正确关闭
            for line in file:  # 逐行读取文件
                if 'pier' in line:  # 检查该行是否包含字符串"gas"
                    lines_with_gas.append(line)  # 如果包含，则添加到列表中
    except FileNotFoundError:  # 处理文件未找到错误
        print(f"Error: The file '{filename}' does not exist.")
        return []
    except Exception as e:  # 处理其他可能的错误
        print(f"An error occurred: {e}")
        return []
    with open('destination4.txt', 'w', encoding='utf-8') as destination_file:
        destination_file.writelines(lines_with_gas)

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

def calculate_time_difference(filepath,blocknum):
    first_time = None
    last_time = None
    
    with open(filepath, 'r') as file:
        for line in file:
            
            time = parse_time_from_log(line)
           
            if time is not None:
                if first_time is None:
                    first_time = time
                if 'Successfully sealed new block' in line:
                    if f'number={blocknum}' in line:
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
# 3i
file_path = ['./new/3i0','./new/3i1','./new/3i2','./new/3i3','./new/3i4']
endnum = [387,422,453,484,438]
# 3c
# file_path = ['./new/3c0','./new/3c1','./new/3c2','./new/3c3','./new/3c4']
# endnum = [122,181,217,248,274]
times = []
k = []    
rest = []
for i in range(len(file_path)):
    print(file_path[i])

    # k = read_file_and_find_gas(i,'INFO')
    # res = calculate_onchain(k)
    # time_diff = calculate_time_difference(i)
    # res[5] = time_diff.total_seconds()*1e6
    # res[4] = res[5] - res[3]
    # print(res)
    # rest.append(res)
    times.append(calculate_time_difference(file_path[i],endnum[i]).total_seconds())
    print(times[i])
average = np.array(times).mean()
print(average)

