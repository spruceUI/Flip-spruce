#!/bin/ash

. /mnt/SDCARD/spruce/scripts/helperFunctions.sh

DEVICE_PATH="/sys/devices/virtual/disp/disp/attr/enhance"
SAVED_HSL="/mnt/SDCARD/spruce/settings/saved_hsl"
MAINUI_CONF="/config/system.json"

getContrastFromDevice() {
    if [ -f "$SAVED_HSL" ]; then
        awk -F, '{print $3}' "$SAVED_HSL"
    else
        echo 50
    fi
}

# Function to set HSL values based on intensity level
setHSLValues() {
    intensity=$1
    Contrast=$(getContrastFromDevice) 
	case "$intensity" in
		"Low")          Luminance=30; Contrast=45; Saturation=90; Hue=95 ;;  # Slight warm tint
		"Moderate")     Luminance=30; Contrast=40; Saturation=90; Hue=95 ;;  # Warmer orange tint
		"Strong")       Luminance=30; Contrast=35; Saturation=90; Hue=95 ;;  # Strong orange-red tint
		"Very strong")  Luminance=30; Contrast=30; Saturation=95; Hue=95 ;;  # Maximum warm/red tint
		*)              Luminance=30; Contrast=50; Saturation=50; Hue=50 ;;  # Default (no filter)
	esac
}

intensity=$1

if [ -z "$intensity" ]; then
    return 0
fi

if [ "$intensity" = "Off" ]; then
    if flag_check "bl_filter"; then
        # Restore previous state and remove the filter flag
        if [ -f "$SAVED_HSL" ]; then
			cat "$SAVED_HSL" > "$DEVICE_PATH"
			Luminance=$(awk -F, '{print $2}' "$SAVED_HSL")
			Contrast=$(awk -F, '{print $3}' "$SAVED_HSL")
			Saturation=$(awk -F, '{print $4}' "$SAVED_HSL")
			Hue=$(awk -F, '{print $5}' "$SAVED_HSL")
			flag_remove "bl_filter"
		else
			flag_remove "bl_filter"
			return 0
		fi
    else
		return 0
	fi
else
    if ! flag_check "bl_filter"; then
        # Save current state and add the filter flag
        cp "$DEVICE_PATH" "$SAVED_HSL"
        flag_add "bl_filter"
    fi

    # Set HSL values based on intensity and apply
    setHSLValues "$intensity"
    echo "1,$Luminance,$Contrast,$Saturation,$Hue" > "$DEVICE_PATH"
	
fi

# Update MainUI Conf    
sed -i "s/\"lumination\":\s*\([0-9]\|1[0-9]\|2[0-2]\)/\"lumination\": $((Luminance / 5))/" "$MAINUI_CONF"
sed -i "s/\"hue\":\s*\([0-9]\|1[0-9]\|2[0-2]\)/\"hue\": $((Hue / 5))/" "$MAINUI_CONF"
sed -i "s/\"saturation\":\s*\([0-9]\|1[0-9]\|2[0-2]\)/\"saturation\": $((Saturation / 5))/" "$MAINUI_CONF"
sed -i "s/\"contrast\":\s*\([0-9]\|1[0-9]\|2[0-2]\)/\"contrast\": $((Contrast / 5))/" "$MAINUI_CONF"
