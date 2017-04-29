#!/bin/bash
mkdir -p /sys/fs/cgroup/cpu/test01
#echo $$ | sudo tee -a /sys/fs/cgroup/cpu/test01/tasks
echo 1000000 > /sys/fs/cgroup/cpu/test01/cpu.cfs_period_us
echo 100000 > /sys/fs/cgroup/cpu/test01/cpu.cfs_quota_us
yes >> /dev/null
