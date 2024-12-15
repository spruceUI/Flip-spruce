#!/bin/sh
echo $0 $*
progdir=/mnt/sdcard/Apps/BootRetroArch64

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$progdir
#HOME=progdir $progdir/retroarch -v

RA_DIR=/mnt/sdcard/RetroArch
cd $RA_DIR/

HOME=$RA_DIR/ $RA_DIR/ra64.miyoo -v
