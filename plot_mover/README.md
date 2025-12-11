# plot_mover

Watch a directory for completed plots and automatically move them to a destination.

## Features

- **Directory watching** – Monitors source directory for new `.plot` files
- **Automatic transfer** – Uses rsync with preallocate and progress
- **Source cleanup** – Removes source file after successful transfer
- **Logging** – Logs all transfers to `/var/log/plot_move.log`

## Usage

```bash
plot_mover /path/to/source /path/to/destination
```

### Example

```bash
# Move plots from local SSD to farm drive
plot_mover /mnt/plotting /mnt/garden

# Move plots to network destination
plot_mover /mnt/plotting /mnt/nfs/farm
```

## How It Works

1. Watches the source directory for `.plot` files
2. When a plot appears, transfers it to destination using rsync
3. After successful transfer, removes the source file
4. Loops continuously, checking every 5 seconds

## Options

The script uses these rsync options by default:
- `--preallocate` – Preallocate disk space
- `--remove-source-files` – Delete source after transfer
- `--skip-compress plot` – Don't compress (plots are already compressed)
- `--progress` – Show transfer progress

## Logging

All transfers are logged to `/var/log/plot_move.log` with timestamps.

## Stopping

Press `Ctrl+C` to stop the watcher gracefully.
