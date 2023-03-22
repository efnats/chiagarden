# Chia Garden - plotting tools

This repository contains useful scripts for managing and monitoring Chia plots.

## Scripts

### plot_counter - Display amount of plots for each C-Level

## Description

`plot_counter`: A script that counts Chia plots on multiple disks and calculates their total size in TiB (tebibytes). The script will scan mounted disks at a specified interval and display the count and size of plots found for each compression level. The results are displayed in a table format in the terminal.

## Requirements

- The script assumes that your Chia plots are stored on mounted disks with a specific label format (e.g., CHIA-).
- Use `Chiainit` from this repository for easy labelling or your CHIA drives

## Usage

1. Open the script in a text editor and set the following variables according to your setup:

   - `interval`: rescan interval in seconds (default is 120 seconds)
   - `chiadisks_mount`: mount point of Chia disks (e.g., /media/root)
   - `chiadisks_label`: label prefix for Chia disks (e.g., CHIA-) - leave empty `""` if no specific label is assigned

2. Save the script and make it executable by running:

   - `chmod +x plot_counter`


### plot_over replot helper

## Description

`plot_over`: This script monitors the free space of Chia plot disks and automatically removes older plots when the free space falls below a specified threshold. The script aims to maintain a desired number of disks with at least the specified minimum free space.

## Requirements

- Bash shell
- The script assumes that your Chia plots are stored on mounted disks with a specific label format (e.g., CHIA-).

## Usage

1. Open the script in a text editor and set the following variables according to your setup:

   - `chiadisks_mountpoint`: mount point of Chia disks (e.g., /media/root)
   - `min_free_space`: minimum free space in GB (e.g., 100)
   - `replot_levels`: comma-separated list of plot compression levels that may be replotted
   - `amount_free_disks`: desired number of disks with minimum free space (e.g., 10)
   - `interval`: rescan interval in seconds (default is 30 seconds)
   
2. Save the script and make it executable by running:

   - `chmod +x plot_over`

3. Run the script:

   - `./plot_over`






