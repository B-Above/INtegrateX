import re
import numpy as np
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
    patrelay = r"gasUsed=(\d+)"
    for i in gas_list:
        match = re.search(pattern, i)
        if match:
        # 如果找到匹配项，返回匹配的数字部分
            a = decide_which(i)
            g = int(match.group(1))
            e_gas[a] += g
            e_gas[4] += g  # group(1) 返回第一个捕获组的内容
        match2 = re.search(patrelay,i)
        if match2:
            g = int(match2.group(1))
            e_gas[3] += g
            e_gas[4] += g
    return e_gas

def calculate_relay(gas_list):
    t_gas = 0
    for i in gas_list:
        if "gasUsed=210000" in i:
        # 如果找到匹配项，返回匹配的数字部分
            t_gas += 1  # group(1) 返回第一个捕获组的内容
    return t_gas

def decide_which(s):
    if 'ethereum-1' in s:
        return 0
    elif 'ethereum-2' in s:
        return 1
    elif 'ethereum-3' in s:
        return 2
    else: 
        return 3

# 脚本主执行部分
if __name__ == "__main__":
    t_gas = []
    t = 0
    relay = []
    # filename = ['lock.txt','receive_bank.txt','receive_hotel.txt','buy.txt']  # 设置要读取的文件名
    #filename = ['1.txt','2.txt','chain_mode.txt']  # 设置要读取的文件名
    filename = ['3c1.txt','3c2.txt','3cChain.txt']
    #filename = ['divid_hotel.txt','divid_hotel_vy.txt','ndivid_hotel.txt','ndivid_hotel_vy.txt']
    #filename = ['divid_bank.txt','divid_bank_vy.txt','ndivid_bank.txt','ndivid_bank_vy.txt']
    #filename = ['./4/4_lock.txt','./4/4_excute.txt']

    filename = ['./4/4l2.txt','./4/4e2.txt','./4/4l1.txt','./4/4e1.txt','./4/4l3.txt','./4/4e3.txt','./4/4l4.txt','./4/4e4.txt','./4/4c1.txt','./4/4c2.txt','./4/4c3.txt','./4/4c4.txt','./4/4c5.txt']
    filename = ['./5/5l2.txt','./5/5e2.txt','./5/5l1.txt','./5/5e1.txt','./5/5l3.txt','./5/5e3.txt']
    filename = ['./3/3l1.txt','./3/3e1.txt','./3/3l2.txt','./3/3e2.txt','./3/3l3.txt','./3/3e3.txt']
    x = []
    y = []
    for i in filename:
        print(i)
        result = read_file_and_find_gas(i,'gas')  # 调用函数
        e = calculate_gas(result)
        print(e)
        print(calculate_relay(result))
        x.append(e)
    print("INtegrateX:")
    m = np.array(x[0])+np.array(x[1])
    print(m.tolist())
    m = np.array(x[2])+np.array(x[3])
    print(m.tolist())
    m = np.array(x[4])+np.array(x[5])
    print(m.tolist())
    #
    # m = np.array(x[6])+np.array(x[7])
    # print(m.tolist())
    # print('chain mode:')
    # for i in range(5):
    #     print(x[i+8])
    #print(x[2])
    # print(x[8])
    # print(x[9])
    # print(x[10])
    # print(x[11])
    #print(np.array(x[2])+np.array(x[3]))
        # t +=  calculate_gas(result)
        # relay.append(calculate_relay(result))
    # print("Lines containing 'gas':")
    # result = read_file_and_find_gas(filename[0],'gas')
    # for line in result:
    #     print(line)  # 打印每一行
    # print(filename)
    # print(t_gas)
    # print(relay)
    # print(t)
    # result = read_file_and_find_gas('whole_result.txt','gas')
    # print(calculate_gas(result))

    
