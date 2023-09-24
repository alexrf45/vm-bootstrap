#!/bin/sh

# The reference version of this script is maintained in
# ./live-build-config/kali-config/common/includes.installer/kali-finish-install
#
# It is used in multiple places to finish configuring the target system
# and build.sh copies it where required (in the simple-cdd configuration
# and in the live-build configuration).

configure_sources_list() {
	if grep -q '^deb http' /etc/apt/sources.list; then
		echo "INFO: sources.list is configured, everything is fine"
		return
	fi

	echo "INFO: sources.list is empty, setting up a default one for Kali"

	cat >/etc/apt/sources.list <<END
# See https://www.kali.org/docs/general-use/kali-linux-sources-list-repositories/
deb http://http.kali.org/kali kali-rolling main contrib non-free

# Additional line for source packages
# deb-src http://http.kali.org/kali kali-rolling main contrib non-free
END
	apt-get update
}

get_user_list() {
	for user in $(cd /home && ls); do
		if ! getent passwd "$user" >/dev/null; then
			echo "WARNING: user '$user' is invalid but /home/$user exists"
			continue
		fi
		echo "$user"
	done
	echo "root"
}

configure_zsh() {
	if grep -q 'nozsh' /proc/cmdline; then
		echo "INFO: user opted out of zsh by default"
		return
	fi
	if [ ! -x /usr/bin/zsh ]; then
		echo "INFO: /usr/bin/zsh is not available"
		return
	fi
	for user in $(get_user_list); do
		echo "INFO: changing default shell of user '$user' to zsh"
		chsh --shell /usr/bin/zsh $user
	done
}

# This is generically named in case we want to add other groups in the future.
configure_usergroups() {
	# Create the wireshark group if needed
	addgroup --system wireshark || true

	# adm - read access to log files
	# wireshark - capture sessions in wireshark
	kali_groups="adm,wireshark"

	for user in $(get_user_list); do
		echo "INFO: adding user '$user' to groups '$kali_groups'"
		usermod -a -G "$kali_groups" $user || true
	done
}

configure_sources_list
configure_zsh
configure_usergroups

##################################
# Custom post-installation steps #
##################################

configure_swapfile() {
	dd if=/dev/zero of=/swapfile bs=2G count=1
	chmod 600 /swapfile
	mkswap /swapfile
	printf "/swapfile none swap sw 0 0\n" >>/etc/fstab
}

configure_swapfile

packages_install() {
	apt-get install -y docker.io curl tmux tmuxp pass \
		flameshot feh i3 i3blocks i3status i3lock-fancy \
		jq terminator zsh nano remmina rsync lxappearance fonts-noto-mono fonts-noto-color-emoji \
		cowsay btop curl fzf rofi rng-tools-debian xpdf papirus-icon-theme \
		imagemagick libxcb-shape0-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
		xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev \
		libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev \
		libxcb-xrm0 libxcb-xrm-dev autoconf meson libxcb-render-util0-dev libxcb-shape0-dev libxcb-xfixes0-dev

}

base() {
	apt-get install -y python3-pip python3-virtualenv libpcap-dev \
		djvulibre-bin
}

network() {
	apt-get install -y netcat-traditional socat rlwrap nmap \
		netdiscover masscan dnsutils onesixtyone braa tcpdump \
		ftp telnet swaks snmpcheck snmpcheck snmp-mibs-downloader \
		iputils-ping iproute2 proxychains sendmail
}

active_directory_1() {
	apt-get install -y \
		smbclient smbmap evil-winrm bloodhound responder \
		powershell ldap-utils
}
web() {
	sudo apt-get install -y whatweb ffuf sqlmap \
		exiftool default-mysql-client hurl postgresql arjun \
		burpsuite
}

password() {
	sudo apt-get install -y seclists crunch john
}


mkdir -p /home/kali/tools

mkdir -p /home/kali/.local

httpx_install() {
	wget -q https://github.com/projectdiscovery/httpx/releases/download/v1.3.4/httpx_1.3.4_linux_amd64.zip &&
		unzip httpx_1.3.4_linux_amd64.zip -d ./httpx &&
		rm httpx_1.3.4_linux_amd64.zip &&
		mv httpx/httpx /home/kali/.local/http-x &&
		rm -r httpx/

}

payload() {
	cd /home/kali/tools/ &&
		wget -q -O nc.exe \
			"https://github.com/ShutdownRepo/Exegol-resources/raw/main/windows/nc.exe" &&
		wget -q -O nc \
			"https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/ncat"
}

active_directory_2() {
	cd /home/kali/tools/ &&
		wget -q -O rubeus.exe \
			"https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Rubeus.exe" &&
		wget -q -O certify.exe \
			"https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Certify.exe" &&
		wget -q -O cme.zip \
			"https://github.com/Porchetta-Industries/CrackMapExec/releases/download/v5.4.0/cme-ubuntu-latest-3.11.zip" &&
		unzip cme.zip && chmod +x cme && sudo mv cme /home/$USER/.local/cme && rm cme.zip &&
		wget "https://github.com/fortra/impacket/releases/download/impacket_0_11_0/impacket-0.11.0.tar.gz" &&
		gunzip impacket-0.11.0.tar.gz && tar -xvf impacket-0.11.0.tar &&
		mv impacket-0.11.0/ /home/$USER/.local/ && rm impacket-0.11.0.tar &&
		wget -q -O sharp.ps1 \
			"https://github.com/BloodHoundAD/BloodHound/raw/master/Collectors/SharpHound.ps1" &&
		wget -q -O SharpHound.exe \
			"https://raw.githubusercontent.com/BloodHoundAD/BloodHound/master/Collectors/SharpHound.exe"
}

pivot() {
	cd /home/kali/tools/ &&
		wget -q -O chisel.gz \
			"https://github.com/jpillora/chisel/releases/download/v1.8.1/chisel_1.8.1_linux_amd64.gz" &&
		gunzip chisel.gz &&
		wget -q -O win-chisel.gz \
			"https://github.com/jpillora/chisel/releases/download/v1.8.1/chisel_1.8.1_windows_amd64.gz" &&
		gunzip win-chisel.gz
}

privesc() {
	cd /home/kali/tools/ &&
		wget -q -O linpeas.sh \
			"https://github.com/carlospolop/PEASS-ng/releases/download/20230813-dc8384b3/linpeas_linux_amd64" &&
		wget -q -O winpeas.exe \
			"https://github.com/carlospolop/PEASS-ng/releases/download/20230813-dc8384b3/winPEASany.exe" &&
		wget -q -O pspy \
			"https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64s"
}

packages_install
base
network
active_directory_1
active_directory_2
web
password
privesc
pivot
payload

httprobe_install() {
	wget -q https://github.com/tomnomnom/httprobe/releases/download/v0.2/httprobe-linux-amd64-0.2.tgz -O httprobe.tgz &&
		tar -xzf httprobe.tgz && chmod +x httprobe && mv httprobe /home/kali/.local/httprobe && rm httprobe.tgz
}

go-dorks_install() {
	wget -q https://github.com/dwisiswant0/go-dork/releases/download/v1.0.2/go-dork_1.0.2_linux_amd64 -O go-dork &&
		mv go-dork /home/kali/.local/go-dork &&
		chmod +x /home/kali/.local/go-dork
}

rush_install() {
	wget https://github.com/shenwei356/rush/releases/download/v0.5.2/rush_linux_amd64.tar.gz -O rush.tar.gz &&
		gunzip rush.tar.gz && tar -xf rush.tar && rm rush.tar && mv rush home/kali/.local/rush && chmod +x /home/kali/.local/rush
}

katana_install() {
	wget https://github.com/projectdiscovery/katana/releases/download/v1.0.3/katana_1.0.3_linux_amd64.zip -O katana.zip &&
		unzip katana.zip && chmod +x katana && mv katana /home/kali/.local/. && rm katana.zip
}

chaos_install() {
	wget https://github.com/projectdiscovery/chaos-client/releases/download/v0.5.1/chaos-client_0.5.1_linux_amd64.zip \
		-O chaos.zip && unzip chaos.zip chaos-client && chmod +x chaos-client && mv chaos-client /home/kali/.local/chaos &&
		rm chaos.zip
}

dnsx_install() {
	wget https://github.com/projectdiscovery/dnsx/releases/download/v1.1.4/dnsx_1.1.4_linux_amd64.zip -O dnsx.zip &&
		unzip dnsx.zip dnsx && chmod +x dnsx && mv dnsx /home/kali/.local/dnsx && rm dnsx.zip
}

waybackurls_install() {
	wget -q -O waybackurls.tgz https://github.com/tomnomnom/waybackurls/releases/download/v0.1.0/waybackurls-linux-amd64-0.1.0.tgz &&
		gunzip waybackurls.tgz &&
		tar -C /home/kali/.local -xf waybackurls.tar &&
		chmod +x /home/kali/.local/waybackurls &&
		rm /home/kali/waybackurls.tar
}

unfurl_install() {
	wget https://github.com/tomnomnom/unfurl/releases/download/v0.4.3/unfurl-linux-amd64-0.4.3.tgz \
		-O unfurl.tgz && tar -xzf unfurl.tgz && mv unfurl /home/kali/.local/unfurl && rm unfurl.tgz
}

subfinder_install() {
	wget https://github.com/projectdiscovery/subfinder/releases/download/v2.6.2/subfinder_2.6.2_linux_amd64.zip \
		-O subfinder.zip && unzip subfinder.zip && chmod +x subfinder && mv subfinder /home/kali/.local/subfinder && rm subfinder.zip
}

notify_install() {
	wget https://github.com/projectdiscovery/notify/releases/download/v1.0.5/notify_1.0.5_linux_amd64.zip \
		-O notify.zip && unzip -o notify && mv notify /home/kali/.local/notify && rm notify.zip && rm LICENSE.md README.md
}

apt-get install amass -y

httprobe_install
go-dorks_install
rush_install
katana_install
chaos_install
dnsx_install
waybackurls_install
unfurl_install
subfinder_install
notify_install

