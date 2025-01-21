# Update the image and cleanup packages
apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y
apt remove firefox -y

# Replace newusername with the desired username
NEW_USER="studentuser"

# Get the Raspberry Pi Serial Number
SERIAL=$(cat /proc/cpuinfo | grep Serial | awk '{print $3}')

# Create the new User
adduser --gecos "" $NEW_USER --disabled-password

# Set the user's password to the serial number
echo "$NEW_USER:$SERIAL" | chpasswd

# Add the user to the sudo group
usermod -aG sudo $NEW_USER

# Confirm the userhas been added and configured
echo "User $NEW_USER created, added to the sudo group, and set to the serial number $SERIAL."

# Disable Wi-Fi permanently by adding dtoverlay=disable-wifi to /boot/config.txt
CONFIG_FILE="/boot/firmware/config.txt"
DISABLE_WIFI="dtoverlay=disable-wifi"

# Check if the line already exists
if grep -q "^$DISABLE_WIFI" "$CONFIG_FILE"; then
    echo "Wi-Fi is already disabled in $CONFIG_FILE."
else
    echo "Disabling Wi-Fi..."
    echo "$DISABLE_WIFI" | sudo tee -a "$CONFIG_FILE" > /dev/null
    echo "Wi-Fi has been disabled. A reboot is required for changes to take effect."
fi
