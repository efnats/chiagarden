# plot_counter - Displays amount of plots for each C-level

`plot_counter`: A script that counts Chia plots on multiple disks and calculates their total size in TiB (tebibytes). The script will scan mounted disks at a specified interval and display the count and size of plots found for each compression level. The results are displayed in a table format in the terminal.

## Requirements

- The script assumes that your Chia plots are stored on mounted disks with a specific label format (e.g., CHIA-).
- Use `Chiainit` from this repository for easy labelling or your CHIA drives

## Usage

```bash
./chia_plot_counter.sh <mountpoint_of_chia_disks> [--interval interval_seconds] [--label chia_disks_label]
```

## Options

   - `--interval`(optional): rescan interval in seconds (Default: 120 seconds)
   - `--label`: The label for Chia disks to include in the search. Default is "CHIA"
   


# plot_mover - A simple and user-friendly plot moving script

`plot_mover` is a Bash script that monitors a specified source directory for new Chia plot files and moves them to a specified destination directory using `rsync`.

## Prerequisites

- rsync

## Usage

```bash
./plot_mover <watch_dir> <dest_dir>
```

- `<watch_dir>`: The source directory to monitor for new plot files.
- `<dest_dir>`: The destination directory to move the plot files to.

## Example

```bash
./plot_mover /mnt/plotting /mnt/garden
```

This command will monitor the `/mnt/plotting` directory for new plot files and move them to the `/mnt/garden` directory when detected.



# plot_over - A replot helper

`plot_over`: This script monitors the free space of Chia plot disks and automatically removes older plots when the free space falls below a specified threshold. The script aims to maintain a desired number of disks with at least the specified minimum free space.

## Requirements

- duf-utility https://github.com/muesli/duf
- The script assumes that your Chia plots are stored on mounted disks with a specific label format (e.g., CHIA-).

## Usage

1. Open the script in a text editor and set the following variables according to your setup:

   - `chiadisks_mountpoint`: mount point of Chia disks (e.g., /media/root)
   - `min_free_space`: minimum free space in GB (e.g., 100)
   - `replot_levels`: comma-separated list of plot compression levels that may be replotted
   - `amount_free_disks`: desired number of disks with minimum free space (e.g., 10)
   - `interval`: rescan interval in seconds (default is 30 seconds)
     
2. To run the script make sure to make it executable first

   - `chmod +x plot_over`
   - `./plot_over`

## Options

   - `--dry-run`(optional): simulation mode. Will not delete anything

## Example
   
   -`./plot_over --dry-run`