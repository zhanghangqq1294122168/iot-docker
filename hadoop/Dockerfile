FROM bookgh/sshd:1.1

ARG JAVA_VER=8u171
ARG HADOOP_VER=2.8.4
ARG DOWNURL_JAVA="http://svpn.hc-yun.com:10081/down"
ARG DOWNURL_HADOOP="https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VER}"

ENV SOFT_DIR=/usr/local \
    DATA=/data/hadoop

ENV JAVA_HOME=$SOFT_DIR/java \
    HADOOP_HOME=$SOFT_DIR/hadoop \
    HADOOP_DATA=$DATA/data \
    HADOOP_NAME=$DATA/name \
    HADOOP_LOG=$DATA/logs \
    HADOOP_TMP=$DATA/tmp

WORKDIR /tmp

# 安装JDK
RUN curl -SLO ${DOWNURL_JAVA}/jdk-${JAVA_VER}-linux-x64.tar.gz --progress && \
    tar xvf jdk-${JAVA_VER}-linux-x64.tar.gz -C $SOFT_DIR && \
    mv ${SOFT_DIR}/jdk* $JAVA_HOME && \
    rm -f jdk-${JAVA_VER}-linux-x64.tar.gz

# 下载解压 hadoop
RUN curl -SLO ${DOWNURL_HADOOP}/hadoop-${HADOOP_VER}.tar.gz --progress && \
    tar xvf hadoop-${HADOOP_VER}.tar.gz -C $SOFT_DIR && \
    mv ${SOFT_DIR}/hadoop-${HADOOP_VER} $HADOOP_HOME && \
    rm -f $HADOOP_HOME/etc/hadoop/slaves && \
    rm -f hadoop-${HADOOP_VER}.tar.gz

# 添加环境变量
ENV JRE_HOME=${JAVA_HOME}/jre \
    CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib \
    PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$PATH

# host 解析更新脚本
COPY update_host.sh /update_host.sh 

# 添加配置文件模板
COPY core-site.xml $HADOOP_HOME/etc/hadoop/
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/

VOLUME  ["$DATA"]

EXPOSE 22 9001 50070 50075 8088

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh /update_host.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
