#!/bin/bash
source /etc/os-release

echo "Running on OS: $ID"

if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
	apt-get update
elif [ "$ID" = "fedora" ] || [ "$ID" = "centos" ]; then
	dnf update
fi

# $1: program name $2: installation function
check_installation() {
	if command -v "$1" &> /dev/null
	then
		$2
	else
		echo "WARNING: Failed to install $1" >&2
		return
	fi
}

# Usage: link path/to/dotfile path/to/target
mylink() {
	rm $2/$1
	ln -sr $1 $2
}

install_docker() {
	if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
		install -m 0755 -d /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/$ID/gpg -o /etc/apt/keyrings/docker.asc
		chmod a+r /etc/apt/keyrings/docker.asc
		echo \
			"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$ID \
			$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
			tee /etc/apt/sources.list.d/docker.list > /dev/null
		apt-get update
	fi
}

install_minikube() {
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
	sudo dpkg -i minikube_latest_amd64.deb
}

install_kubernetes() {
	curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
	sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
	# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
	echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
	sudo apt-get update
	sudo apt-get install -y kubectl

}

install_helm() {
	curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
	sudo apt-get install apt-transport-https --yes
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	sudo apt-get update
	sudo apt-get install helm
}

install_argocd_cli() {
	local VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64
}

install_from_github() {
	local user="$1"
	local project="$2"
	local filename="$3"

	local VERSION=$(curl -s "https://api.github.com/repos/$1/$2/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')
	curl -sSL -o asdf https://github.com/$1/$2/releases/download/$VERSION/$3
	sudo install -m 555 $2 /usr/local/bin/$2
	rm $2
}

packages="
jq
ripgrep
tree
make
curl
git
powertop
htop
strace
universal-ctags
cscope
gdb
manpages-dev
openvpn
rsync
cloc
qemu-system-x86
net-tools
apt-transport-https
ca-certificates
curl
gnupg
ruby
ri
"

if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
	apt-get install $packages -y
	check_installation "docker" install_docker
	check_installation "minikube" install_minikube
	check_installation "kubectl" install_kubernetes
	check_installation "helm" install_helm
	check_installation "argocd" install_argocd_cli
	install_from_github "asdf-vm" "asdf" 'asdf-$VERSION-linux-amd64.tar.gz'
	install_from_github "zellij-org" "zellij" "zellij-no-web-x86_64-unknown-linux-musl.tar.gz"

elif [ "$ID" = "fedora" ] || [ "$ID" = "centos" ]; then
	dnf install $packages
fi

if [ -z $WSL_DISTRO_NAME ]; then
	dconf load / < dconf.dump
fi

mylink "vimrc.local" /etc/vim
mylink ".bashrc" /home/*
mylink "spell/*" /usr/share/vim/vim91/spell

cd chp
make
cd ..
