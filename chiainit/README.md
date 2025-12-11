# chiainit

Mass-prepare hard drives for Chia farming. Format, partition, and label multiple drives in one command.

## Features

- **Batch operations** – Process ranges like `sda-sdz` or `sda-sdbz` in one command
- **Smart labeling** – Uses drive serial numbers for unique labels (e.g., `CHIA-WD40EZAZ`)
- **Non-destructive labeling** – Relabel existing drives without formatting
- **Drive listing** – View all drives with labels, filesystem, and optionally SMART data
- **Dry-run mode** – Preview what would happen without making changes
- **Progress tracking** – Shows `[1/32]` counter and success/failed summary
- **Filesystem support** – XFS, ext4, NTFS
- **Safety first** – Excludes system drives automatically, requires explicit confirmation

## Quick Start

```bash
# List all drives
chiainit --list

# List with SMART data (temp, hours, reallocated sectors)
chiainit --list --smart

# Preview what --init would do
chiainit --dry-run --fstype xfs --init sda-sdz

# Label existing drives (non-destructive, keeps data)
chiainit --label sda-sdz

# Full initialization: wipe, format, and label
chiainit --fstype xfs --init sda-sdz
```

## Usage

```
Usage: chiainit [OPTIONS] drive1 drive2 ... driveN

Actions:
  --list                      List drives with labels and details
  --wipe                      Wipe the specified drives
  --format                    Format the specified drives (requires --fstype)
  --label                     Label the specified drives (non-destructive)
  --init                      Wipe, format, and label (requires --fstype)

Options:
  --smart                     Show SMART data (use with --list)
  --fstype [xfs|ext4|ntfs]    Specify the filesystem type
  --label-prefix PREFIX       Custom label prefix (default: CHIA)
  --all                       Operate on all drives (excluding system drives)
  --exclude drive1 drive2     Exclude drives from the operation
  --dry-run                   Show what would be done without making changes
  --log [FILE]                Write log (default: ./chiainit-DATE.log)
  --help                      Show this help
```

## Examples

```bash
# List specific drives
chiainit --list sda-sdd

# List all drives with SMART health info
chiainit --list --smart --all

# Label with custom prefix
chiainit --label-prefix FARM --label sda-sdf

# Initialize all drives except system and specific ones
chiainit --fstype xfs --init --all --exclude sda sdb

# Dry-run to see what would happen
chiainit --dry-run --fstype ext4 --init sda-sdz

# With logging
chiainit --log --fstype xfs --init sda-sdz
```

## Output Examples

**--list:**
```
Drive        Size     Label            Filesystem   Serial
-----        ----     -----            ----------   ------
/dev/sda     14.6T    CHIA-2CJUEZUN    xfs          WD-2CJUEZUN
/dev/sdb     14.6T    CHIA-2CJUBWUN    xfs          WD-2CJUBWUN
/dev/sdc     14.6T    (none)           (none)       WD-2CJXXXXX

Found 3 drives (2 labeled, 1 unlabeled)
```

**--list --smart:**
```
Drive        Size     Label            FS      Temp   Hours    Realloc  Status
-----        ----     -----            --      ----   -----    -------  ------
/dev/sda     14.6T    CHIA-2CJUEZUN    xfs     35°C   12543    0        OK
/dev/sdb     14.6T    CHIA-2CJUBWUN    xfs     42°C   28891    12       WARN
/dev/sdc     14.6T    CHIA-2CJXXXXX    xfs     38°C   45000    0        FAIL

Found 3 drives (3 labeled, 0 unlabeled)
```

**--init with progress:**
```
[1/32] Drive /dev/sda [14.6T]
  ✔ /dev/sda wiping...... ok
  ✔ /dev/sda formatting.. xfs
  ✔ /dev/sda labeling.... CHIA-2CJUEZUN

[2/32] Drive /dev/sdb [14.6T]
  ✔ /dev/sdb wiping...... ok
  ...

Summary
Success: 32  Failed: 0
```

## SMART Status

When using `--list --smart`, the status column shows:

| Status | Meaning |
|--------|---------|
| **OK** (green) | SMART health passed, no reallocated sectors |
| **WARN** (yellow) | SMART health passed, but has reallocated sectors |
| **FAIL** (red) | SMART health check failed |

## Requirements

- `smartmontools` – Serial number and SMART data
- `xfsprogs` – XFS filesystem support
- `ntfs-3g` – NTFS filesystem support
- `parted` – Partitioning

## Safety

Destructive operations (`--wipe`, `--format`, `--init`) require you to type:

```
YES I SACRIFICE THIS DATA
```

Use `--dry-run` to preview operations first. System drives are automatically excluded.

## Related Tools

- [gardenmount](../gardenmount/) – Mount labeled drives and create unified view via mergerfs
- [taco_list](../taco_list/) – List drives by label (used internally)
