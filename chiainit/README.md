# chiainit - mass preparation (wipe, format and label) of hard drives for PoST farming

chiainit is a bash script that helps you prepare and manage hard drives for PoST (Proof of Space and Time) farming. It automates the process of wiping, formatting, and labeling multiple drives at once, making it easy to set up and maintain your Chia farming storage.
Drives are automatically labelled with the pattern CHIA-[Serialnr].
Other tools in this repo rely on drives being labelled in this fashion so they can be identified as CHIA drives.

## Features

- Mass sysprep forChia farming
- Supports XFS, EXT4 and NTFS filesystems
- Label drives with custom prefixes
- Lots of safety questions before doing anything
- System drives (disks where any partition is mounted as /) are never processed
- Mounted drives are never processed
- Supports various methods for drive selection (-all, --exclude, drive ranges like sda-sdz)

## Requirements

- smartmontools
- xfsprogs
- ntfs-3g

## Usage
<pre>
Usage: chiainit [OPTIONS] [drive-range1] [drive-range2] [...] driveN
Example: chiainit --fstype ext4 --init sda-sdm sdq-sdx sdz

Options
--help: Show help text
--wipe: Wipe the specified drives
--format: Format the specified drives (requires --fstype)
--label: Label the specified drives
--init: Wipe, format, and label the specified drives (requires --fstype)
--fstype [xfs|ext4|ntfs]: Specify the filesystem type
--label-prefix PREFIX: Specify a custom prefix for the drive labels (default: CHIA)
--all: Operate on all spinning drives (excluding system drive and mounted drives)
--exclude [drive1 drive2]: Exclude the specified drives from the operation
</pre>

## Example

Wipe, format (ext4) and label the given drives using the label Pattern CHIA-[SERIALNR]
```bash
./chiainit --fstype ext4 --init sda-sdz
```

Wipe, format (ext4) and label all spinning drives using the label Pattern CHIA-[SERIALNR], exclude sdg sdh and sdi
```bash
./chiainit --fstype ext4 --init --all --exclude sdg sdh sdi
```

Label drives sda-sdz and sdaa-sdah with the pattern GIGA-[SERIALNR] (FSTYPE is auto-detected)
```bash
./chiainit --label --label-prefix GIGA sdx sdy sdz sdaa sdab
```

## Warning

While NTFS is generally supported via ntfs-3g it is highly discouraged to use any NTFS filesystem created on Linux for Windows.
Read [here](https://unix.stackexchange.com/questions/617400/can-linux-corrupt-the-data-on-an-ntfs-partition) for more info.
Thanks to @scrutinus and @limsandy for pointing me to this.

## Contributing
If you have suggestions for improvements or bug fixes, please feel free to submit a pull request or create an issue.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
