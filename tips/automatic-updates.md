# Automatic System Updates

> May not be safe as some upgrades may contain unintended breaking changes.

Packages for Debian distributions are regularly updated within the main software repositories with upgrades, and security fixes. Though these updated packages could be downloaded and installed manually, doing so would be tedious across a cluster of systems. If a stable version of Debian is used any outstanding package updates should be safe to install without adverse effects on the stability of the system.

Therefore a set of scripts can be added to a system to automatically download and install package updates, keeping the system up-to-date with the latest software in the repository.

Create a new cron job which will be executed on a daily basis by creating the `/etc/cron.daily/aptitude-updates` file:

[/etc/cron.daily/aptitude-updates](src/etc/cron.daily/aptitude-updates)

Execute the following command to make the file executable:

```bash
sudo chmod 554 /etc/cron.daily/aptitude-updates
```

Set the proper owner, and group, for the file:

```bash
sudo chown root:root /etc/cron.daily/aptitude-updates
```

Create a new log rule for rotating and compressing log files associated with the automatic updates file by creating the	`/etc/logrotate.d/aptitude-updates` file:

[/etc/logrotate.d/aptitude-updates](src/etc/logrotate.d/aptitude-updates)

Eecute the following command to set the proper permissions:

```bash
sudo chmod 444 /etc/logrotate.d/apt-update
```

Set the proper owner, and group, for the file:

```bash
sudo chown root:root /etc/logrotate.d/aptitude-updates
```
