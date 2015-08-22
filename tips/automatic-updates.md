# Automatic System Updates

> May not be safe as some upgrades may contain unintended breaking changes.

Packages for Debian distributions are regularly updated within the main software repositories with upgrades, and security fixes. Though these updated packages could be downloaded and installed manually, doing so would be tedious across a cluster of systems. Given that a stable version of Ubuntu is being used, all updated packages should not have adverse effects on the stability of the system. We therefore create scripts that will automatically download and install updated packages, thereby keeping the system up-to-date with the latest software in the repository.

Create a new cron job which will be executed on a daily basis by creating the `/etc/cron.daily/apt-updates` file:

[/etc/cron.daily/apt-updates](src/etc/cron.daily/apt-updates)

Execute the following command to make the file executable:

```bash
sudo chmod 755 /etc/cron.daily/apt-updates
```

Set the proper owner, and group, for the file:

```bash
sudo chown root:root /etc/cron.daily/apt-updates
```

Create a new log rule for rotating and compressing log files associated with the automatic updates file by creating the	`/etc/logrotate.d/apt-updates` file:

[/etc/logrotate.d/apt-updates](src/etc/logrotate.d/apt-updates)

Eecute the following command to set the proper permissions:

```bash
sudo chmod 644 /etc/logrotate.d/apt-update
```

Set the proper owner, and group, for the file:

```bash
sudo chown root:root /etc/logrotate.d/apt-updates
```

