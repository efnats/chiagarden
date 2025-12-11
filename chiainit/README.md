# chiainit

Mass-prepare hard drives for Chia farming. Format, partition, and label multiple drives in one command.

## Features

- **Batch operations** – Process ranges like `sda-sdz` in one command
- **Smart labeling** – Uses drive serial numbers for unique labels (e.g., `CHIA-WD40EZAZ`)
- **Non-destructive labeling** – Relabel existing drives without formatting
- **Filesystem support** – XFS, ext4, NTFS
- **Safety first** – Excludes system drives automatically, requires explicit confirmation for destructive actions

## Usage

```bash
# List available drives
chiainit --help

# Label existing drives (non-destructive)
chiainit --label sdb sdc sdd

# Label a range of drives
chiainit --label sda-sdz

# Full initialization: wipe, format, and label
chiainit --fstype xfs --init sda-sdz

# Exclude specific drives
chiainit --fstype ext4 --init --all --exclude sda sdb

# Custom label prefix
chiainit --label-prefix GIGA --label sda-sdf
```

## Options

| Option | Description |
|--------|-------------|
| `--wipe` | Wipe the specified drives |
| `--format` | Format drives (requires `--fstype`) |
| `--label` | Label drives (filesystem auto-detected) |
| `--init` | Wipe + format + label in one step |
| `--fstype [xfs\|ext4\|ntfs]` | Filesystem type for formatting |
| `--label-prefix PREFIX` | Custom prefix (default: `CHIA`) |
| `--all` | Operate on all drives (excluding system) |
| `--exclude [drives]` | Exclude specific drives |

## Requirements

- `xfsprogs` (for XFS)
- `smartmontools` (for serial number detection)
- `ntfs-3g` (for NTFS)
- `parted`

## Safety

Destructive operations (`--wipe`, `--format`, `--init`) require you to type:

```
YES I SACRIFICE THIS DATA
```

System drives and mounted drives are automatically excluded.

## Output

Operations are logged to `./chiainit.log` with timestamps.
