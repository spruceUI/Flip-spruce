#!/bin/sh
echo $0 $*
progdir=`dirname "$0"`
cd $progdir
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir

echo "=============================================="
echo "==================== PPSSPP  ================="
echo "=============================================="

./cpufreq.sh

export HOME=$progdir
#export SDL_AUDIODRIVER=dsp   //disable 20231031 for sound suspend issue
./PPSSPPSDL "$*"
