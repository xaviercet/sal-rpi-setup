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
