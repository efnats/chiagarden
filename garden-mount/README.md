# chiamount - Mass disk (un)mounter for PoST farming

This script helps you mount or unmount Chia-labelled drives based on a specified label prefix. Additionally, this repository provides two systemd service files for managing the mounting and unmounting process.
When mounting drives, the script will print all mount entries with their corresponding UUIDs in a format directly usable in `/etc/fstab` for easy copy/pasting. But please consider using the systemd services provided. This is the way.

## Requirements

- mergerfs https://github.com/trapexit/mergerfs (only for mounting all disks in a single-drive-like filesystem, not required for mounting the disks)
- have your disks labelled with a unified pattern (see chiainit)

## Usage

The script has the following command-line options:

- `--mount`: Mounts the drives with the specified label prefix
- `--unmount`: Unmounts the drives with the specified label prefix
- `--label LABEL_PREFIX`: Specifies the label prefix to use for matching drives (default: CHIA)
- `--read-only`: Mounts the drives as read-only (only applicable with `--mount`)
- `--mount-point [PATH]`: Mounts the drives into thes specified mountpoint (default: /media/[username])
- `--mergerfs [PATH]`: Use MergerFS to combine the mounted devices into a single drive-like filesystem. (default: /mnt/garden)

#### Examples

1. Mount all drives with the label prefix 'CHIA' on /media/root (if run as root):

```bash
./chiamount --mount
```

2. Mount all drives with the label prefix 'GIGA' as read-only on /mnt/16TB-drives:

```bash
./chiamount --mount --label GIGA --read-only --mount-point /mnt/16TB-drives
```

3. Mount all drives with the label prefix 'CHIA' in /meda/root and mount these disks in a single-drive-like filesystem in /mnt/garden using MergerFS:

```bash
./chiamount --mount --mergerfs
```

4. Unmount all drives withe label CHIA (previously mounted on any mountpoint)
```bash
./chiamount --unmount
```

# garden-mount systemd services

The `chiamount` command will output all required fstab entry lines for your CHIA disks and for combining all disks into a Union Filesystem in MergerFS. To make all your mount points persisent you can simply copy this output and paste it into your /etc/fstab. HOWEVER, if you are running a linux distribution that supports `systemd` like Debian or Ubuntu, you may consider using the provided systemd service files instead. Those will enable you to finetune your dependencies. For example you may want to make sure that your mounts are set before your docker.service is run. If you decide to use systemd you probably know how to modify these according to your needs.

## mnt-chia-drives.service

The `mnt-chia-drives.service` is a systemd service that is responsible for automatically mounting and unmounting all Chia-labelled drives on your system in /media/root/. This service ensures that your Chia-labelled drives are properly mounted when your system starts up, and unmounted when it shuts down. It relies on the /usr/local/bin/chiamount to perform the actual (un)mounting actions. You can modify the service accordingly if your drives have a different label-prefix by adding the --label [label] command (see chiamount)

### Usage

Copy the systemd services to their directories and start/enable the service
```bash
sudo cp mnt-chia-drives.service /etc/systemd/system/
sudo cp chiamount /usr/local/bin/
sudo systemctl daemon-reload
sudo systemctl start mnt-chia.drives.service
sudo systemctl enable mnt-chia.drives.service
```


## mnt-garden.mount

The `mnt-garden.mount` is a systemd service that is responsible for mounting a mergerfs volume in /mnt/garden/, which combines multiple Chia-labelled disks into a single, unified file system. The service is dependent and will automatically call mount-chia-drive.service.

This service ensures that the mergerfs volume is mounted after all Chia-labelled drives have been successfully mounted by the mnt-chia-drives.service. The mergerfs volume is created using the fuse.mergerfs file system type, with mfs (most free space) policy enabled. This makes sure that that writing to the merger filesystem will allocate as many disks as possible during plotting for better peformance. See https://github.com/trapexit/mergerfs

NOTE! It is currently not recommended to use the mergerfs mount point for *farming* in larger (+20 disks) environments as there are some peformance drawbacks that may result in longer seek times. Using it for managing your plots like copying plots and organizing (sub)folders on multiple disks is fantastic. The aswesome author of mergerfs is aware of the CHIA community using mergerfs and may have hints: https://www.reddit.com/r/chia/comments/o7pxpz/mergerfs_and_chia/

### Usage

Copy the systemd services to their directories and start/enable the service
```bash
sudo mkdir -p /mnt/garden
sudo cp mergerfs.service /etc/systemd/system/mnt-garden.mount
sudo systemctl daemon-reload
sudo systemctl start mnt-garden.mount
sudo systemctl enable mnt-garden.mount
```


