# plot_counter - Display amount of plots for each C-level

`plot_counter`: A script that counts Chia plots on multiple disks and calculates their total size in TiB (tebibytes). The script will scan mounted disks at a specified interval and display the count and size of plots found for each compression level. The results are displayed in a table format in the terminal.

## Usage

```bash
./chia_plot_counter (--mount-dir </path/to/dir> | --label <disklabel>) [--interval interval_seconds]
```

## Options
   - `--mount-dir` </path/to/dir>: Count Chia plots in the specified directory
   - `--label` <disklabel>: Count Chia plots in the disks starting with the specified label pattern (default: CHIA)
   - `--interval` <interval_seconds>: Set the rescan interval in seconds (default: 120 seconds)

## Examples

count all plots in /media/root/* Rescan after 100 seconds.

```bash
./chia_plot_counter --mount-dir /media/root --interval 100
```


count all plots from all disks in /media/root/ beginning with the pattern CHIA* (/media/root/CHIA-001 /media/root/CHIA-002 ...)

```bash
./chia_plot_counter /media/root/CHIA
```   

count all plots from all disks labelled beginning with the pattern GIGA (no matter where they are mounted at in the system).

```bash
./chia_plot_counter --label GIGA
```   


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

`plot_over`: This script will assist your replotting process by gradually removing undesired plots with a given compression level. To achieve this it will monitor the free space of Chia plot disks and automatically remove older plots of one or multiple given C-levels when the free space of a disk falls below a specified threshold. The script aims to maintain a desired number of disks with at least the specified minimum free space. This way enough disks are continously offered to other tools like plot_sink or mergerfs to optimize bandwith.

## Requirements

- duf-utility https://github.com/muesli/duf
- your plot files are either distributed on disks labelled with the same prefix or the plot disks are all mounted in one mountpoint exclusively.

## Usage

1. Open the script in a text editor and set the following variables according to your setup:

   - `min_free_space`: minimum free space in GB per Disk(e.g., 100)
   - `replot_levels`: comma-separated list of plot compression levels that may be replotted
   - `amount_free_disks`: desired number of disks with minimum free space (e.g., 10)
   - `interval`: rescan interval in seconds (default is 30 seconds)
     
2. To run the script make sure to make it executable first

   - `chmod +x plot_over`
   - `./plot_over`

## Options

   - `--dry-run`(optional): simulation mode. Will not delete anything
   - `--mount-dir </path/to/dir>`: Process Plots under the specified directory
   - `--label <disklabel>`: Process plots in the disks starting with the specified label pattern
   - `--subdir <subdir>`: Process Plots in `</path/to/disk>/<subdir>`

## Example
   
   Delete enough Plots in disks mounted in /media/root/ to make sure that x amount of disks each have y G free space (set x/y values in the variables section in the script)
   ```bash
   ./plot_over --mount-dir /media/root
   ```

   Delete enough Plots in disks labelled with the pattern CHIA to make sure that x amount of disks each have y G free space. Process only Plots in (/path/to/DISK/gigahorse. (set x/y values in the variables section in the script)
   ```bash
   ./plot_over --label CHIA --subdir gigahorse
   ```

   Same as above, but do not actually delete anything. Just show what would happen.
   ```bash
   ./plot_over --dry-run --label CHIA --subdir gigahorse
   ```
