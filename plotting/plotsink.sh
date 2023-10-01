#!/bin/bash

# Define variables

dest_disks=$(df -h | grep "^/dev/.*CHIA-" | awk '{print $6"/gigahorse/"}' ORS=' ')


# Run the chia_plot_sink command in the background with the destination directory
/usr/local/bin/chia_plot_sink -- $dest_disks
echo $dest_disks