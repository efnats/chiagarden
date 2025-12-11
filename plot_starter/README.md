# plot_starter

Start and manage the Chia plotting process. Wraps MadMax's CUDA plotter with automatic cleanup and crash recovery.

## Features

- **Config-based** – All plotter parameters in one config file
- **Auto-cleanup** – Removes stale `.tmp` files before starting
- **Plot recovery** – Copies any finished plots from previous runs
- **Guru meditation** – Delays start if system crashed too often (worn SSD protection)
- **Systemd ready** – Run as a service on boot

## Usage

```bash
# Run with default config
plot_starter

# Run with custom config
plot_starter --config /path/to/config

# Enable crash protection
plot_starter --guru-meditation
```

## Configuration

Create `plot_starter.config`:

```bash
# Required settings
contract="xch1your_pool_contract_address"
farmerkey="your_farmer_public_key"
finaldir="@192.168.1.100"     # Remote destination (@host) or local path
tmpdir="/mnt/plotting"         # SSD temp directory

# Compression
level="18"                     # Compression level (1-9, 11-20)
count="-1"                     # Number of plots (-1 = infinite)

# Optional: Partial RAM mode
tmpdir2="/mnt/fast_ssd"        # Second temp directory

# Optional: Disk mode
tmpdir3="/mnt/nvme"            # Third temp directory

# Hardware settings
device="0"                     # CUDA device
ndevices="1"                   # Number of GPUs

# Copy settings
maxcopy="1"                    # Max parallel copies per HDD
copylimit="-1"                 # Max total parallel copies

# Crash protection (guru meditation)
guru_meditation=false
max_reboots=2                  # Reboots in time window
lastminutes=120                # Time window in minutes
cooldowntime=15                # Delay in minutes if triggered
```

## How It Works

1. **Check mount** – Ensures tmpdir is mounted
2. **Cleanup** – Removes orphaned `.tmp` files
3. **Recovery** – Copies any leftover `.plot` files to destination
4. **Guru check** – Optionally delays if too many recent reboots
5. **Start plotter** – Launches cuda_plot_k32 with configured parameters

## Options

| Option | Description |
|--------|-------------|
| `--config FILE` | Custom config file path |
| `--guru-meditation` | Enable crash protection delay |
| `--help` | Show help |

## Systemd Service

```bash
sudo systemctl enable plot_starter.service
sudo systemctl start plot_starter.service

# View output
journalctl -u plot_starter -f
```

## Requirements

- `cuda_plot_k32` (MadMax GPU plotter)
- `chia_plot_copy` (for plot recovery)

Download from: https://github.com/madMAx43v3r/chia-gigahorse

## Guru Meditation

If your plotting rig crashes repeatedly (common with worn SSDs or PSU issues), enabling `--guru-meditation` will:

1. Check how many reboots occurred in the last X minutes
2. If over the limit, wait Y minutes before starting
3. This prevents a crash loop from destroying your SSD
