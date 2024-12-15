#!/bin/sh
echo $0 $*
progdir=`dirname "$0"`
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir

RA_DIR=$progdir/../../RetroArch
EMU_DIR=$progdir
cd $RA_DIR/

$EMU_DIR/cpufreq.sh

cd $RA_DIR/
if [ -f "../Roms/PSBIOS/${ROMNAMETMP}.bios" ]; then
		cp -f "../Roms/PSBIOS/${ROMNAMETMP}.bios" "../RetroArch/.retroarch/system/scph101.bin"
else
		cp -f "../Roms/PSBIOS/scph1001.bios" "../RetroArch/.retroarch/system/scph101.bin"
fi

#disable netplay
NET_PARAM=

HOME=$RA_DIR/ $RA_DIR/ra64.miyoo -v $NET_PARAM -L $RA_DIR/.retroarch/cores/pcsx_rearmed_libretro.so "$*"
#HOME=$RA_DIR/ $RA_DIR/retroarch -v $NET_PARAM -L $RA_DIR/.retroarch/cores/pcsx_rearmed_libretro.so "$*"
