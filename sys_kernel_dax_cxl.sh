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

#sudo apt -y install numactl
#sudo dnf -y install numactl
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
#sudo apt -y install daxctl
#sudo dnf -y install daxctl
docmd "daxctl -v"
docmd "daxctl list"

# docmd "lsmod|grep cxl"
echo "$ lsmod|grep cxl" | tee -a ${LOGFILE}
lsmod|grep cxl | tee -a ${LOGFILE}

docmd "ls -l /dev/cxl/mem0"
#sudo apt -y install ndctl
#sudo dnf -y install cxl-cli
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


                             SMARTCXLBIN=$(readlink -f "$(command -v smartcxl)")
! [ -f "${SMARTCXLBIN}" ] && SMARTCXLBIN=./smartcxl
! [ -f "${SMARTCXLBIN}" ] && SMARTCXLBIN=./CXL_Firmwares/smartcxl
! [ -f "${SMARTCXLBIN}" ] && SMARTCXLBIN=/mnt/CXL_Firmwares/smartcxl
! [ -f "${SMARTCXLBIN}" ] && SMARTCXLBIN=/mnt/Share02Backup/CXL_Firmwares/
if [ -f "${SMARTCXLBIN}" ]; then
  [ "${SMARTCXLBIN}" != "./smartcxl" ] && cp ${SMARTCXLBIN} ./smartcxl
  chmod +x ./smartcxl
  SMARTCXLBIN=./smartcxl
fi
# if [ -x "$(command -v smartcxl)" ]; then
if [ -x "${SMARTCXLBIN}" ]; then
  # SMARTCXLBIN=$(readlink -f "$(command -v smartcxl)")
  docmd "sudo ${SMARTCXLBIN} version"
  docmd "sudo ${SMARTCXLBIN} list"
else
  echo "warning: smartcxl not found"
fi

# exit # end script
