#!/bin/sh
echo $0 $*
progdir=`dirname "$0"`
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir

RA_DIR=$progdir/../../RetroArch
EMU_DIR=$progdir
cd $RA_DIR/

$EMU_DIR/cpufreq.sh

echo ====================================================================
echo $RA_DIR/.retroarch/cores/fceumm_libretro.so
echo ====================================================================

#HOME=$RA_DIR/ $RA_DIR/ra64.miyoo -v $NET_PARAM -L $EMU_DIR/libfceumm.so "$*"
HOME=$RA_DIR/ $RA_DIR/ra64.miyoo -v $NET_PARAM -L $RA_DIR/.retroarch/cores/fceumm_libretro.so "$*"
#HOME=$RA_DIR/ $RA_DIR/ra64.miyoo -v $NET_PARAM -L $RA_DIR/.retroarch/cores/nestopia_libretro.so "$*"


#HOME=$RA_DIR/ $RA_DIR/retroarch -v $NET_PARAM -L $RA_DIR/.retroarch/cores/fceumm_libretro.so "$*"
#HOME=$RA_DIR/ $RA_DIR/retroarch -v $NET_PARAM -L $EMU_DIR/libfceumm.so "$*"
