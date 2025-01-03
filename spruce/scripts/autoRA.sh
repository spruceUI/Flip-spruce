#!/bin/sh
#. /mnt/SDCARD/spruce/scripts/helperFunctions.sh
#. /mnt/SDCARD/spruce/bin/Syncthing/syncthingFunctions.sh

CUSTOMER1_DIR=/media/sdcard0/miyoo355/
CUSTOMER2_DIR=/media/sdcard1/miyoo355/
export CUSTOMER_DIR=${CUSTOMER1_DIR}
if [ -d ${CUSTOMER2_DIR} ]   ; then
  export CUSTOMER_DIR=${CUSTOMER2_DIR}
fi
FLAGS_DIR="/mnt/SDCARD/spruce/flags"
#messages_file="/var/log/messages"

saveactive=`/usr/miyoo/bin/jsonval saveactive`
  if [ "$saveactive" == "1" ] ; then

${CUSTOMER_DIR}/app/keymon /dev/input/event5 &
${CUSTOMER_DIR}/app/keymon /dev/input/event0 &
${CUSTOMER_DIR}/app/keymon /dev/input/event1 &
input-event-daemon /dev/input/event2

#set_performance
#log_message "AutoRA: Save active flag detected"

#Set the LED
#if flag_check "ledon"; then
#	echo 1 > /sys/devices/platform/sunxi-led/leds/led1/brightness
#else
#	echo 0 > /sys/devices/platform/sunxi-led/leds/led1/brightness
#fi

# copy command to cmd_to_run.sh so game switcher can work correctly
cp "${FLAGS_DIR}/lastgame.lock" /tmp/cmd_to_run.sh

# load a dummy SDL program and try to initialize GPU and other hardware before loading game
#./easyConfig &> /dev/null &

#flag_remove "save_active"
/mnt/SDCARD/spruce/bin/jq '. + {"saveactive": 0}' /mnt/SDCARD/system.json > /tmp/system_temp.json && mv /tmp/system_temp.json /mnt/SDCARD/system.json

#log_message "AutoRA: load game to play"
#sleep 5
nice -n -20 $FLAGS_DIR/lastgame.lock &> /dev/null

# remove tmp command file after game exit
# otherwise the game will load again in principle.sh later
rm -f /tmp/cmd_to_run.sh
fi

