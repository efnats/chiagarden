# Plotover
## Chia Replot Helper

## Description

This script monitors the free space of Chia plot disks and automatically removes older plots when the free space falls below a specified threshold. The script aims to maintain a desired number of disks with at least the specified minimum free space.

## Requirements

- Bash shell
- The script assumes that your Chia plots are stored on mounted disks with a specific label format (e.g., CHIA-).

## Usage

1. Open the script in a text editor and set the following variables according to your setup:

   - `chiadisks_mountpoint`: mount point of Chia disks (e.g., /media/root)
   - `min_free_space`: minimum free space in GB (e.g., 100)
   - `plot_patterns`: array of plot patterns to search for
   - `replot_levels`: comma-separated list of plot_pattern indices to be removed
   - `amount_free_disks`: desired number of disks with minimum free space (e.g., 10)
   - `interval`: rescan interval in seconds (default is 30 seconds)
   
2. Save the script and make it executable by running:

   - `chmod +x plotover`

3. Run the script:

   - `./plotover`


