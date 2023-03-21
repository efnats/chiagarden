# Garden Mount

This folder contains two shell scripts and two systemd services for (un)mounting and managing Chia-labelled drives in a garden mount setup.

## Contents

1. `chia-mountall`: A shell script to mount all Chia-labelled drives.
2. `chia-unmountall`: A shell script to unmount all Chia-labelled drives.
3. `mnt-garden.mount`: A systemd mount unit to mount the mergerfs volume from Chia-labelled disks.
4. `mount-chia-drives.service`: A systemd service to (un)mount all Chia-labelled drives.

## Usage

### Shell Scripts

#### chia-mountall

To mount all Chia-labelled drives, run the script:

```bash
./chia-mountall
chia-unmountall
./chia-unmountall

Systemd Services
mnt-garden.mount
To enable and start the systemd mount unit:

sudo systemctl enable mnt-garden.mount
sudo systemctl start mnt-garden.mount

To stop and disable the systemd mount unit:

sudo systemctl stop mnt-garden.mount
sudo systemctl disable mnt-garden.mount

mount-chia-drives.service
To enable and start the systemd service:
sudo systemctl enable mount-chia-drives.service
sudo systemctl start mount-chia-drives.service

sudo systemctl enable mount-chia-drives.service
sudo systemctl start mount-chia-drives.service
sudo systemctl stop mount-chia-drives.service
sudo systemctl disable mount-chia-drives.service
