#!/bin/bash

if [[ "$EUID" -eq 0 ]]; then
	echo "Please run this script as a regular user, not as root."
	exit 1
fi

# Keep the sudo session alive while the script is running.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	cd "$HOME/dotfiles" || { echo "ERROR: Could not find ~/dotfiles directory. Aborting." >&2; exit 1; }

	. /etc/os-release
	echo "Running on OS: $ID"

	user=$(who | awk 'NR==1{print $1}')
	user_home=/home/$user

	if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
		sudo apt-get update >/dev/null
	elif [ "$ID" = "fedora" ] || [ "$ID" = "centos" ]; then
		sudo dnf update >/dev/null
	fi

# $1: program name $2: installation function
check_installation() {
	if command -v "$1" &> /dev/null
	then
		echo "INFO: $1 is already installed" >&2
		return
	else
		$2
	fi
}

to_install=""

install_docker() {
	echo "INFO: installing docker"
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/$ID/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$ID \
		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	to_install="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin $to_install"
}

install_minikube() {
	echo "INFO: installing minikube"
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
	sudo dpkg -i minikube_latest_amd64.deb
}

install_kubernetes() {
	echo "INFO: installing kubectl"
	curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
	sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
	# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
	echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
	to_install="kubectl $to_install"
}

install_helm() {
	echo "INFO: installing helm"
	curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
	echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	to_install="helm $to_install"
}

install_argocd_cli() {
	echo "INFO: installing argocd"
	local VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64
}

apply_apt_installations() {
	echo "Applying installations: $to_install"
	sudo apt-get update > /dev/null
	sudo apt-get install -y $to_install
}

# $1 user $2 project
install_from_github() {
	echo "INFO: Installing $2"

	local VERSION=$(curl -s "https://api.github.com/repos/$1/$2/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')
	eval filename=$filename
	echo "    INFO: Extracting file: $filename"
	curl -SL -o /tmp/$2.gz https://github.com/$1/$2/releases/download/$VERSION/$filename
	sudo tar -xf /tmp/$2.gz -C /usr/local/bin/ --overwrite
	rm /tmp/$2.gz
}


# $1 ssh link
git_clone() {
	echo "INFO: Attempting to clone from $1..."
	git clone $1 2> /dev/null
}

fetch_open_sources() {
	mkdir -p ~/open-sources
	cd ~/open-sources
	git_clone git@github.com:elixir-lang/elixir.git
	cd - > /dev/null
}

setup_git_updater() {
	echo "INFO: setting up automated commits on shutdown"
	local TARGET_USER=$SUDO_USER
	local DOTFILES_PATH=$(realpath .)
	local SCRIPT_PATH=/usr/local/bin/git-on-shutdown.sh 
	local SERVICE_PATH=/etc/systemd/system/git-on-shutdown.service
	cat <<EOF | sudo tee ${SCRIPT_PATH} > /dev/null
#!/bin/bash
set -e
cd "${DOTFILES_PATH}"

BRANCH_NAME=\$(hostname)
echo "INFO: checking out branch"
/usr/bin/git checkout "\${BRANCH_NAME}" || /usr/bin/git checkout -b "\${BRANCH_NAME}"

echo "INFO: staging changes"
/usr/bin/git add .

# Only commit if there are actual changes staged.
if ! /usr/bin/git diff-index --quiet HEAD; then
echo "INFO: changes detected, commiting"
/usr/bin/git commit -m "automated: sync dotfiles files for \${BRANCH_NAME}"
echo "INFO: pushing changes"
timeout 20 git push --set-upstream origin "\${BRANCH_NAME}"
fi
EOF

	cat <<EOF | sudo tee ${SERVICE_PATH} > /dev/null
[Unit]
Description=Commit specified git repository on shutdown.
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
User=1000
Group=1000
ExecStart=${SCRIPT_PATH}

[Install]
WantedBy=shutdown.target
EOF

	sudo chmod +x ${SCRIPT_PATH}
	sudo systemctl daemon-reload
	sudo systemctl enable "${SERVICE_PATH}"
}

packages="
vim-gtk3
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
	sudo apt-get install $packages -y
	check_installation "docker" install_docker
	check_installation "minikube" install_minikube
	check_installation "kubectl" install_kubernetes
	check_installation "helm" install_helm
	check_installation "argocd" install_argocd_cli
	apply_apt_installations
	check_installation install_from_github "asdf-vm" "asdf" 'asdf-$VERSION-linux-amd64.tar.gz'
	check_installation install_from_github "zellij-org" "zellij" "zellij-no-web-x86_64-unknown-linux-musl.tar.gz"
	fetch_open_sources
	setup_git_updater
elif [ "$ID" = "fedora" ] || [ "$ID" = "centos" ]; then
	sudo dnf install -y $packages
fi

# if [ -z $WSL_DISTRO_NAME ]; then
# 	dconf load / < dconf.dump
# fi

# $1 /path/to/dotfile $2 /path/to/target
link_files() {
	echo "INFO: linking \"$1\""
	sudo ln -sf "$1" "$2"
}

link_files "$HOME/dotfiles/vimrc.local" "/etc/vim/vimrc.local"
link_files "$HOME/dotfiles/vimrc" "$HOME/.vimrc"
link_files "$HOME/dotfiles/bashrc" "$HOME/.bashrc"
for dir in /usr/share/vim/vim9* ; do
	for file in $HOME/dotfiles/spell/* ; do
		link_files $file "$dir/spell/"
	done
done

cd chp
make
cd .. 
sudo apt-get autoremove -y >/dev/null
