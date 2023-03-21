# ChiaInit

ChiaInit is a bash script that helps you prepare and manage hard drives for PoST (Proof of Space and Time) farming. It automates the process of wiping, formatting, and labeling multiple drives at once, making it easy to set up and maintain your Chia farming storage.
Drives are automatically labelled with the pattern CHIA-[Serialnr]. Many other scripts in this repo rely on drives labelled in this fashion so they be identified as CHIA drives.

## Features

- Wipe drives
- Format drives with xfs, ext4, or ntfs filesystems
- Label drives with custom prefixes
- Initialize drives (wipe, format, and label)

## Requirements

- xfsprogs
- smartmontools
- ntfs-3g

## Usage
<pre>
Usage: chiainit [OPTIONS] drive1 drive2 ... driveN
Example: chiainit --fstype ext4 --init sdb sdc

Options
--help: Show help text
--wipe: Wipe the specified drives
--format: Format the specified drives (requires --fstype)
--label: Label the specified drives (requires --fstype and --label-prefix)
--init: Wipe, format, and label the specified drives (requires --fstype and --label-prefix)
--fstype [xfs|ext4|ntfs]: Specify the filesystem type
--label-prefix PREFIX: Specify a custom prefix for the drive labels (default: CHIA)
</pre>

## Contributing
If you have suggestions for improvements or bug fixes, please feel free to submit a pull request or create an issue.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
