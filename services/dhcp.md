# DHCP

DHCP server allows for the automatic configuration of network interfaces on physical and virtual systems. In addition, a DHCP server can be used to manage the hostname and domain names across an entire network infrastructure.

## Package Installation

Packages:
* isc-dhcp-server: This is the server from the Internet Software Consortium's implementation of DHCP. For more information, visit http://www.isc.org.

## Configure Firewall

DHCP servers operate over UDP port 67. Because of the default configuration of the firewall, it must be updated to allow port 67 through.

Begin the re-configuration process:

```bash
sudo dpkg-reconfigure arno-iptables-firewall
```

An interactive configuration screen will appear to configure the firewall settings. Keep all settings to their default except for the following:
* Add port 67 to the list of open UDP-ports on external network interfaces.

## Manageable Interfaces

The DHCP server must be instructed as to what network interfaces it will provide, and manage, IP leases.

Edit the `/etc/default/isc-dhcp-server` and add the interfaces on which the DHCP server will serve IP leases. Interfaces given in the order below will correspond with subnet descriptions in the `/etc/dhcp/dhcpd.conf` file, in sequential order.

```
INTERFACES="eth0 eth1"
```

## Network Descriptions

Most important to the DHCP server is the description of the networks that are to be served and the IP address information.

Edit the `/etc/dhcp/dhcpd.conf` file:
* Uncomment `authoritative;` so that the DHCP server will serve IP leases as the sole authority on that particular network.

Follow this pattern to create network descriptions:
* Create a subnet for each network that will be managed by the DHCP server.
* Replace `[SUBNET]` with the lowest IP address that could be assigned in the network.
* Replace `[NETMASK]` with the netmask for this network, i.e., for a 192.168.1.X network, the netmask would be 255.255.255.0.
* Replace `[DNS SERVER, ...]` with a list of IP addresses for DNS servers.
* Replace `[NTP SERVER, ...]` with a list of IP addresses or domain names for NTP servers.
* Replace `[DOMAIN NAME]` with the domain name for the network.
* Replace `[BROADCAST ADDRESS]` with the IP address allocated on the network for broadcast packets.
* Replace `[TIME]` with the offset of the client's subnet in seconds from Coordinated Universal Time (UTC).
* Replace `[DEFAULT LEASE TIME]` with the amount, in seconds, that the server will lease an IP address when not requested for a particular lease time by the client.
* Replace `[MAX LEASE TIME]` with the maximum amount of time, in seconds, a lease will be allowed upon request from a client regardless if the client asks for more time than this.
* Replace `[START IP]` and `[END IP]` with the start and end IP addresses of the IP range that will be dynamically allocated to systems on demand.
* Replace `[GATEWAY]` with the IP address of the gateway server.

```
subnet [SUBNET] netmask [NETMASK]
{
	option domain-name-servers [DNS SERVER, ...];
	option ntp-servers [NTP SERVER, ...];
	option domain-name "[DOMAIN NAME]";
	option broadcast-address [BROADCAST ADDRESS];
	option fqdn.no-client-update true;
	option subnet-mask [NETMASK];
	option fqdn.server-update true;
	option ip-forwarding false;
	option time-offset [TIME];

	pool
	{
		default-lease-time [DEFAULT LEASE TIME];
		max-lease-time [MAX LEASE TIME];
		range [START IP] [END IP];
		option routers [GATEWAY];
	}

	group
	{
	}
}
```

When defining groups, you can segment your network into logical groups that are assigned withi different configuration options. In addition, it's probably best practices to define hosts within groups. Hosts define the IP address that will be permanently assigned to a network interface, along with other settings that might be specific to that system. Add the following configuration options inside the group code block given above.

* Replace `[DEFAULT LEASE TIME]` with the amount, in seconds, that the server will lease an IP address to systems within the group when not requested for a particular lease time by the client.
* Replace `[MAX LEASE TIME]` with the maximum amount of time, in seconds, a lease will be allowed upon request from another system within the group regardless if the client asks for more time than this.

```
default-lease-time [DEFAULT LEASE TIME];
max-lease-time [MAX LEASE TIME];
```

* Again, this is for best practice when defining the configuration for a particular host.
* Replace `[HOSTNAME]` with a uniquely identifiable name for the system.
* Replace `[NETWORK INTERFACE]` with the name of the network interface that will be configured. It is not required to follow this naming scheme, but it makes it easier to understand.
* Replace `[MAC ADDRESS]` with the MAC address of the network interface.
* Replace `[IP]` with the IP that will be fixed to this network interface.
* Replace `[GATEWAY]` with the IP address of the gateway server.
* Replace `[HOSTNAME]` with the hostname for that system on which the network interface
belongs.

```
host [HOSTNAME].[NETWORK INTERFACE]
{
	hardware ethernet [MAC ADDRESS];
	fixed-address [IP];
	option routers [GATEWAY];
	option host-name "[HOSTNAME]";
}
```
