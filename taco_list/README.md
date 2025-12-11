# taco_list

List your Chia drives and output them in various formats. Useful for piping to other commands.

## Features

- **Label or path based** – Find drives by label pattern or mount directory
- **Flexible output** – Space, newline, or CSV separated
- **Subdirectory support** – Append a subdirectory to each path
- **Command execution** – Pipe output directly to another command

## Usage

```bash
# List drives by label (default: CHIA)
taco_list --label CHIA

# List drives in a directory
taco_list --mount-dir /mnt/plots

# Add subdirectory to each path
taco_list --label CHIA --subdir gigahorse

# Different output formats
taco_list --label CHIA --separator space
taco_list --label CHIA --separator newline
taco_list --label CHIA --separator csv

# Wrap paths in quotes
taco_list --label CHIA --quotes

# Execute a command with the disk list
taco_list --label CHIA --command "du -sh"
```

## Options

| Option | Description |
|--------|-------------|
| `--mount-dir PATH` | List directories under this path |
| `--label PATTERN` | Find drives with this label pattern (default: `CHIA`) |
| `--subdir NAME` | Append subdirectory to each path |
| `--separator TYPE` | Output format: `space`, `newline`, `csv` |
| `--quotes` | Wrap each path in quotes |
| `--command CMD` | Execute command with disk list as argument |

## Examples

### List all CHIA drives
```bash
$ taco_list --label CHIA
/media/user/CHIA-WD40EZAZ/
/media/user/CHIA-ST8000DM/
/media/user/CHIA-TOSHIBA01/
```

### Space-separated for commands
```bash
$ taco_list --label CHIA --separator space
/media/user/CHIA-WD40EZAZ/ /media/user/CHIA-ST8000DM/ /media/user/CHIA-TOSHIBA01/
```

### With subdirectory
```bash
$ taco_list --label CHIA --subdir plots
/media/user/CHIA-WD40EZAZ/plots
/media/user/CHIA-ST8000DM/plots
/media/user/CHIA-TOSHIBA01/plots
```

### Check disk usage
```bash
$ taco_list --label CHIA --command "df -h"
```

### Feed to [`chia_plot_sink`](https://github.com/madMAx43v3r/chia-plot-sink)
```bash
chia_plot_sink -- $(taco_list --label CHIA --subdir gigahorse --separator space)
```

## Use Cases

- Generate disk lists for [`chia_plot_sink`](https://github.com/madMAx43v3r/chia-plot-sink)
- Check free space across all farm drives
- Run maintenance commands on all drives
- Export drive list for scripts
