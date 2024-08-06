#!/bin/bash -x

LOGFILE=mlc-loop-log.txt
date | tee ${LOGFILE} # create a new log file; do not append

echo "/etc/os-release" | tee -a ${LOGFILE}
cat /etc/os-release | tee -a ${LOGFILE}
echo "uname -r" | tee -a ${LOGFILE}
uname -r | tee -a ${LOGFILE}
echo "ls -FC /lib/modules/$(uname -r)/kernel/drivers" | tee -a ${LOGFILE}
ls -FC /lib/modules/$(uname -r)/kernel/drivers | tee -a ${LOGFILE}
echo "ls -lFR /lib/modules/$(uname -r)/kernel/drivers/cxl" | tee -a ${LOGFILE}
ls -lFR /lib/modules/$(uname -r)/kernel/drivers/cxl | tee -a ${LOGFILE}
echo "lspci | grep -i -v AMD" | tee -a ${LOGFILE}
lspci | grep -i -v AMD | tee -a ${LOGFILE}
echo "ls -R /dev/dax*" | tee -a ${LOGFILE}
ls -R /dev/dax* | tee -a ${LOGFILE}
echo "daxctl list" | tee -a ${LOGFILE}
daxctl list | tee -a ${LOGFILE}
echo "ls -R /dev/cxl*" | tee -a ${LOGFILE}
ls -R /dev/cxl* | tee -a ${LOGFILE}
echo "sudo cxl list -vvv" | tee -a ${LOGFILE}
sudo cxl list -vvv | tee -a ${LOGFILE}
echo "numactl -H" | tee -a ${LOGFILE}
numactl -H | tee -a ${LOGFILE}
echo "lsmem" | tee -a ${LOGFILE}
lsmem | tee -a ${LOGFILE}
echo "numactl -H" | tee -a ${LOGFILE}
numactl -H | tee -a ${LOGFILE}


echo 4000 | sudo tee /proc/sys/vm/nr_hugepages
echo "cat /proc/sys/vm/nr_hugepages" | tee -a ${LOGFILE}
cat /proc/sys/vm/nr_hugepages | tee -a ${LOGFILE}

# for i in {1..1}
for i in {1..1000000}
do
  echo "iteration $i" | tee -a ${LOGFILE}

  echo "sudo mlc" | tee -a ${LOGFILE}
  /usr/bin/time -p -a -o ${LOGFILE} sudo mlc | tee -a ${LOGFILE}

  #echo "sudo mlc --peak_injection_bandwidth -b512m -t120" | tee -a ${LOGFILE}
  #/usr/bin/time -p -a -o ${LOGFILE} sudo mlc --peak_injection_bandwidth -b512m -t120 | tee -a ${LOGFILE}

  date | tee -a ${LOGFILE}
done

