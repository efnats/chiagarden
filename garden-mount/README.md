# chiamount - Mass disk (un)mounter for PoST farming

This script helps you mount or unmount Chia-labelled drives based on a specified label prefix. Additionally, this repository provides two systemd service files for managing the mounting and unmounting process.
When mounting drives, the script will print all mount entries with their corresponding UUIDs in a format directly usable in `/etc/fstab` for easy copy/pasting. But please consider using the systemd services provided. This is the way.

## Requirements

- mergerfs https://github.com/trapexit/mergerfs
- have your disks labelled with a unified pattern (see chiainit)

## Usage

The script has the following command-line options:

- `--mount`: Mounts the drives with the specified label prefix
- `--unmount`: Unmounts the drives with the specified label prefix
- `--label LABEL_PREFIX`: Specifies the label prefix to use for matching drives (default: CHIA)
- `--read-only`: Mounts the drives as read-only (only applicable with `--mount`)
- `--mount-point`: Mounts the drives into thes specified mountpoint (default: /media/[username])

#### Examples

1. Mount all drives with the label prefix 'CHIA' on /media/root (if run as root):

```bash
./chiamount --mount
```

2. Mount all drives with the label prefix 'GIGA' as read-only on /mnt/16TB-drives:

```bash
./chiamount --mount --label GIGA --read-only --mount-point /mnt/16TB-drives
```

3. Unmount all drives withe label CHIA (previously mounted on any mountpoint)
```bash
./chiamount --unmount
```


## mnt-chia-drives.service

The `mnt-chia-drives.service` is a systemd service that is responsible for automatically mounting and unmounting all Chia-labelled drives on your system in /media/root/. This service ensures that your Chia-labelled drives are properly mounted when your system starts up, and unmounted when it shuts down. It relies on the /usr/local/bin/chiamount to perform the actual (un)mounting actions. You can modify the service accordingly if your drives have a different label-prefix by adding the --label [label] command (see chiamount)

### Usage

```bash
# Copy the systemd services to their directories
sudo cp mnt-chia-drives.service /etc/systemd/system/

# Reload the systemd daemon
sudo systemctl daemon-reload

# Start the mnt-garden mount
sudo systemctl start mnt-chia.drives.service

# enable the service upon next boot (if desired)
sudo systemctl enable mnt-chia.drives.service
```


## mnt-garden.mount

The `mnt-garden.mount` is a systemd service that is responsible for mounting a mergerfs volume in /mnt/garden/, which combines multiple Chia-labelled disks into a single, unified file system. The service is dependent and will automatically call mount-chia-drive.service.

This service ensures that the mergerfs volume is mounted after all Chia-labelled drives have been successfully mounted by the mnt-chia-drives.service. The mergerfs volume is created using the fuse.mergerfs file system type, with mfs (most free space) policy enabled. This makes sure that that writing to the merger filesystem will allocate as many disks as possible during plotting for better peformance. See https://github.com/trapexit/mergerfs

NOTE! It is currently not recommended to use the mergerfs mount point for farming in larger (+20 disks) environments as there are some peformance drawbacks that may result in longer seek times. The aswesome author of mergerfs is aware of the CHIA community using mergerfs and may have hints: https://www.reddit.com/r/chia/comments/o7pxpz/mergerfs_and_chia/

### Usage

```bash
# Copy the systemd services to their directories
sudo cp mergerfs.service /etc/systemd/system/mnt-garden.mount

# Reload the systemd daemon
sudo systemctl daemon-reload

# Start the mnt-garden mount
sudo systemctl start mnt-garden.mount

# enable the service upon next boot (if desired)
sudo systemctl enable mnt-garden.mount
```


