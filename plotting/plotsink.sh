#!/bin/bash

# use taco_list to retrieve list of disks
dest_disks=$(/usr/local/bin/taco_list --label CHIA --subdir gigahorse/ --separator space)

# Run the chia_plot_sink command in the background with the destination directory
/usr/local/bin/chia_plot_sink -- $dest_disks
echo $dest_disks