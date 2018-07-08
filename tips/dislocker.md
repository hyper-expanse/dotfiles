# Dislocker

> `dislocker` is a tool for decrypting Windows bitlocker-encrypted volumes using a Linux system.

* A helpful guide to using `dislocker` - http://theevilbit.blogspot.com/2014/04/using-dislocker-to-mount-bitlocker.html
* The GitHub repository - https://github.com/Aorimn/dislocker

Using `dislocker` will require the following packages to be installed on Debian:
- libfuse-dev
- libpolarssl-dev

Next step is to create a fuse-endpoint, `/mnt/tmp/dislocker-file`, that will access the disk, `/dev/sdb1`, through `dislocker`, thereby dynamically descrypting the content on request.

```bash
sudo dislocker-fuse -v -V /dev/sdb1 -[ENCRYPTION KEY] -- /mnt/tmp
```

Next, mount the fuse file so that it can be accessed like any normal directory.

```bash
sudo mount -o loop,ro /mnt/tmp/dislocker-file /mnt/dis
```

When done, unmount the mounted drive.

```
sudo umount /mnt/dis
```

Lastly, kill the `dislocker` process that is running in the background.

```bash
sudo ps xjf | grep dislocker
sudo kill [PID]
```
