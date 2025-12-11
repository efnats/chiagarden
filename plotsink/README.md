# plotsink

Receive plots over the network using MadMax's [`chia_plot_sink`](https://github.com/madMAx43v3r/chia-plot-sink). Simple wrapper that auto-discovers destination drives.

## The Problem

MadMax's `chia_plot_sink` is excellent at receiving plots over the network and writing them to multiple HDDs in parallel. This parallelism is essential—GPU plotters create plots faster than any single HDD can store them.

But `chia_plot_sink` requires you to list every destination drive manually:

```bash
chia_plot_sink -- /media/user/CHIA-WD40EZAZ/gigahorse /media/user/CHIA-ST8000DM/gigahorse /media/user/CHIA-TOSHIBA01/gigahorse ...
```

With 30+ drives, this gets tedious. And if drives change, you have to update the command.

## The Solution

`plotsink` uses [taco_list](../taco_list/) to automatically discover all drives matching your label pattern. Just run:

```bash
plotsink
```

That's it. It finds all `CHIA-*` drives and starts `chia_plot_sink` with the right destinations.

## Features

- **Auto-discovery** – Uses `taco_list` to find all CHIA drives
- **Zero configuration** – Works out of the box with ChiaGarden labeling
- **Parallel writes** – `chia_plot_sink` distributes plots across all available drives
- **Network receiving** – Accept plots from remote GPU plotters

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

## Related Tools

- [plot_over](../plot_over/) – Keeps drives free so `chia_plot_sink` always has somewhere to write
- [taco_list](../taco_list/) – The drive discovery tool that makes this automation possible

## Requirements

- `chia_plot_sink` from MadMax Gigahorse
- `taco_list` (included in ChiaGarden)

Download `chia_plot_sink` from: https://github.com/madMAx43v3r/chia-plot-sink
