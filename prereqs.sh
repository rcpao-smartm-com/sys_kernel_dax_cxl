#!/bin/bash -x

if [ -x "$(command -v apt)" ]; then
  # apt exists
  sudo apt -y install numactl
  sudo apt -y install daxctl
  sudo apt -y install ndctl
elif [ -x "$(command -v yum)" ]; then
  # yum exists
  sudo yum -y install numactl
  sudo yum -y install daxctl
  sudo yum -y install cxl-cli
else
  echo "error: apt and yum were not found"
fi

# Ref: https://stackoverflow.com/a/26759734
