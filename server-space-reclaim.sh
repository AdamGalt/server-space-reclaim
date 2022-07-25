## Script to quickly free up space on a Linux host
## Written by Adam Galt
## v1.0 - 12/03/2022

# Run as root check
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

echo ""
echo " Running autoremove and autoclean "
echo ""
echo ""
echo " ------------------------------------------------ "

echo "Running Autoremove"
# Safe autoremove of old packages
apt-get autoremove
echo ""
echo " ------------------------------------------------ "

echo "Running Autoclean"
echo ""
# Safe autoclean
apt-get autoclean
echo ""
echo " ------------------------------------------------ "

echo "Size of cache:"
# Show size of cache
du -sh /var/cache/apt     # Show apt cache/apt

# Check before doing a full clean of the entire cache
echo ""
while true; do
    read -p "Do you wish to do a full clean of the cache and free more space? - Y/N: " yn
    case $yn in
        [Yy]* ) apt-get clean; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo ""
echo " ------------------------------------------------ "

echo "Size of journal entries: "
echo ""
journalctl --disk-usage

while true; do
    read -p "Do you wish to clean up journal logs, keeping last 7 days only? - Y/N: " yn
    case $yn in
        [Yy]* ) journalctl --vacuum-time=7d; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo ""
echo ""
echo " ------------------------------------------------ "
echo "                ~~ All clean! ~~ "
echo " ------------------------------------------------ "
echo ""

exit 0
