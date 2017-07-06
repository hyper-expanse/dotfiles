# Performance

## Improve boot-up Time

We make several configuration changes to limit the time applications take to restart, or boot-up, from a cold state.

### Mount Options

Below is a table of partitions (which would have been setup following our installation guide), and that can be improved, performance-wise, by setting the following mount options.

* noatime: Do not update the access time for files when they are accessed.

| Partition | noatime |
| /boot     | Yes     |

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
