import datetime
import re

def read_file_and_find_gas(filename,s):
    lines_with_gas = []  # 创建一个空列表来存储包含"gas"的行
    try:
        with open(filename, 'r') as file:  # 使用with语句打开文件，保证文件会被正确关闭
            for line in file:  # 逐行读取文件
                if s in line:  # 检查该行是否包含字符串"gas"
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

# 使用函数
file_path = ['chain_mode.txt','lock_p.txt','receive_bank.txt','receive_hotel.txt','buy_p.txt']
# file_path = ['1.txt','2.txt']
res = []
k = read_file_and_find_gas(file_path[0],'ethereum')
for i in file_path:
    time_diff = calculate_time_difference(i)
    res.append(time_diff)
print(file_path)
print(res)
print((res[0]+res[1])/2)
# print("Time for chain mode:", res[0])
# k = max(res[2],res[3])
# t = res[1]+res[4]+k
# print("Time for integration:", t)    
