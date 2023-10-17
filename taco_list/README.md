# taco_list - a simple wrapper script for your chia mount points

A simple wrapper script to list your destination disks and execute any command with the given parameters. It will print a list of all your plotting mount points either in one line (default), or in a list format (`--format newline`). If redirected to a textfile this may be useful as input for various other tools, such as your docker-compose.yml (hello machinaris). Or you could directly pass the list to chia_plot_sink (example is in the configuration). Your imagination is the limit ;)

## Usage

```bash
./taco_list --mount-dir /path/to/dir [--subdir subdir_name] [--separator space|newline|csv]
```
or
```bash
./taco_list --label CHIA [--subdir subdir_name] [--separator space|newline|csv]
```

## Arguments

- `--mount-dir`: Specify the path to the directory where the disks are mounted.
- `--label`: Specify the label of the disks to be used. If both, mount-dir or label are ommited, this is the default with CHIA
- `--subdir`: (Optional) Specify a subdirectory inside each disk. Default is an empty string.
- `--separator`: (Optional) Specify the output separator for the list of destination directories. Available options are `newline`(default), `space` and `csv`.
- `--quotes`: (Optional) put each drives output in quotes
- `--command`: (Optional) Secify the command which will be put ahead of the listed drives. For example "/usr/local/bin/plot_sink --". Default: echo -e

## Example

To find disks mounted under `/media/root/` with a subdirectory named `gigahorse` and display their paths in a newline-separated format, run:

```bash
./taco_list --mount-dir /media/root --subdir gigahorse --format newline
```
