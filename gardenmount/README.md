# gardenmount - Mass disk (un)mounter for PoST farming

gardenmount facilitates the automatic mounting and unmounting of CHIA-labelled drives. It can produce mount entries suitable for direct inclusion into /etc/fstab. However, for enhanced efficiency, the script comes paired with systemd service files, which are the recommended method for managing mounts.

Additionally, gardenmount integrates with mergerfs. This tool merges multiple mounted devices into a single unified file system, streamlining file and folder management. Potential performance issues may arise with mergerfs when scaling beyond 20 HDDs, but its ability to organize data across multiple drives is undeniably handy and with the provided write policy "mfs", drives will be filled evenly during the plotting phase making sure to utilize a new disk for each copy process.

The 'slack' feature allows for optimized space utilization across hard drives to create a btrfs raid0 and mount it to a desired mount point (default /mnt/slack). A failure in one disk will compromise the entire raid0. Nonetheless, the raid can be easily reestablished, and it auto-expands with the addition of new disks. The maxsize parameter skips the slack file creation if it surpasses a set limit, ideally set above the smallest expected plot size.

## Requirements

- mergerfs https://github.com/trapexit/mergerfs (only for mounting all disks in a single-drive-like filesystem, not required for mounting the disks)
- have your disks labelled with a unified pattern (see chiainit)
- btrfs (is usually part of the kernel)

## Usage

`gardenmount [--label LABEL_PATTERN] [--mount [MOUNT_POINT]]|--unmount [--read-only] [--mergerfs [MERGERFS_PATH]] [--slack [SLACK_PATH]] [--maxsize SIZE] [--no-prompt]`


## Options

- `--mount [PATH]`: Mount devices with the specified label pattern. Optionally, specify the mount point base directory. Default is `/media/username`. 
- `--unmount`: Unmount devices with the specified label pattern. Also unmounts the MergerFS mountpoint if it exists.  
- `--label PATTERN`: Specifies the label pattern of the devices to mount or unmount. Default pattern is 'CHIA'.
- `--read-only`: Mount the devices in read-only mode.  
- `--mergerfs [PATH]`: Use MergerFS to merge the mounted devices into a singular filesystem, creating a unified view of your data. The default mount point is `/mnt/garden`.
- `--slack [PATH]`: Utilizes the slack space across drives by mounting a raid0 structure using loop devices. The default mount point for this feature is `/mnt/slack`.
- `--maxsize SIZE`: Determines the maximum allowed size for the slack space that's mounted, given in GB. It's recommended to set this value higher than your expected plot file size.
- `--no-prompt`: Executes the script in a non-interactive mode, avoiding any prompts.
- `--print-fstab`: Outputs the fstab entries, making it easy to copy and paste into `/etc/fstab`. For an optimal experience, consider using the systemd services provided in the chiagarden repository.
- `--help`: Displays the command help.

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

4. Mount all drives with the label prefix 'CHIA' in /meda/root and mount these disks in a single-drive-like filesystem in /mnt/garden using MergerFS. Create loop devices from slack space and mount it on /mnt/slack using btrfs raid0. Ignore disks which have more than 80GB slack space (still offering enough space for directly storing plot(s))

```bash
./gardenmount --mount --mergerfs --slack --maxsize 80
```

5. Unmount all drives withe label CHIA (previously mounted on any mountpoint)
```bash
./gardenmount --unmount
```

# Systemd service

The `gardenmount` command will output all required fstab entry lines for your CHIA disks and for combining all disks into a Union Filesystem in MergerFS. To make all your mount points persisent you can simply copy this output and paste it into your `/etc/fstab`. HOWEVER, if you are running a linux distribution that supports `systemd` like Debian or Ubuntu, you may consider using the provided systemd service files instead. Those will enable you to finetune your dependencies. For example you may want to make sure that your mounts are set before your docker.service is run. If you decide to use systemd you probably know how to modify these according to your needs.

## garden-mount.service

The `garden-mount.service` is a systemd service that is responsible for automatically mounting and unmounting all Chia-labelled drives on your system in /media/root/ or any desired mountfolder. If desired, it will also mount your drives in a single-drive-like filesystem in /mnt/garden using MergerFS (see --mergerfs option). This service ensures that your Chia-labelled drives are properly mounted when your system starts up, and unmounted when it shuts down. It relies on /usr/local/bin/gardenmount to perform the actual (un)mounting actions. You can modify the service accordingly if your drives have a different label-prefix by adding the --label [label] command (see gardenmount)

### Usage

Copy the systemd services to their directories and start/enable the service or use the provided `install.sh` in the main folder
```bash
sudo cp garden-mount.service /etc/systemd/system/
sudo cp gardenmount /usr/local/bin/
sudo systemctl daemon-reload
sudo systemctl start garden-mount.service
sudo systemctl enable garden-mount.service
```
