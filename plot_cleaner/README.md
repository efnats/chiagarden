# plot_cleaner

Remove stale `.plot.tmp` files that are no longer being written to.

## Features

- **Age-based filtering** – Only considers files older than X minutes
- **Write detection** – Checks if file is still being written before deleting
- **Dry-run mode** – Preview what would be deleted
- **Configurable** – Set directory, age threshold, and watch time

## Usage

```bash
# Clean default directory with defaults
plot_cleaner

# Dry run first
plot_cleaner --dry-run

# Custom directory
plot_cleaner --directory /mnt/plotting

# Only files older than 6 hours
plot_cleaner --age 360

# Longer watch time to confirm file isn't growing
plot_cleaner --watchtime 30
```

## Options

| Option | Description |
|--------|-------------|
| `--directory PATH` | Directory to clean (default: `/mnt/garden/gigahorse`) |
| `--age MINUTES` | Minimum file age (default: 360 = 6 hours) |
| `--watchtime SECONDS` | Time to watch for file changes (default: 15) |
| `--dry-run` | Show what would be deleted without deleting |

## How It Works

1. Find all `.plot.tmp` files older than `--age` minutes
2. For each file:
   - Record the file size
   - Wait `--watchtime` seconds
   - Check size again
3. If size unchanged → file is stale → delete it
4. If size changed → file is still being written → skip it

## When to Use

- After a plotter crash
- Before starting a new plotting session
- Periodically to reclaim space from failed plots

## Safety

The age threshold (default 6 hours) ensures you don't accidentally delete plots that are still being created. A typical plot takes 2-10 minutes, so 6 hours is very conservative.
