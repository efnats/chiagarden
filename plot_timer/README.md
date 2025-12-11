# plot_timer

Monitor plotting performance by parsing systemd logs. Shows average times per phase and data transfer speeds.

## Features

- **Phase breakdown** – See how long each plotting phase takes
- **Averages** – Calculate averages over configurable time windows
- **Transfer stats** – Track data transferred and average speed
- **Auto-refresh** – Continuously updates the display

## Usage

```bash
# Show stats from last 30 minutes (default)
plot_timer

# Show stats from last 2 hours
plot_timer --last 120

# Custom refresh interval
plot_timer --last 60 --interval 30
```

## Options

| Option | Description |
|--------|-------------|
| `--last MINUTES` | Time window for stats (default: 30) |
| `--interval SECONDS` | Refresh interval (default: 80) |

## Output

```
Chiagarden plot_timer

Created 12 plots in the last 30 minutes

Average
C18            Seconds   Minutes
================================
Phase 1          45.23      0.75
Phase 2          62.18      1.04
Phase 3          38.92      0.65
Phase 4          12.45      0.21
================================
Total Avg       158.78      2.65

Total
Data Transferred    1.23 TiB
Average Speed      285.50 MB/s
```

## Requirements

- `plot_starter.service` must be running (logs are read from journald)
- `bc` for calculations

## How It Works

1. Reads `plot_starter` logs from journalctl
2. Parses completion times for each phase
3. Calculates averages per compression level
4. Displays transfer statistics
