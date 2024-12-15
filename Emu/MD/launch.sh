#!/bin/sh
echo "===================================="
echo $0 $*
progdir=`dirname "$0"`
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir

RA_DIR=$progdir/../../RetroArch
EMU_DIR=$progdir

cd $RA_DIR/

$EMU_DIR/cpufreq.sh

#HOME=$RA_DIR/ $RA_DIR/ra64.miyoo -v $NET_PARAM -L $EMU_DIR/picodrive_libretro.so "$*"
HOME=$RA_DIR/ $RA_DIR/ra64.miyoo -v $NET_PARAM -L $RA_DIR/.retroarch/cores/picodrive_libretro.so "$*"
#HOME=$RA_DIR/ $RA_DIR/retroarch -v $NET_PARAM -L $RA_DIR/.retroarch/cores/genesis_plus_gx_libretro.so "$*"