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
    bc_ts = [0,0,0,0]
    c = [{},{},{}]
    
    pattern = r"gas=(\d+)"
  
    for i in gas_list:
        match = re.search(pattern, i)
        if match:
            g = int(match.group(1))
            if g != 0:
                a = decide_which(i)
                bc_ts[a] += 1
                num_p = r"number=(\d+)"
                match_num = re.search(num_p, i)
                num = int(match_num.group(1))
                
                if num in c[a]:
                    e_gas[a] -= c[a][num]
                    e_gas[4] -= c[a][num]  # group(1) 返回第一个捕获组的内容
                c[a][num] = g
                e_gas[a] += g
                e_gas[4] += g 
        
    return e_gas,c,bc_ts

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
    # filename = ['lock.txt','receive_bank.txt','receive_hotel.txt','buy.txt']  # 设置要读取的文件名
    #filename = ['1.txt','2.txt','chain_mode.txt']  # 设置要读取的文件名
    filename = ['3c1.txt','3c2.txt','3cChain.txt']
    #filename = ['divid_hotel.txt','divid_hotel_vy.txt','ndivid_hotel.txt','ndivid_hotel_vy.txt']
    #filename = ['divid_bank.txt','divid_bank_vy.txt','ndivid_bank.txt','ndivid_bank_vy.txt']
    #filename = ['./4/4_lock.txt','./4/4_excute.txt']

    filename = ['./4/4l2.txt','./4/4e2.txt','./4/4l1.txt','./4/4e1.txt','./4/4l3.txt','./4/4e3.txt','./4/4l4.txt','./4/4e4.txt','./4/4c1.txt','./4/4c2.txt','./4/4c3.txt','./4/4c4.txt','./4/4c5.txt']
    filename = ['./5/5l2.txt','./5/5e2.txt','./5/5l1.txt','./5/5e1.txt','./5/5l3.txt','./5/5e3.txt']
    filename = ['./3/3l1.txt','./3/3e1.txt','./3/3l2.txt','./3/3e2.txt','./3/3l3.txt','./3/3e3.txt']
    #filename = ['./new/4c0','./new/4c1','./new/4c2','./new/4c3','./new/4c4']
    #filename = ['./new/5c0','./new/5c1','./new/5c2','./new/5c3','./new/5c4']
    #filename = ['./new/4t0','./new/4t1','./new/4t2','./new/4t3','./new/4t4']
    #filename = ['./new/5t0','./new/5t1','./new/5t2','./new/5t3','./new/5t4']
    x = []
    y = []
    res = []
    filename = ['./new/3c0','./new/3c1','./new/3c2','./new/3c3','./new/3c4']
    #filename = ['./new/4c0','./new/4c1','./new/4c2','./new/4c3','./new/4c4']
    print("GPACT:")
    for i in filename:
        result = read_file_and_find_gas(i,"gas")  # 调用函数
        e = cal_gas(result)
        k = calculate_relay(result)
        e[0][3] = 210000*k
        e[0][4] += e[0][3] 
        print(e[2])
        x.append(e[0])
    print(x)
    # filename = ['./board/4mu0','./board/4mu1','./board/4mu2','./board/4mu3','./board/4mu4']
    # #filename = ['./board/5mu0','./board/5mu1','./board/5mu2','./board/5mu3','./board/5mu4']
    # filename = ['./separation/bank_dep','./separation/bank_vf','./separation/sep_bank_dep','./separation/sep_bank_vf']
    # x = []
    # y = []
    # res = []
    # #print("INtegrateX:")
    # print("bank")
    # for i in filename:
    #     result = read_file_and_find_gas(i,"gas")  # 调用函数
    #     e = cal_gas(result)
    #     k = calculate_relay(result)
    #     e[0][3] = 210000*k
    #     e[0][4] += e[0][3] 
    #     print(e)
    #     x.append(e[0][4])
    # print(x)
   
    # filename = ['./separation/hotel_dep','./separation/hotel_vf','./separation/sep_bank_dep','./separation/sep_bank_vf']
    # x = []
    # y = []
    # res = []
    filename = ['./new/3t3','./new/3t4','./new/3t5','./new/3t6','./new/3t7']
    filename = ['./new/3i0','./new/3i1','./new/3i2','./new/3i3','./new/3i4']
    print("INtegrateX:")
    #print("hotel")
    for i in filename:
        result = read_file_and_find_gas(i,"gas")  # 调用函数
        e = cal_gas(result)
        k = calculate_relay(result)
        e[0][3] = 210000*k
        e[0][4] += e[0][3] 
        print(e[2])
        x.append(e[0])
    print(x)