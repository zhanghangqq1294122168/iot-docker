FROM centos:7.5.1804

# 配置软件安装源, 安装软件
RUN rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7 && \
    rm -f /etc/yum.repos.d/* && \
    curl -so /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    curl -so /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    sed -i '/aliyuncs.com/d' /etc/yum.repos.d/Centos-7.repo /etc/yum.repos.d/epel-7.repo && \
    yum -y install --setopt=tsflags=nodocs --disableplugin=fastestmirror \
       openssh-clients-7.4p1-16.el7 openssh-server-7.4p1-16.el7 \
       openssl-1.0.2k which rsync python-setuptools-0.9.8-7.el7 \
       yum-plugin-versionlock-1.1.31 && \
    yum versionlock add openssh openssh-server openssh-clients \
       which rsync python-setuptools yum-plugin-versionlock && \
    yum clean all && \
    rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*

# 安装 supervisor
RUN echo -e "[easy_install]\nindex_url = http://pypi.douban.com/simple" > ~/.pydistutils.cfg && \
    easy_install 'supervisor == 3.3.4' 'supervisor-stdout == 0.1.1'

# 配置 sshd 服务
ADD ssh_config /root/.ssh/config
RUN  ssh-keygen -A && \
     ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
     cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys

# 配置 supervisord
ADD sshd.ini /etc/supervisord.d/
ADD supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor

# 时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

EXPOSE 22 9001

# 添加自定义脚本
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
