#!/bin/bash

docker run -d -p 10000:22 -p 50070:50070 -p 50075:50075 -p 9001:9001 -v /tmp/hadoop:/data/hadoop --name hadoop centos/hadoop:1.1
