#source /mnt/SDCARD/.tmp_update/fundidos.sh
echo -n 0 > /sys/class/gpio/gpio20/value
sleep 0.1
echo -n 1 > /sys/class/gpio/gpio20/value
sleep 0.1
echo -n 0 > /sys/class/gpio/gpio20/value
sleep 0.1
echo -n 1 > /sys/class/gpio/gpio20/value
sleep 0.1
echo -n 0 > /sys/class/gpio/gpio20/value

FLAGS_DIR="/mnt/SDCARD/spruce/flags"

cat /tmp/cmd_to_run.sh > "${FLAGS_DIR}/lastgame.lock"
sleep 0.5
echo heartbeat > /sys/devices/platform/leds/leds/work/trigger

	killall -9 runmiyoo.sh
	killall -9 updater
	killall -9 runtime.sh
	killall -9 principal.sh
	killall -9 MainUI
	killall -9 keymon
	killall -9 autoRA.sh
	killall -15 ra64.miyoo
	killall -15 emulationstation
	killall -9 keymon

sleep 0.5
/usr/bin/fbdisplay /mnt/SDCARD/spruce/imgs/save.png &
###jq '. + {"saveactive": 1}' /mnt/SDCARD/system.json > /mnt/SDCARD/system_temp.json && mv /mnt/SDCARD/system_temp.json /mnt/SDCARD/system.json
/mnt/SDCARD/spruce/bin/jq '. + {"saveactive": 1}' /mnt/SDCARD/system.json > /tmp/system_temp.json && mv /tmp/system_temp.json /mnt/SDCARD/system.json
sleep 0.5
sync
sleep 1.5
#fade_in
poweroff
