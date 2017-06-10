# To force `debconf` (which is used by things such as `dpkg-preconfigure`) not to use an interactive prompt.
export DEBIAN_FRONTEND=noninteractive

# Update Software

echo "
deb http://httpredir.debian.org/debian jessie main contrib non-free
deb-src http://httpredir.debian.org/debian jessie main contrib non-free

deb http://httpredir.debian.org/debian jessie-updates main contrib non-free
deb-src http://httpredir.debian.org/debian jessie-updates main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free

deb http://httpredir.debian.org/debian unstable main contrib non-free
deb-src http://httpredir.debian.org/debian unstable main contrib non-free
" > /etc/apt/sources.list

echo "
Package: *
Pin: release o=Debian,a=stable
Pin-Priority: 700
" > /etc/apt/preferences.d/stable

aptitude update

aptitude full-upgrade --assume-yes

# Automatic Updates

echo "
#!/usr/bin/env bash

# Capture our start time.
start=$(date +%s)

# Set the date for UTC date.
utcdate=$(date -u --rfc-3339=seconds)

# Location of the output log file.
log=/var/log/aptitude-updates

# Begin executing commands.
echo "*******************************************" >> $log
echo "[Aptitude Updates]: $utcdate Z" >> $log
echo "*******************************************" >> $log

# Update our list of repository packages
aptitude update >> $log

# Install all package updates where the update does not require the removal of another package. Assume yes where applicable (--assume-yes) and do not install recommended packages but only those that are required (--no-install-recommends).
aptitude safe-upgrade --assume-yes --without-recommends >> $log

# Clean up cache files. Assume yes where applicable (--assume-yes).
aptitude clean --assume-yes >> $log

# Calculate and log total execution time.
end=$(date +%s)
difference=$(($end - $start))

echo >> $log
echo "Execution time: $difference seconds." >> $log
echo >> $log
" > /etc/cron.daily/aptitude-updates

chmod 755 /etc/cron.daily/aptitude-updates

echo "
/var/log/aptitude-updates {
	rotate 2
	weekly
	size 250k
	compress
	notifempty
}
" > /etc/logrotate.d/aptitude-updates

chmod 644 /etc/logrotate.d/aptitude-update

chown root:root /etc/cron.daily/aptitude-updates
chown root:root /etc/cron.daily/aptitude-updates

# Additional System Packages

aptitude install apt-listbugs ntp --assume-yes

# Firewall

echo "
#######################################################################
# Feel free to edit this file.  However, be aware that debconf writes #
# to (and reads from) this file too.  In case of doubt, only use      #
# 'dpkg-reconfigure -plow arno-iptables-firewall' to edit this file.  #
# If you really don't want to use debconf, or if you have specific    #
# needs, you're likely better off using placing an additional         #
# configuration snippet into/etc/arno-iptables-firewall/conf.d/.      #
# Also see README.Debian.                                             #
#######################################################################

# External network interfaces (such as those connected to the internet).
EXT_IF="eth0"

# Set to '1' is external IP is retrieved from DHCP.
EXT_IF_DHCP_IP=1

# TCP ports to allow through external network interfaces.
OPEN_TCP=""

# UDP ports to allow through external network interfaces.
OPEN_UDP=""

# Internal network interfaces.
INT_IF=""

# Configuration for routing internal traffic from other systems, through this system's external network interfaces, and to the public internet.
NAT=0
INTERNAL_NET=""
NAT_INTERNAL_NET=""

# Set to '1' if the system should respond to PING messages on external network interfaces.
OPEN_ICMP=0
" > /etc/arno-iptables-firewall/conf.d/00debconf.conf

aptitude install arno-iptables-firewall

sed -i "s/ENABLED=0/ENABLED=1/" /etc/arno-iptables-firewall/plugins/ssh-brute-force-protection.conf

/etc/init.d/arno-iptables-firewall restart

# SSH Configuration

sed -i "s/PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config

sed -i "s/#\(Banner.*\)/\1/" /etc/ssh/sshd_config

/etc/init.d/ssh restart

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

aptitude install libpam-cracklib --assume-yes

# Security - Debian Vulnerability Scanner

aptitude install debsecan --assume-yes

# Security - Update Host SSH Keys

# TODO - Change to 16384 at some point.
yes | ssh-keygen -t rsa -b 8192 -N '' -f /etc/ssh/ssh_host_rsa_key
yes | ssh-keygen -t dsa -b 1024 -N '' -f /etc/ssh/ssh_host_dsa_key

# Personal - Jessie Backports Repository

echo "
deb http://httpredir.debian.org/debian jessie-backports main contrib non-free
deb-src http://httpredir.debian.org/debian jessie-backports main contrib non-free
" > /etc/apt/sources.list.d/jessie-backports.list

aptitude update

# Personal - Setting Up Intel Graphics

echo "
Package: xserver-xorg-video-intel
Pin: release o=Debian,a=jessie-backports
Pin-Priority: 600
" > /etc/apt/preferences.d/xorg

aptitude install -t jessie-backports xserver-xorg-video-intel

aptitude install mesa-utils

# Personal - LinuxBrew

aptitude install build-essential curl git python-setuptools ruby --assume-yes
