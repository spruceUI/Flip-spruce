#!/bin/sh
echo $0 $*
progdir=`dirname "$0"`/drastic
cd $progdir
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir

echo "=============================================="
echo "==================== DRASTIC  ================="
echo "=============================================="

../cpufreq.sh

export HOME=/mnt/SDCARD
#export SDL_AUDIODRIVER=dsp
./drastic "$*"
