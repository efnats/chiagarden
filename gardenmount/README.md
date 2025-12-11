# gardenmount

Mount and unmount Chia drives by label pattern. Combines drives with MergerFS and reclaims leftover space with slack mounting.

## Features

- **Label-based mounting** – Mount all `CHIA-*` drives with one command
- **MergerFS integration** – Combine all drives into a single filesystem
- **Slack space recovery** – Reclaim the leftover space that can't fit another plot
- **Status overview** – List all drives with mount and slack status
- **Systemd service** – Auto-mount on boot

## Quick Start

```bash
# Show current status
gardenmount --list

# Mount with MergerFS
gardenmount --mount --mergerfs

# Full setup: mount + MergerFS + slack recovery
gardenmount --mount --mergerfs --slack

# Unmount everything
gardenmount --unmount
```

## How It Works

### 1. Individual Mounts
Mounts each drive matching the label pattern:
```
/media/root/CHIA-2BHUY2D/
/media/root/CHIA-2CGRR6T/
/media/root/CHIA-2CHE40Y/
```

### 2. Slack Space (optional)
Creates `slack.img` files on leftover space, combines them via loop devices into a BTRFS RAID0:
```
/mnt/slack/
```

### 3. MergerFS (optional)
Combines everything into one unified filesystem:
```
/mnt/garden/
```

## Usage

```
Usage: gardenmount --mount|--unmount|--list [OPTIONS]

Actions:
  --mount [PATH]              Mount drives (default: /media/$USER)
  --unmount                   Unmount all drives, slack, and MergerFS
  --list                      Show status of drives, MergerFS, and slack

Options:
  --label PATTERN             Label pattern to match (default: CHIA)
  --mergerfs [PATH]           Create MergerFS union (default: /mnt/garden)
  --slack [PATH]              Enable slack space recovery (default: /mnt/slack)
  --maxsize SIZE              Max slack size in GB (default: 110)
  --read-only                 Mount drives as read-only
  --no-prompt                 Non-interactive mode (for systemd)
  --print-fstab               Print fstab entries (use with --list)
  --help                      Show this help
```

## Examples

```bash
# Show status of all CHIA drives
gardenmount --list

# Show status with fstab entries
gardenmount --list --print-fstab

# Mount with different label
gardenmount --mount --label FARM --mergerfs

# Limit slack space to 80GB per drive
gardenmount --mount --mergerfs --slack --maxsize 80

# Read-only mount (for backup nodes)
gardenmount --mount --mergerfs --read-only

# For systemd service (non-interactive)
gardenmount --mount --mergerfs --slack --read-only --no-prompt
```

## Output Examples

**--list:**
```
gardenmount 1.0

Drive            Size     Mounted                                  Slack
-----            ----     -------                                  -----
CHIA-2BHUY2D     14.6T    /media/root/CHIA-2BHUY2D                 45.2G
CHIA-2CGRR6T     14.6T    /media/root/CHIA-2CGRR6T                 38.1G
CHIA-2CHE40Y     14.6T    /media/root/CHIA-2CHE40Y                 -

7 disks mounted

MergerFS:  /mnt/garden (101.9T)
Slack:     /mnt/slack (156G / 312G)
```

## Systemd Service

Enable auto-mounting on boot:

```bash
sudo systemctl enable gardenmount.service
sudo systemctl start gardenmount.service
```

The service uses `--no-prompt` for non-interactive operation.

## Requirements

- `mergerfs` – Combines drives into unified view
- `btrfs-progs` – For slack space BTRFS RAID0

## Related Tools

- [chiainit](../chiainit/) – Prepare and label drives for use with gardenmount
- [taco_list](../taco_list/) – List drives by label (used internally)
