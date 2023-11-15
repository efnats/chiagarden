# Changelog

## Unreleased

### Chiagarden Changes

- **plot_counter**: 
  - Don't display zero amount of plots to avoid division by zero. [efnats]
  - New metrics: eTiB, Plots/Second (per Period) [efnats]
  - Found a tiny bug while posting at chiaforum.com - fixed. [efnats]
  - Bugfix: disk amount reported incorrectly. [efnats]
  - Added support for directory based and label based scanning. [efnats]
  - Add data and plots written counter. [efnats]
  - Removed older version. [efnats]
  - Commandline parameters added. [efnats]
  - Added plot_counter. [efnats]

- **plot_cleaner**: 
  - Added plot_cleaner: A script that cleans up your `-d` directory from unfinished plot files. [efnats]

- **plot_mover**: 
  - Use rsync's built-in logging rather than our own. [efnats]
  - Added plot_mover. [efnats]

- **plot_over**: 
  - Optimized logging for when run as a systemd service. Plot_over.service file included. Can now read config from `plot_over.config`. Location default: `/etc/chiagarden`, `~/.config/chiagarden/` or `./` [efnats]
  - Add support for Gigahorse compression 11-15 and Bladebit. [efnats]
  - Be more verbose about reasons not to remove more plots. [efnats]
  - Added timestamps and logging, respect immutable flag. [efnats]
  - Added check-routine for duf-utility. [efnats]
  - Refactor of the entire code for better readability. Better plot processing. Bug fixes and some new debug options. [efnats]
  - Added `--dry-run` mode. [efnats]

- **plot_starter**: 
  - Bugfix: wrong directories assignment. [efnats]
  - Now supports all available options from cuda_plot for its configuration. [efnats]
  - Added plot_starter. [efnats]

- **plot_timer**: 
  - Added `--interval` command line argument. [efnats]
  - New polished look, added total transfer amount and average speed. [efnats]
  - Grouping by compression level added. [efnats]
  - More comprehensive displays for plot timer shows average for phase 1-4 now. [efnats]
  - Calculation of MB/s data written per period added. [efnats]
  - Renamed to plot_timer. [efnats]
  - Introduced calculation of plot amount which your earnings corresponds to (should-be plots) [efnats]
  - Added script plot_avg: Calculate plotting speed per harvester. [efnats]

- **analyze_lookup**: 
  - Added analyze_lookup: A tool to analyze lookup times. [efnats]

- **cropgains**: 
  - Major refactor. Added more metrics. Better appearance. [efnats]
  - Timezone info. [efnats]
  - Bugfix: calculation of 24hrs was wrong. [efnats]
  - Added correct interpreter. [efnats]
  - Added script - A chia profits monitoring tool. [efnats]
  
- **chiainit**: 
  - Added support for overlapping drive ranges sda-sdaz etc. [efnats]
  - Support for drive ranges added. Overlapping ranges (eg sdz-sdaa) not yet supported. [efnats]
  - Removed dd (wipefs is sufficient) [efnats]
  - Added option `--all` and `--exclude` for drive selection method. [efnats]
  - In case of unknown serialnr uuid is being used now [efnats]
  - Label function will now autodetect fstype. [efnats]
  - Added warning to discourage use of NTFS-3G for Windows. [efnats]
  - Bugfix - Labelling function was broken. Removed all spinners as a temporary solution. [efnats]
  - Added option to print mount entries for copy/pasting in fstab. [efnats]
  - Added chiainit. [efnats]

- **composerize**: 
  - Add hostname, lanip, docker, timezone to env. [efnats]
  - Full path of compose file was missing. [efnats]
  - Added machinaris folder, added composerize. [efnats]

- **gardenmount**: 
  - Improve Disk Space Validation to account for min_size allowed in btrfs (131MB) [efnats]
  - Updated unmount_slack() now recognizes user defined mount point. [efnats]
  - Add feature to utilize slack space on HDDs. [efnats]
  - Clean up mountdirs upon unmounting. [efnats]
  - Renamed chiamount to gardenmount. Path variable can now be directly passed to the `--mount` argument. [efnats]
  - Added chiamount. [efnats]

- **install.sh**: 
  - Tidied up the installer, added function to check against installed systemds files. [efnats]
  - Introduced migration function. [efnats]
  - Automatically download the latest version of mergerfs from github or fall back to package maintainers version. [efnats]
  - Installer downloads from madmax repo now. [efnats]
  - Nicer UI for installer. [efnats]
  - Updated installer to account for new systemd services. [efnats]
  - We have an installer script! [efnats]

- **plotsink**: 
  - plotsink.service Should wait for garden-mount before running. [efnats]
  - Using taco_list now to generate list of drives. [efnats]
  - Added plotsink.sh. [efnats]

- **taco_list**: 
  - Added format option csv. [efnats]
  - Fixed and improved. This went broken in commit 0f82d01 unnoticed. [efnats]
  - Added taco_list. [efnats]

- **other**: 
  - CHIA is now the default label for plot_over and plot_mover. Please consider relabelling your drives. [efnats]
