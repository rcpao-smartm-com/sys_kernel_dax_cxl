#!/bin/bash


# script sys_kernel_dax_cxl_$(date +%Y%m%d-%H%M%S)_$(hostname)_$(uname -r).txt
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOGFILE=sys_kernel_dax_cxl_${TIMESTAMP}_$(hostname)_$(uname -r).txt


function docmd() {
  CMD=$1
  echo "$ ${CMD}" | tee -a ${LOGFILE}
  ${CMD} | tee -a ${LOGFILE}
}


docmd "hostname"
docmd "whoami"
docmd "ip a"
docmd "sudo dmidecode"
docmd "grep PRETTY_NAME /etc/os-release"
docmd "uname -r"

docmd "lsmem"
docmd "numactl -H"

# SLES5 SP6 requires sudo/root for lspci (even without -vvv)
docmd "sudo lspci"
# pipe | does not work in docmd()
# docmd "lspci\|grep -i cxl"
echo "$ sudo lspci|grep -i cxl" | tee -a ${LOGFILE}
sudo lspci|grep -i cxl | tee -a ${LOGFILE}

docmd "lsmod"
# docmd "lsmod|grep dax"
echo "$ lsmod|grep dax" | tee -a ${LOGFILE}
lsmod|grep dax | tee -a ${LOGFILE}

docmd "ls -l /dev/dax0.0"
docmd "daxctl -v"
docmd "daxctl list"

# docmd "lsmod|grep cxl"
echo "$ lsmod|grep cxl" | tee -a ${LOGFILE}
lsmod|grep cxl | tee -a ${LOGFILE}

docmd "ls -l /dev/cxl/mem0"
docmd "cxl -v"
docmd "sudo cxl list -vvvv"

docmd "sudo lspci -vvv"
# docmd "sudo lspci -vvv|grep CXLCtl"
# $ sudo lspci -vvv|grep CXLCtl
# lspci: invalid option -- '|'
# Usage: lspci [<switches>]
# man sudo example: sudo sh -c "cd /home ; du -s * | sort -rn > USAGE"
echo "$ sudo lspci -vvv|grep CXLCtl" | tee -a ${LOGFILE}
sudo lspci -vvv|grep CXLCtl | tee -a ${LOGFILE}

docmd "smartcxl version"
docmd "sudo smartcxl list"

# exit # end script
