#!/bin/bash

# update hosts
cat >/tmp/hosts <<!
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

!

# list="$NAME_NODE $_DATA_NODE"
echo >/etc/hosts
for host in $1; do
    ssh $host 'echo -e "`hostname -I`    `hostname`"' >>/tmp/hosts
done

# sync hosts
for host in $1; do
    scp /tmp/hosts $host:/etc/hosts
done
