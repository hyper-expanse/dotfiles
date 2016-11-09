# Update Software

echo "deb http://httpredir.debian.org/debian jessie main contrib non-free
	deb-src http://httpredir.debian.org/debian jessie main contrib non-free

	deb http://httpredir.debian.org/debian jessie-updates main contrib non-free
	deb-src http://httpredir.debian.org/debian jessie-updates main contrib non-free

	deb http://security.debian.org/ jessie/updates main contrib non-free
	deb-src http://security.debian.org/ jessie/updates main contrib non-free" > /etc/apt/sources.list

echo "Package: *
	Pin: release o=Debian,a=stable
	Pin-Priority: 700" > /etc/apt/preferences.d/stable

aptitude update

aptitude full-upgrade --assume-yes

# Additional System Packages

aptitude install apt-listbugs ntp sshfs

# SSH Configuration

echo "===========================
HyperExpanse Network Notice
===========================

Unauthorized access to this computer system is prohibited. Users have no expectation of privacy except as otherwise provided by applicable privacy laws. All activities are monitored, logged, and analyzed. Unauthorized access and activities or any criminal activity will be reported to appropriate authorities." > /etc/issue

cp /etc/issue /etc/issue.net

# Security - Kernel Configuration

echo "#########################
# Kernel Settings
#########################

# Disables the magic-sysrq key
kernel.sysrq = 0" > /etc/sysctl.d/security.conf

sudo sysctl -p /etc/sysctl.d/security.conf

# Security - Restricting Task Scheduling

echo "root" > /etc/at.allow

echo "root" > /etc/cron.allow

# Security - Password Scheme

aptitude install libpam-cracklib

# Security - Debian Vulnerability Scanner

aptitude install debsecan

# Security - Update Host SSH Keys

# TODO - Change to 16384 at some point.
yes | ssh-keygen -t rsa -b 8192 -N '' -f /etc/ssh/ssh_host_rsa_key
yes | ssh-keygen -t dsa -b 1024 -N '' -f /etc/ssh/ssh_host_dsa_key

# Personal - LinuxBrew

aptitude install build-essential curl git python-setuptools ruby --assume-yes