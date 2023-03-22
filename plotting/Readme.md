# Chia Garden

This repository contains useful scripts for managing and monitoring Chia plots.

## Scripts

### Chia Plot Counter

`chia_plot_counter.sh`: A script that counts Chia plots on multiple disks and calculates their total size in TiB (tebibytes). The script will scan mounted disks at a specified interval and display the count and size of plots found for each pattern.

- [README for Chia Plot Counter](./path/to/chia_plot_counter/README.md)

### Chia Plot Replotter

`chia_plot_replotter.sh`: This script monitors the free space of Chia plot disks and automatically removes older plots when the free space falls below a specified threshold. The script aims to maintain a desired number of disks with at least the specified minimum free space.

- [README for Chia Plot Replotter](./path/to/chia_plot_replotter/README.md)



