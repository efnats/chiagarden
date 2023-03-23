# chiainit - mass preparation (wipe, format and label) of hard drives for PoST farming

ChiaInit is a bash script that helps you prepare and manage hard drives for PoST (Proof of Space and Time) farming. It automates the process of wiping, formatting, and labeling multiple drives at once, making it easy to set up and maintain your Chia farming storage.
Drives are automatically labelled with the pattern CHIA-[Serialnr].
Other tools in this repo rely on drives being labelled in this fashion so they can be identified as CHIA drives.

## Features

- Wipe drives
- Supports XFS, EXT4 and NTFS filesystems
- Label drives with custom prefixes
- Lots of safety questions before doing anything
- System drives (disks where any partition is mounted as /) are never processed

## Requirements

- smartmontools
- xfsprogs
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

## Example
```bash
./chiainit --fstype ext4 --init sdx sdy sdz sdaa sdab
```
This command will wipe, format (ext4) and label the given drives.

## Warning

While NTFS is generally supported via ntfs-3g it is highly discouraged to use any NTFS filesystem created on Linux for Windows.
Read [here](https://unix.stackexchange.com/questions/617400/can-linux-corrupt-the-data-on-an-ntfs-partition) for more info.
Thanks to @scrutinus and @limsandy for pointing me to this.

## Contributing
If you have suggestions for improvements or bug fixes, please feel free to submit a pull request or create an issue.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
