#!/bin/sh
EVENT=${1:-short-press}

LONG_PRESS_TIMEOUT=2 # s
DEBOUNCE=1 # s
PIDFILE="/tmp/$(basename $0).pid"
LOCKFILE=/tmp/.power_key
LONG_PRESS_ACTIVE="/tmp/.long_press_active"
CUSTOMER1_DIR=/media/sdcard0/miyoo355
CUSTOMER2_DIR=/media/sdcard1/miyoo355
export CUSTOMER_DIR=${CUSTOMER1_DIR}
if [ -d ${CUSTOMER2_DIR} ]; then
  export CUSTOMER_DIR=${CUSTOMER2_DIR}
fi

short_press()
{
    if which systemctl >/dev/null; then
        SUSPEND_CMD="systemctl suspend"
    elif which pm-suspend >/dev/null; then
        SUSPEND_CMD="pm-suspend"
    else
        SUSPEND_CMD="echo -n mem > /sys/power/state"
    fi

    if [ ! -f $LOCKFILE ]; then
        logger -t $(basename $0) "[$$]: Prepare to suspend..."

        touch $LOCKFILE
        echo -n 0 > /sys/class/gpio/gpio20/value
        sleep 0.05
        echo -n 1 > /sys/class/gpio/gpio20/value
        sleep 0.05
        echo -n 0 > /sys/class/gpio/gpio20/value
        killall keymon
        sh -c "$SUSPEND_CMD"
        ${CUSTOMER_DIR}/app/keymon /dev/input/event5 &
        ${CUSTOMER_DIR}/app/keymon /dev/input/event0 &
        ${CUSTOMER_DIR}/app/keymon /dev/input/event1 &
        { sleep $DEBOUNCE && rm $LOCKFILE; }&
    fi
}

long_press()
{
    # Marca que la pulsación larga está activa
    touch $LONG_PRESS_ACTIVE
    killall -9 keymon
    /mnt/SDCARD/spruce/scripts/apaga.sh
    # Elimina la marca después de la ejecución
    rm -f $LONG_PRESS_ACTIVE
}

logger -t $(basename $0) "[$$]: Received power key event: $@..."

case "$EVENT" in
    press)
        # Lock it
        exec 3<$0
        flock -x 3

        start-stop-daemon -K -q -p $PIDFILE || true
        start-stop-daemon -S -q -b -m -p $PIDFILE -x /bin/sh -- \
            -c "sleep $LONG_PRESS_TIMEOUT; $0 long-press"

        # Unlock
        flock -u 3
        ;;
    release)
        # Evita la acción de "pulsación corta" si "pulsación larga" está activa
        if [ -f $LONG_PRESS_ACTIVE ]; then
            rm -f $LONG_PRESS_ACTIVE
            exit 0
        fi

        # Avoid race with press event
        sleep .5

        start-stop-daemon -K -q -p $PIDFILE && short_press
        ;;
    short-press)
        short_press
        ;;
    long-press)
        long_press
        ;;
esac
