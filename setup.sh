#!/bin/bash

# ----------------------
# Color Variables
# ----------------------
RED="\033[0;31m"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

# --------------------------------------
# Get ChromecastIP from Zerotier
# --------------------------------------

# Run NodeJS to file chromecase IP
chromecastIP=$(node index)
echo -e "${GREEN}Found Chromecast IP in network: ${chromecastIP}"
echo

# --------------------------------------
# Active debug mode for Chromecast
# --------------------------------------

# Enable Developer mode for Device
echo -e "${LCYAN}Pre1. Enable developer mode for device: https://allaboutchromecast.com/enable-developer-options-in-chromecast-with-google-tv/"
read -p "Pres Enter to continue..."
echo

echo -e "${LCYAN}Pre2. Make sure enable debug mode for device"
read -p "Pres Enter to continue..."
echo

# stay connect via USB
echo -e "${YELLOW}1. Please connect device with PC/Laptop via USB. Press Enter to continue${NC}"
read -p ""

# connect to same network (computer and mobile device both)
step_num_two="2. "
connect_to_same_network() {
  echo -e "${YELLOW}${step_num_two}Please make sure you connect to same network (enable Zerotier VPN on both PC and device). Press Enter to continue${NC}"
  step_num_two=""
  read -p ""
}
connect_to_same_network

# ping DeviceIP (must be have ping to your device)
echo -e "${YELLOW}3. Try to ping to your device at IP: ${chromecastIP}${NC}"
while :; do
  if ping -c 1 ${chromecastIP} &>/dev/null; then
    echo -e "${GREEN} Your device is accessable. Go to next step!"
    echo
    break
  else
    echo -e "${RED} Your device is not accessable. Retry to connect to same network${NC}"
    connect_to_same_network
  fi
done

# adb kill-server
echo -e "${YELLOW}4. Kill ADB server${NC}"
adb kill-server
echo

# adb usb
echo -e "${YELLOW}4.Enable adb usb"
echo -e "${CYAN}Please check to make sure that we trust computer${NC}"
adb usb
echo

# adb tcpip 5555
echo -e "${YELLOW}5. Enable adb via TCP/IP${NC}"
sleep 3
adb tcpip 5555
echo

# unplug usb cable (as per @captain_majid 's comment)

# adb connect yourDeviceIP
echo -e "${YELLOW}6. Try connect to your device at IP ${chromecastIP}${NC}"
adb connect ${chromecastIP}
echo

# adb devices (must be see two device names , one of them is by deviceIP)
echo -e "${YELLOW}7. List all available devices${NC}"
adb devices
echo

# unplug USB cable
echo -e "${YELLOW}8. Please unplug USB cable. Press Enter to continue${NC}"
read -p ""
echo

# --------------------------------------
# Starting Scrcpy for testing
# --------------------------------------
echo -e "${YELLOW}9. Starting Scrcpy for testing${NC}"
scrcpy --tcpip=${chromecastIP}
echo

# FINISH
echo -e "${GREEN}10. FINISHINGGGGG! Allthing is done!"
echo
