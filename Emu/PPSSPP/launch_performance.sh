#!/bin/sh
echo 1 > /sys/devices/system/cpu/cpu0/online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo $0 $*
progdir=`dirname "$0"`
cd $progdir
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir

echo "=============================================="
echo "==================== PPSSPP  ================="
echo "=============================================="

#./cpufreq.sh
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
#echo 1416000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

export HOME=$progdir
#export SDL_AUDIODRIVER=dsp   //disable 20231031 for sound suspend issue
./PPSSPPSDL "$*"
