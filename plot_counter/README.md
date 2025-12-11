# plot_counter

Count and monitor plots across all your drives. Shows distribution by compression level and plotting activity over time.

## Features

- **Plot distribution** – Count plots by compression level (C0-C33)
- **Size tracking** – Show actual TiB and effective TiB
- **Activity monitoring** – Track plots created per minute/hour/day/week
- **Write speed** – Monitor MB/s being written to drives
- **Auto-refresh** – Continuously updates the display

## Usage

```bash
# Count by label pattern
plot_counter --label CHIA

# Count by mount directory
plot_counter --mount-dir /mnt/plots

# Custom refresh interval (default: 180 seconds)
plot_counter --label CHIA --interval 60
```

## Options

| Option | Description |
|--------|-------------|
| `--label PATTERN` | Count plots on drives with this label |
| `--mount-dir PATH` | Count plots in this directory |
| `--interval SECONDS` | Refresh interval (default: 180) |

## Output

```
Chiagarden plot_counter

Disks with label pattern 'CHIA': 32

Plots distribution
Plot          Count          TiB         eTiB
============================================
C5:            1234        98.76        122.18
C7:            5678       420.12        562.34
============================================
Total          6912       518.88        684.52


Data written
Period       Plots          TiB     Sec/Plot      MB/s
=======================================================
Minute           0         0.00                   0.00
Hour             3         0.24          240     72.50
Day             72         5.76          200     70.12
Week           504        40.32          200     68.45
Month         2160       172.80          200     67.89
```

## What the Numbers Mean

- **TiB** – Actual disk space used
- **eTiB** – Effective TiB (normalized to uncompressed plot equivalent)
- **Sec/Plot** – Average seconds per plot in that time period
- **MB/s** – Average write speed
