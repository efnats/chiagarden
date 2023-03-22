# Chia Plot Counter

## Description

This script is designed to count Chia plots on multiple disks and calculate their total size in TiB (tebibytes). The script will scan mounted disks at a specified interval and display the count and size of plots found for each pattern. The results are displayed in a table format in the terminal.

## Requirements

- Bash shell
- The script assumes that your Chia plots are stored on mounted disks with a specific label format (e.g., CHIA-).

## Usage

1. Open the script in a text editor and set the following variables according to your setup:

   - `interval`: rescan interval in seconds (default is 120 seconds)
   - `chiadisks_mount`: mount point of Chia disks (e.g., /media/root)
   - `chiadisks_label`: label prefix for Chia disks (e.g., CHIA-)

2. Save the script and make it executable by running:

`chmod +x plotcounter`

