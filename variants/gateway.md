# Gateway

## SSH Configuration

The default SSH configuration is not sufficient for protecting a network's gateway server from network intrusion. To improve security and mitigate the vulnerability of that server we make modifications to the configuration settingso of the SSH service.

First, we disable password-based authentication, thereby forcing logins to use SSH keys. This prevents brute-force attaches against a password-based authentication system.

Edit the SSH configuration file, /etc/ssh/sshd\_config, and modify the following line:

* Change:

```
#PasswordAuthentication yes
```

* To:

```
PasswordAuthentication no
```

## Crontab

Setup `crontab` with an initial, single, entry via `crontab -e`:

```
@reboot tmux new-session -d -s monitor
```

## WeeChat

### Package Installation

Packages:
* aspell-en: Require for the aspell spell checking plugin.
* weechat-curses
* weechat-plugins
* weechat-scripts

### Initial Scripts

Download the following script to ~/.weechat/perl:

```
http://weechat.org/files/scripts/script.pl
```

Download the following script to ~/.weechat/python:

```
http://weechat.org/files/scripts/weeget.py
```

### Configuration

For managing IRC connections, set the following within the ~/.weechat/irc.conf configuration file:

```
[server_default]
default_msg_part = ``%v''
default_msg_quit = ``%v''
sasl_mechanism = dh-aes
ssl = on
ssl_dhkey_size = 4096

[server]
freenode.addresses = ``chat.freenode.net/6697''
freenode.autoconnect = on
freenode.autoreconnect = on
freenode.autorejoin = on
freenode.autojoin = ``#libcloud,#nasa''
freenode.nicks = ``hbetts''
freenode.realname = ``Hutson Betts''
freenode.sasl\_username = ''[ACCOUNT USERNAME]``
freenode.sasl\_password= ''[ACCOUNT PASSWORD]``
```

Configure the aspell plugin, ~/.weechat/aspell.conf:

```
[check]
default\_dict = ``en''
during\_search = off
enabled = on
real\_time = on
```

Next, we need to modify our crontab file, the configuration file required by crontab to schedule periodic jobs. Open the crontab configuration file:

```bash
crontab -e
```

Add the following line to the bottom of the crontab configuration file:

```
@reboot tmux new-window -d -s monitor -n weechat 'weechat-curses'
```

### Loading Scripts

Once WeeChat is running we need to load the scripts that were initially downloaded.

Run the following commands from the WeeChat command line:

```
/perl load script.pl
/python load weeget.py
```

Next we need to configure these scripts to autoload:

```
/script autoload script
/script autoload weeget
```

Lastly, we can start installing additional useful scripts:

```
/weeget install buffers.pl
/weeget install screen_away.pl
```

## Network Monitoring

### BMon

Install the `bmon` network monitoring tool:

```bash
sudo apt-get install bmon --no-install-recommends
```

Add the following line into the	`crontab` file via `crontab -e`:

```
@reboot tmux new-window -d -t monitor -n bmon 'bmon'
```

### NetHogs

Install the `nethogs` network monitoring tool:

```bash
sudo apt-get install nethogs --no-install-recommends
```

### TCPTrack

Install the `tcptrack` network monitoring tool:

```bash
sudo apt-get install tcptrack --no-install-recommends
```

### VNStat

Install the `vnstat` network monitoring tool:

```bash
sudo apt-get install vnstat --no-install-recommends
```

Use vnstat to create a database for recording information about the network interface connectioned to the Internet:

```bash
sudo vnstat -u -i etho
```

Once the database has been created we can start vnstat as a background deamon that will monitor the network interface:

```bash
sudo /etc/init.d/vnstat start
```

Lastly we need to change the permissions of the database so that it is readable by everyone on the system so that they can use the client utility, vnstat:

```bash
sudo chmod o+r /var/lib/vnstat/eth0
```

To run `vnstat` it can either be run once to display detailed stats, `vnstat`, or live stats, `vnstat --live`.
