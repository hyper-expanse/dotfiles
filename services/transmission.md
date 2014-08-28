# Transmission

## Package Installation

Packages:
* transmission-daemon
* transmission-remote-cli

## Configuration

Make the following modifications to the Transmission configuration file, `/etc/transmission-daemon/settings.json`.

### Bandwidth

```
"speed-limit-down": 100,
"speed-limit-down-enabled": true,
"speed-limit-up": 100,
"speed-limit-up-enabled": true,
```

### Files and Locations

```
"download-dir": "/var/lib/transmission-daemon/downloads",
"incomplete-dir": "/var/lib/transmission-daemon/incomplete"
"incomplete-dir-enabled": true
"preallocation": 2
```

### Misc

```
"dht-enabled": true,
"encryption": 2
"lpd-enabled": true,
"pex-enabled": true,
```

### Peer Ports

```
"peer-port": 61216
"peer-port-random-on-start": false
```

### RPC

```
"rpc-authentication-required": true,
"rpc-enabled": true,
"rpc-password": "[PASSWORD]"
"rpc-port": 9091,
"rpc-username": "transmission",
"rpc-whitelist": "127.0.0.1,10.0.0.*"
"rpc-whitelist-enabled": true,
```

## Firewall Configuration

The firewall needs to be re-configured to open up the Peer Port for Transmission to allow for uploading torrents.

Execute the following command to reconfigure the firewall:

```bash
sudo dpkg --reconfigure arno-iptables-firewall
```

Update the list of open TCP ports to include the following port such that external users can leach from torrents hosted on this system:
* 61216
