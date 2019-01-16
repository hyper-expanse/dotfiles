# Networking

If using a static IP address update the contents of the `/etc/network/interfaces` file with the following:

```
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet static
	address [IP ADDRESS]
	broadcast [BROADBAST ADDRESS]
	gateway [GATEWAY IP ADDRESS]
	netmask [NETMASK]
	network [NETWORK]
```

If using a DHCP IP address update the contents of the `/etc/network/interfaces` file with the following:

```
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp
```
