# Performance

## Disable Services

Debian is installed with several services operating in the background to handle networking, among other things. To disable a service run the following command:

```bash
sudo update-rc.d -f [NAME] disable
```

Using that command disable the following services (Services I don't personally use, but you may wish to keep enabled if your workflow requires them):

* bluetooth

## Improve boot-up Time

We make several configuration changes to limit the time applications take to restart, or boot-up, from a cold state.

### Mount Options

Below is a table of partitions (which would have been setup following our installation guide), and which mount options should be enabled for those mounted file systems.

* noatime: Do not update the access time for files when they are accessed.

| Partition | noatime |
| /boot     | Yes     |

### Exim

First, the e-mail server/client used by the system for sending system messages needs to be reconfigured to eliminate its costly DNS lookups conducted at boot time.

* Type `sudo dpkg-reconfigure exim4-config` and press _Enter_.
* Answer all other questions using the defaults except for the question regarding _Dial-on-Demand_. Answer _Yes_ for that option.

### Grub

The default boot loader, Grub, shows a boot menu where one of several Linux kernels may be selected for booting up the system. However, this menu imposes a five second delay before automatically choosing the pre-configured default kernel. We can reduce this delay under the assumption that the user will rarely, if ever, choose a different option than the default.

Edit Grub's configuration file:

```bash
sudo nano /etc/default/grub
```

Edit the line that says:

```
GRUB_TIMEOUT=5
```

To say:

```
GRUB_TIMEOUT=2
```

Lastly, execute the following to re-build the Grub menu:

```bash
sudo update-grub2
```
