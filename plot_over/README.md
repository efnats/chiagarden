# plot_over

Automatically delete old plots to make room for new ones during replotting. Ensures a configurable number of drives always have free space.

## Why Keep Multiple Disks Free?

Modern GPU plotters create plots in 2-5 minutes. These plots are initially written to a fast NVMe SSD, then transferred to HDDs for permanent storage. The problem: **a single HDD is too slow to keep up with GPU plotting speed.**

The solution is parallel writes to multiple HDDs. MadMax's [`chia_plot_sink`](https://github.com/madMAx43v3r/chia-plot-sink) distributes incoming plots across all available drives simultaneously. But this only works if multiple drives have free space ready to receive plots.

`plot_over` ensures you always have N drives with enough free space by automatically deleting the oldest plots of specified compression levels. This keeps your replotting pipeline flowing without manual intervention.

**Example:** With `amount_free_disks=3`, you always have 3 HDDs ready. While one receives a plot, the next two are standing by. By the time all three have received a plot, the first one is ready again.

> **See also:** [plotsink](../plotsink/) wraps `chia_plot_sink` and uses [taco_list](../taco_list/) to automatically discover all your CHIA drives—no manual drive list needed.

## Features

- **Smart deletion** – Removes oldest plots of specified compression levels
- **Free space management** – Maintains N drives with X GB free
- **Replot tracking** – Skips drives that are fully replotted
- **Dry-run mode** – Test without deleting anything
- **Systemd service** – Run continuously in the background

## Usage

```bash
# Run with config file
plot_over --config /etc/chiagarden/plot_over.config

# Dry run (no deletions)
plot_over --config plot_over.config --dry-run
```

## Configuration

Create `plot_over.config`:

```bash
# Which drives to manage
label=CHIA                    # Label pattern (or use mount_dir)
# mount_dir=/mnt/plots        # Alternative: specify mount directory
subdir=                       # Subdirectory within drives (optional)

# Free space requirements
amount_free_disks=3           # Number of drives to keep free
min_free_space=110            # Minimum free GB per drive

# Which plot levels to delete (comma-separated)
replot_levels=0,1,2,3,4,5,6   # Delete C0-C6 plots

# Behavior
interval=120                  # Seconds between scans
search_depth=3                # How deep to search for plots
display_search_paths=false    # Show which paths are being searched
logfile=/var/log/plot_over.log
```

## How It Works

1. Scans all drives matching the label/mount pattern
2. Identifies drives that are "fully replotted" (no old plots)
3. Checks how many drives have enough free space
4. If not enough free drives:
   - Finds the oldest plot matching `replot_levels`
   - Deletes it
   - Repeats until enough drives have free space
5. Sleeps and repeats

## Options

| Option | Description |
|--------|-------------|
| `--config FILE` | Path to config file |
| `--dry-run` | Show what would be deleted without deleting |
| `--help` | Show help |

## Systemd Service

Enable continuous replotting management:

```bash
sudo systemctl enable plot_over.service
sudo systemctl start plot_over.service

# View logs
journalctl -u plot_over -f
```

## Output

```
Chiagarden plot_over

Watching a total of 32 drives labelled with the pattern CHIA
3 drives each required to have 110 GB free space
28 drives are fully replotted
Plot levels marked for removal: 0,1,2,3,4,5,6

3 drives meet the requirements
╭────────────────────────────────────────────────────────╮
│ /media/user/CHIA-WD40EZAZ   120G free                  │
│ /media/user/CHIA-ST8000DM   115G free                  │
│ /media/user/CHIA-TOSHIBA01  118G free                  │
╰────────────────────────────────────────────────────────╯

There are enough free disks. No need to remove any plot files.
```

## Requirements

- `duf` (optional, for pretty disk display)
- `bc`
