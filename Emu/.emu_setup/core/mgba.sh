#!/bin/sh

. /mnt/SDCARD/spruce/scripts/helperFunctions.sh
BG="/mnt/SDCARD/spruce/imgs/bg_tree.png"
EMU_NAME="$(echo "$1" | cut -d'/' -f5)"
CONFIG="/mnt/SDCARD/Emu/${EMU_NAME}/config.json"
SYS_OPT="/mnt/SDCARD/Emu/.emu_setup/options/${EMU_NAME}.opt"

display -i "$BG" -t "Core changed to mgba"

if [ "$EMU_NAME" = "GB" ] || [ "$EMU_NAME" = "GBC" ]; then
    sed -i 's|"Emu Core: (✓GAMBATTE)-mgba"|"Emu Core: gambatte-(✓MGBA)"|g' "$CONFIG"
    sed -i 's|"/mnt/SDCARD/Emu/.emu_setup/core/mgba.sh"|"/mnt/SDCARD/Emu/.emu_setup/core/gambatte.sh"|g' "$CONFIG"
else
    sed -i 's|"Emu Core: mgba-(✓GPSP)"|"Emu Core: (✓MGBA)-gpsp"|g' "$CONFIG"
    sed -i 's|"/mnt/SDCARD/Emu/.emu_setup/core/mgba.sh"|"/mnt/SDCARD/Emu/.emu_setup/core/gpsp.sh"|g' "$CONFIG"
fi
sed -i 's|CORE=.*|CORE=\"mgba\"|g' "$SYS_OPT"

sleep 2
display_kill
