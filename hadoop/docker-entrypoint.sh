#!/bin/bash

set -e

. /etc/profile

# 替换 NameNode 服务器名
NAME_NODE=${NAME_NODE:-localhost}
sed -i "s#HOSTNAME#${NAME_NODE}#" $HADOOP_HOME/etc/hadoop/core-site.xml
sed -i "s#HOSTNAME#${NAME_NODE}#" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
sed -i "s#HOSTNAME#${NAME_NODE}#" $HADOOP_HOME/etc/hadoop/yarn-site.xml
sed -i "s#HADOOP_TMP#${HADOOP_TMP}#" $HADOOP_HOME/etc/hadoop/core-site.xml
sed -i "s#\${JAVA_HOME}#${JAVA_HOME}#" $HADOOP_HOME/etc/hadoop/hadoop-env.sh 

# 替换数据目录
HADOOP_REPLICATION=${REPLICATION:-1}
sed -i "s#HADOOP_NAME#$HADOOP_NAME#" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
sed -i "s#HADOOP_DATA#$HADOOP_DATA#" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
sed -i "s#HADOOP_REPLICATION#$HADOOP_REPLICATION#" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo -e "\nexport YARN_LOG_DIR=$HADOOP_LOG" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh
echo -e "\nexport HADOOP_LOG_DIR=$HADOOP_LOG" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# DataNode
if [[ ! -f "$HADOOP_HOME/etc/hadoop/slaves"  ]];then
    DATA_NODE=${DATA_NODE:-localhost}
    for server in $DATA_NODE; do
        echo "$server" >> "$HADOOP_HOME/etc/hadoop/slaves"
    done
fi

# 如果是 NameNode节点或,单机版则执行
if [ "$HOSTNAME" = "$NAME_NODE" ] || [ "$(cat $HADOOP_HOME/etc/hadoop/slaves)" = "localhost" ] ; then
    # 如果数据目录为空(不存在指定目录), 初始化 namenode
    if [ ! -d $HADOOP_NAME/current ];then
        $HADOOP_HOME/bin/hdfs namenode -format
    fi

    # 启动 sshd 服务,更新 hosts 解析
    /usr/sbin/sshd && sleep 3
    /update_host.sh "$NAME_NODE $DATA_NODE"

    # 启动 hadoop 服务
    $HADOOP_HOME/sbin/start-dfs.sh
    $HADOOP_HOME/sbin/start-yarn.sh

    # 关闭 sshd 服务
    kill -9 $(ps -ef | grep -v grep | grep sshd | awk '{print $2}')
fi

exec "$@"
