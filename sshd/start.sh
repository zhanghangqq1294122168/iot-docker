#!/bin/bash

docker run -d -p 9001:9001 -p 2222:22 --name sshd centos/sshd:1.1
