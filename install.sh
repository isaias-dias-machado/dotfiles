source /etc/os-release
if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
	apt install curl git powertop htop strace universal-ctags cscope gdb manpages-dev openvpn rsync	cloc qemu-system-x86 net-tools 
elif [ "$ID" = "fedora" ] || [ "$ID" = "centos" ]; then
	dnf install curl git powertop htop strace universal-ctags cscope gdb manpages-dev openvpn rsync	cloc qemu-system-x86 net-tools 
fi

ln -sr backup.service /etc/systemd/system/
ln -sr backup.sh /usr/local/bin/

mv /etc/hosts /etc/hosts.bak
ln -sr hosts /etc/hosts

ln -sr "vimrc.local" /etc/vim/

dconf load / < dconf.dump

cd chp
make
cd ..
