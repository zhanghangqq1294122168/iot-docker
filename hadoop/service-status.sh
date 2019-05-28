#!/bin/bash

status(){
    for node in s1.namenode.hadoop s1.datanode.hadoop s2.datanode.hadoop; do
        echo -e "######### ${node} #########"
        docker exec -it $node jps
        docker exec -it $node cat /etc/hosts | tail -n3
        echo -e "\n"
    done
}

status
