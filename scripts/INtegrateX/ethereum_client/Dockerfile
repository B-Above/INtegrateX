FROM meshplus/ethereum:1.2.0

# 创建工作目录（如果不存在的话）
WORKDIR /root/datadir

# 复制 account.key 文件到镜像中
RUN rm -rf /root/datadir/
COPY account.key /root/datadir/keystore/
COPY start.key /root/datadir/keystore/
# 暴露需要的端口
EXPOSE 8545 8546 30303

# 运行 geth 命令
CMD ["geth"]
