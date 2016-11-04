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
