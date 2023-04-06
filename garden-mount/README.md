# gardenmount - Mass disk (un)mounter for PoST farming

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
./gardenmount --mount
```

2. Mount all drives with the label prefix 'GIGA' as read-only on /mnt/16TB-drives:

```bash
./gardenmount --mount --label GIGA --read-only --mount-point /mnt/16TB-drives
```

3. Mount all drives with the label prefix 'CHIA' in /meda/root and mount these disks in a single-drive-like filesystem in /mnt/garden using MergerFS:

```bash
./gardenmount --mount --mergerfs
```

4. Unmount all drives withe label CHIA (previously mounted on any mountpoint)
```bash
./gardenmount --unmount
```

# Systemd service

The `gardenmount` command will output all required fstab entry lines for your CHIA disks and for combining all disks into a Union Filesystem in MergerFS. To make all your mount points persisent you can simply copy this output and paste it into your `/etc/fstab`. HOWEVER, if you are running a linux distribution that supports `systemd` like Debian or Ubuntu, you may consider using the provided systemd service files instead. Those will enable you to finetune your dependencies. For example you may want to make sure that your mounts are set before your docker.service is run. If you decide to use systemd you probably know how to modify these according to your needs.

## garden-mount.service

The `garden-mount.service` is a systemd service that is responsible for automatically mounting and unmounting all Chia-labelled drives on your system in /media/root/ or any desired mountfolder. If desired, it will also mount your drives in a single-drive-like filesystem in /mnt/garden using MergerFS (see --mergerfs option). This service ensures that your Chia-labelled drives are properly mounted when your system starts up, and unmounted when it shuts down. It relies on /usr/local/bin/gardenmount to perform the actual (un)mounting actions. You can modify the service accordingly if your drives have a different label-prefix by adding the --label [label] command (see gardenmount)

### Usage

Copy the systemd services to their directories and start/enable the service
```bash
sudo cp garden-mount.service /etc/systemd/system/
sudo cp gardenmount /usr/local/bin/
sudo systemctl daemon-reload
sudo systemctl start garden-mount.service
sudo systemctl enable garden-mount.service
```
