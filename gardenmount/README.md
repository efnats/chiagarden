# gardenmount

Mount and unmount Chia drives by label pattern. Combines drives with mergerfs and reclaims leftover space with slack mounting.

## Features

- **Label-based mounting** – Mount all `CHIA-*` drives with one command
- **mergerfs integration** – Combine all drives into a single filesystem
- **Slack space recovery** – Reclaim the leftover space that can't fit another plot
- **Systemd service** – Auto-mount on boot

## How It Works

### 1. Individual Mounts
Mounts each drive matching the label pattern:
```
/media/user/CHIA-WD40EZAZ/
/media/user/CHIA-ST8000DM/
/media/user/CHIA-TOSHIBA01/
```

### 2. Slack Space (optional)
Creates `slack.img` files on leftover space, combines them via loop devices into a btrfs raid0:
```
/mnt/slack/
```

### 3. mergerfs (optional)
Combines everything into one unified filesystem:
```
/mnt/garden/
```

## Usage

```bash
# Basic mount
gardenmount --mount --label CHIA

# Mount with mergerfs
gardenmount --mount --label CHIA --mergerfs

# Full setup: individual + slack + merged
gardenmount --mount --label CHIA --mergerfs --slack

# Limit slack space (max 80GB per drive)
gardenmount --mount --label CHIA --mergerfs --slack --maxsize 80

# Unmount everything
gardenmount --unmount --label CHIA

# Read-only mount
gardenmount --mount --label CHIA --read-only

# Generate fstab entries
gardenmount --mount --label CHIA --print-fstab
```

## Options

| Option | Description |
|--------|-------------|
| `--mount [PATH]` | Mount drives (default: `/media/$USER`) |
| `--unmount` | Unmount all drives |
| `--label PATTERN` | Label pattern to match (default: `CHIA`) |
| `--mergerfs [PATH]` | Enable mergerfs (default: `/mnt/garden`) |
| `--slack [PATH]` | Enable slack mounting (default: `/mnt/slack`) |
| `--maxsize SIZE` | Max slack size per drive in GB (default: 110) |
| `--read-only` | Mount as read-only |
| `--no-prompt` | Non-interactive mode (for systemd) |
| `--print-fstab` | Print fstab entries |

## Systemd Service

Enable auto-mounting on boot:

```bash
sudo systemctl enable gardenmount.service
sudo systemctl start gardenmount.service
```

## Requirements

- `mergerfs`
- `btrfs-progs` (for slack space)
