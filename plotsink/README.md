# plotsink

Receive plots over the network using MadMax's `chia_plot_sink`. Simple wrapper that auto-discovers destination drives.

## Features

- **Auto-discovery** – Uses `taco_list` to find all CHIA drives
- **Network receiving** – Accept plots from remote plotters
- **Load balancing** – `chia_plot_sink` distributes across drives

## Usage

```bash
plotsink
```

That's it. It automatically:
1. Finds all drives labeled `CHIA-*`
2. Looks for a `gigahorse/` subdirectory on each
3. Starts `chia_plot_sink` with those destinations

## How It Works

```bash
# What plotsink does internally:
dest_disks=$(/usr/local/bin/taco_list --label CHIA --subdir gigahorse/ --separator space)
/usr/local/bin/chia_plot_sink -- $dest_disks
```

## Configuration

Edit the script to change:
- Label pattern (default: `CHIA`)
- Subdirectory (default: `gigahorse/`)

## Network Setup

On your **plotter**, configure the destination as:
```
-d @192.168.1.100
```

Where `192.168.1.100` is the IP of the machine running `plotsink`.

Default port is `1337`.

## Systemd Service

```bash
sudo systemctl enable plotsink.service
sudo systemctl start plotsink.service
```

## Requirements

- `chia_plot_sink` from MadMax Gigahorse
- `taco_list` (included in ChiaGarden)

Download `chia_plot_sink` from: https://github.com/madMAx43v3r/chia-gigahorse
