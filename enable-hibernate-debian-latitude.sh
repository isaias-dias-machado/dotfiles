echo "INFO: Idempotency setup"
sudo swapoff /swapfile 2>/dev/null || true
sudo rm -f /swapfile

echo "INFO: Configuring swap file with 16GB"
sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

if ! grep '/swapfile none swap sw 0 0' /etc/fstab; then
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

sudo swapon --show
free -h

echo "INFO: Configuring hibernation"
id=$(sudo findmnt -no UUID -T /swapfile)

PARTITION_UUID=$(findmnt -no UUID -T /swapfile)
RESUME_OFFSET=$(sudo filefrag -v /swapfile | awk '{if($1=="0:"){print substr($4, 1, length($4)-2); exit}}')

# Backup
sudo cp /etc/default/grub /etc/default/grub.backup

# Replace the line
sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"quiet resume=UUID=$PARTITION_UUID resume_offset=$RESUME_OFFSET\"|" /etc/default/grub

# Show what was set
grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub

sudo update-grub

sudo update-initramfs -u
