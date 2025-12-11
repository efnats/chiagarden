# Changelog

All notable changes to ChiaGarden will be documented in this file.

## [2.0.0] - 2025-01-XX

Major release with improved tooling, documentation, and user experience.

### Added

- **chiainit**: `--list` to show drives with labels, filesystem, serial numbers
- **chiainit**: `--smart` option for SMART data (temp, hours, reallocated sectors)
- **chiainit**: `--dry-run` to preview operations without making changes
- **chiainit**: Progress counter `[1/32]` and completion summary
- **chiainit**: Optional logging with `--log [FILE]`
- **gardenmount**: `--list` to show status of drives, MergerFS, and slack
- **gardenmount**: Version display
- **install.sh**: Interactive menu with Core/Plotting/Full/Uninstall options
- **install.sh**: Welcome screen with ASCII logo
- **install.sh**: Optional logging with `--log [FILE]`
- **Documentation**: Comprehensive README for all 11 tools with cross-references

### Changed

- **chiainit**: Restructured help text (Actions/Options sections)
- **gardenmount**: `--print-fstab` now works with `--list` instead of `--mount`
- **gardenmount**: Restructured help text (Actions/Options sections)
- **gardenmount**: Unified output formatting
- **install.sh**: Complete rewrite with better system detection

### Fixed

- **chiainit**: Partition timing issue (device not ready after parted)
- **chiainit**: `--init` failure tracking (was always showing success)

---

## [1.0.0] - Previous releases

### chiainit
- Added support for overlapping drive ranges sda-sdaz etc.
- Support for drive ranges added
- Removed dd (wipefs is sufficient)
- Added option `--all` and `--exclude` for drive selection
- UUID fallback for unknown serial numbers
- Label function autodetects fstype
- Added warning for NTFS-3G on Windows

### gardenmount
- Improve Disk Space Validation for btrfs min_size (131MB)
- Updated unmount_slack() recognizes user defined mount point
- Add slack space feature for HDDs
- Clean up mountdirs upon unmounting
- Renamed chiamount to gardenmount

### plot_counter
- New metrics: eTiB, Plots/Second
- Support for directory and label based scanning
- Data and plots written counter
- Command line parameters

### plot_over
- Systemd service support with config file
- Support for Gigahorse compression 11-15 and Bladebit
- Timestamps and logging, respect immutable flag
- `--dry-run` mode

### plot_starter
- Full cuda_plot options support

### plot_timer
- `--interval` command line argument
- Grouping by compression level
- Average for phase 1-4

### cropgains
- Major refactor with more metrics
- Timezone info

### plotsink
- Using taco_list to generate drive list

### taco_list
- CSV format option

### install.sh
- Migration function
- Auto-download latest mergerfs from GitHub
