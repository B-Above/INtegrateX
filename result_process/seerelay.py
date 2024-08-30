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

def calculate_gas(gas_list):
    e_gas =[0,0,0,0,0]
    pattern = r"gas=(\d+)"
    pattern_n = r"number=(\d+)"
    match = re.search(pattern, i)
    for i in gas_list:
        match = re.search(pattern, i)
        if match:
        # 如果找到匹配项，返回匹配的数字部分
            if int(match.group(1)) != 0:
                t_gas += int(match.group(1))  # group(1) 返回第一个捕获组的内容
    return t_gas

def cal_gas(gas_list):
    e_gas =[0,0,0,0,0]
    c = [{},{},{}]
    
    pattern = r"gas=(\d+)"
  
    for i in gas_list:
        match = re.search(pattern, i)
        if match:
            g = int(match.group(1))
            if g != 0:
                a = decide_which(i)
                num_p = r"number=(\d+)"
                match_num = re.search(num_p, i)
                num = int(match_num.group(1))
                
                if num in c[a]:
                    e_gas[a] -= c[a][num]
                    e_gas[4] -= c[a][num]  # group(1) 返回第一个捕获组的内容
                c[a][num] = g
                e_gas[a] += g
                e_gas[4] += g 
        
    return e_gas,c

def calculate_relay(gas_list):
    t_gas = 0
    for i in gas_list:
        if "gasUsed=210000" in i:
        # 如果找到匹配项，返回匹配的数字部分
            t_gas += 1  # group(1) 返回第一个捕获组的内容
    return t_gas

def decide_which(i):
    if "ethereum-1" in i:
        return 0
    elif "ethereum-2" in i:
        return 1
    elif "ethereum-3" in i:
        return 2
    else:
        return 3
    
if __name__ == "__main__":
    t_gas = []
    t = 0
    relay = []
    filename = ['./board/4mu1']
    #filename = ['./board/5mu0','./board/5mu1','./board/5mu2','./board/5mu3','./board/5mu4']
    x = []
    y = []
    res = []
    print("INtegrateX:")
    for i in filename:
        result = read_file_and_find_gas(i,"gasUsed=210000")  # 调用函数
        print(len(result))
        for k in result:
            print(k)
        
   