# 🌱 ChiaGarden

**Linux toolkit for managing large-scale Chia farms.**

Format, label, mount, and manage hundreds of drives without typing a single disk path.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/Shell-Bash-blue.svg)]()

---

## The Problem

Managing a Chia farm means dealing with dozens or hundreds of hard drives. Typing `/dev/sdxx` paths is tedious and error-prone. Keeping track of mounts, plots, and disk health becomes a nightmare.

## The Solution

ChiaGarden labels your drives with a pattern like `CHIA-WD40EZAZ` (using the serial number), then handles everything based on that label. Mount all drives with one command. Count plots across all disks. Automate replotting. No more path juggling.

---

## Quick Start

```bash
git clone https://github.com/efnats/chiagarden.git
cd chiagarden
sudo ./install.sh
```

Then initialize your drives:

```bash
# List available drives
sudo chiainit --list

# Label drives (non-destructive, keeps your plots!)
sudo chiainit --label-only

# Mount all labeled drives
sudo gardenmount --mount --label CHIA
```

---

## How Mounting Works

ChiaGarden uses a label-based mounting system combined with mergerfs to make your farm appear as a single filesystem.

### Step 1: Individual Mounts

When you run `gardenmount --mount --label CHIA`, every drive matching `CHIA-*` gets mounted to its own directory:

```
/media/user/
├── CHIA-WD40EZAZ/     # 18TB drive
├── CHIA-ST8000DM/     # 8TB drive
├── CHIA-TOSHIBA01/    # 16TB drive
└── ...
```

### Step 2: Slack Space

Chia plots are fixed-size (~108GB for k32). An 18TB drive fits 166 plots but has ~180GB leftover – unusable for plots, but not for other data.

The `--slack` option creates a `slack.img` file on each drive's remaining space, combines them via loop devices into a btrfs raid0, and mounts it:

```
/mnt/slack/            # Combined slack space from all drives
```

### Step 3: Unified View with mergerfs

With `--mergerfs`, gardenmount creates a mergerfs mount that combines **everything** – all individual drives plus the slack space – into one unified filesystem:

```
/mnt/garden/           # All drives + slack as one filesystem
```

This is where your plotter writes to. ChiaGarden distributes files across drives automatically.

### Example Setup

```bash
# Mount everything: individual drives, slack, then merge it all
sudo gardenmount --mount --label CHIA --mergerfs --slack

# Result:
# /media/user/CHIA-*/     Individual drives
# /mnt/slack/             Leftover space combined (btrfs raid0)
# /mnt/garden/            Everything merged (HDDs + slack)
```

---

## Tools

| Tool | Description |
|------|-------------|
| **chiainit** | Format and label drives with a consistent naming pattern |
| **gardenmount** | Mount/unmount drives by label prefix. Includes systemd service |
| **plot_starter** | Automate plotting on boot |
| **plotsink** | Receive plots over network (wraps MadMax's chia_plot_sink) |
| **plot_mover** | Move completed plots to destination drives |
| **plot_over** | Replace old plots with new ones |
| **plot_counter** | Count plots across all drives |
| **plot_cleaner** | Remove incomplete/invalid plots |
| **plot_timer** | Monitor plotting performance |
| **cropgains** | Track farming rewards and performance |
| **taco_list** | List drives and pipe to other commands |

Each tool has its own README with detailed usage in its directory.

---

## Two Operating Modes

Already have custom disk labels? No problem. All tools support two modes:

```bash
# By label pattern (recommended)
gardenmount --mount --label CHIA

# By mount directory
gardenmount --mount --mount-dir /mnt/chia
```

---

## Requirements

- Ubuntu 20.04+ (other Debian-based distros should work)
- Root access for disk operations
- Python 3 (for cropgains)

The installer handles all dependencies including mergerfs.

---

## Systemd Services

ChiaGarden includes service files for automation:

| Service | Purpose |
|---------|---------|
| `gardenmount.service` | Auto-mount drives on boot |
| `plot_starter.service` | Start plotting on boot |
| `plotsink.service` | Run plot sink server on port 1337 |
| `plot_over.service` | Continuous replotting |

Enable with: `sudo systemctl enable gardenmount.service`

---

## Contributing

Issues and PRs welcome! 

- [GitHub Issues](https://github.com/efnats/chiagarden/issues)
- [Chia Forum Thread](https://chiaforum.com/t/chiagarden-a-toolkit-for-post-farming-on-linux/20919)

---

## License

MIT – see [LICENSE](LICENSE)
