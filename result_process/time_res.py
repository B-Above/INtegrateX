import re

def sum_elapsed_times(filepath):
    total_elapsed_time_in_ms = 0.0  # 总时间初始化为0毫秒

    # 正则表达式用于匹配 elapse=...ms 格式
    pattern = re.compile(r"elapse=(\d+\.\d+)ms")

    with open(filepath, 'r') as file:
        for line in file:
            match = pattern.search(line)
            if match:
                # 将匹配到的时间（字符串）转换为浮点数
                elapsed_time = float(match.group(1))
                total_elapsed_time_in_ms += elapsed_time

    # 将毫秒转换为秒
    total_elapsed_time_in_seconds = total_elapsed_time_in_ms / 1000.0
    return total_elapsed_time_in_seconds

# 使用函数
file_path = 'receive_bank.txt'
total_time = sum_elapsed_times(file_path)
print(f"Total elapsed time in seconds: {total_time}")