#!/bin/sh
. /mnt/SDCARD/spruce/scripts/helperFunctions.sh

idle_type="$1"
timeout_value="$2"

# Function to start idlemon based on idle_type and timeout_value
start_idlemon() {
  idle_type="$1"
  timeout_value="$2"
  idle_time=""
  idle_count=""

  case "$idle_type" in
    in_menu)
      case "$timeout_value" in
        Off)
		  pgrep -f 'idlemon.*MainUI' | xargs kill -9
          return 0
          ;;
        2m)
          idle_time=120
          idle_count=10
          ;;
        5m)
          idle_time=300
          idle_count=20
          ;;
        10m)
          idle_time=600
          idle_count=40
          ;;
        *)
          return 1
          ;;
      esac
      # Kill all processes with 'idlemon' and 'MainUI' in the name
	  pgrep -f 'idlemon.*MainUI' | xargs kill -9
	  # Start idlemon for in_menu with MainUI
      idlemon -p "MainUI,switcher" -t "$idle_time" -c "$idle_count" -s "/mnt/SDCARD/spruce/scripts/idlemon_actionWrapper.sh" -i > /dev/null &
      ;;

    in_game)
      case "$timeout_value" in
         Off)
		  pgrep -f 'idlemon.*miyoo' | xargs kill -9
          return 0
          ;;
        2m)
          idle_time=120
          idle_count=10
          ;;
        5m)
          idle_time=300
          idle_count=20
          ;;
        10m)
          idle_time=600
          idle_count=40
          ;;
		30m)
          idle_time=1800
          idle_count=300
          ;;
        *)
          return 1
          ;;
      esac
      # Kill all processes with 'idlemon' and 'miyoo' in the name
	  pgrep -f 'idlemon.*miyoo' | xargs kill -9
	  # Start idlemon for in_game with multiple processes
      idlemon -p "ra32.miyoo,drastic,PPSSPP" -t "$idle_time" -c "$idle_count" -s "/mnt/SDCARD/spruce/scripts/idlemon_actionWrapper.sh" -i > /dev/null &
      ;;

    *)
      echo "Unsupported idle type: $idle_type"
      return 1
      ;;
  esac
}

# Function to reapply both settings
reapply_settings() {
  # Handle in_menu setting
  IDLE_MENU_VALUE=$(setting_get "idlemon_in_menu")
  if [ "$IDLE_MENU_VALUE" != "Off" ]; then
    timeout_value="$IDLE_MENU_VALUE"
  else
    timeout_value="Off"
  fi
  start_idlemon "in_menu" "$timeout_value"

  # Handle in_game setting
  IDLE_GAME_VALUE=$(setting_get "idlemon_in_game")
  if [ "$IDLE_GAME_VALUE" != "Off" ]; then
    timeout_value="$IDLE_GAME_VALUE"
  else
    timeout_value="Off"
  fi
  start_idlemon "in_game" "$timeout_value"
}

# Main script logic
case "$1" in
    "reapply")
        reapply_settings
        ;;
    *)
        if [ -z "$idle_type" ]; then
            reapply_settings
        else
            # If idle_type is provided but no timeout_value, fetch from settings
            if [ -z "$timeout_value" ]; then
                case "$idle_type" in
                    in_menu)
                        IDLE_MENU_VALUE=$(setting_get "idlemon_in_menu")
                        if [ "$IDLE_MENU_VALUE" != "Off" ]; then
                            timeout_value="$IDLE_MENU_VALUE"
                        else
                            timeout_value="Off"
                        fi
                        ;;
                    in_game)
                        IDLE_GAME_VALUE=$(setting_get "idlemon_in_game")
                        if [ "$IDLE_GAME_VALUE" != "Off" ]; then
                            timeout_value="$IDLE_GAME_VALUE"
                        else
                            timeout_value="Off"
                        fi
                        ;;
                    *)
                        echo "Unsupported idle type: $idle_type"
                        exit 1
                        ;;
                esac
            fi
            start_idlemon "$idle_type" "$timeout_value"
        fi
        ;;
esac
