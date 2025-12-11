# ChiaGarden 🌱

A Linux toolkit for managing large-scale Chia farms.

## The Problem

Managing a Chia farm with 30, 50, or 100+ HDDs gets messy fast:

- **Mount paths everywhere** – Keeping track of dozens of mount points is tedious
- **Drives come and go** – A failed or removed drive breaks scripts and configs
- **Manual formatting takes forever** – Preparing 20 new drives one by one is painful
- **No unified view** – Your plots are scattered across many filesystems

## The Solution: Label-Based Drive Management

ChiaGarden uses **drive labels** as the single source of truth. Every drive gets a unique, permanent label based on its serial number (e.g., `CHIA-WD40EZAZ`). All tools reference drives by label pattern—not by device name or mount path.

**The foundation:**

1. **[chiainit](chiainit/)** – Label existing drives, or mass-format new ones. Uses serial numbers for unique labels.
2. **[gardenmount](gardenmount/)** – Mount/unmount all `CHIA-*` drives with one command, combine via mergerfs, recover slack space

Once your drives are labeled and mounted, every other tool "just works"—they all speak the same label-based language.

## Quick Start

```bash
# Install
git clone https://github.com/efnats/chiagarden.git
cd chiagarden && sudo ./install.sh

# Label existing drives (keeps data intact)
chiainit --label-only sda sdb sdc sdd

# Or: format and label new drives (destructive!)
chiainit --fstype xfs --init sda sdb sdc sdd

# Mount everything
gardenmount --mount --label CHIA --mergerfs
```

## All Tools

| Tool | Purpose |
|------|---------|
| [chiainit](chiainit/) | Label drives by serial number (optionally format) |
| [gardenmount](gardenmount/) | Mount by label, mergerfs union, slack space recovery |
| [taco_list](taco_list/) | List drives by label—used internally by other tools |
| [plotsink](plotsink/) | Receive plots over network via [`chia_plot_sink`](https://github.com/madMAx43v3r/chia-plot-sink) |
| [plot_over](plot_over/) | Delete old plots to keep N drives free for replotting |
| [plot_starter](plot_starter/) | Wrapper for MadMax CUDA plotter with config and auto-recovery |
| [plot_timer](plot_timer/) | Parse plotter logs, show phase times and throughput |
| [plot_counter](plot_counter/) | Count plots by compression level, show farm size |
| [plot_mover](plot_mover/) | Simple plot mover (for small setups) |
| [plot_cleaner](plot_cleaner/) | Remove stale `.plot.tmp` files |
| [cropgains](cropgains/) | Track XCH rewards and profit (with electricity costs) |

## How the Pieces Fit Together

```
┌─────────────────────────────────────────────────────────────────┐
│                        DRIVE MANAGEMENT                         │
│  chiainit ──▶ Label drives ──▶ gardenmount ──▶ /mnt/garden/     │
└─────────────────────────────────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        ▼                           ▼                           ▼
┌───────────────┐         ┌─────────────────┐         ┌─────────────────┐
│   PLOTTING    │         │   REPLOTTING    │         │   MONITORING    │
│               │         │                 │         │                 │
│ plot_starter  │         │ plot_over       │         │ plot_counter    │
│ plot_timer    │         │ plotsink        │         │ cropgains       │
│ plot_cleaner  │         │ taco_list       │         │                 │
└───────────────┘         └─────────────────┘         └─────────────────┘
```

## The Mounting System

ChiaGarden creates a unified view of all your storage:

```
/media/$USER/CHIA-*/     Individual drive mounts (by label)
         │
         ├──▶ /mnt/slack/       Recovered space from partially-filled drives (btrfs raid0)
         │
         └──▶ /mnt/garden/      mergerfs union of all drives + slack
```

Your plotting tools write to `/mnt/garden/`—mergerfs distributes files across all available drives automatically.

## Systemd Services

Most tools come with systemd services for 24/7 operation:

```bash
sudo systemctl enable --now gardenmount.service
sudo systemctl enable --now plotsink.service
sudo systemctl enable --now plot_over.service
```

## Requirements

- Linux (tested on Ubuntu/Debian)
- For plotting: [Gigahorse CUDA plotter](https://github.com/madMAx43v3r/chia-gigahorse)
- For network plot receiving: [`chia_plot_sink`](https://github.com/madMAx43v3r/chia-plot-sink)

## License

MIT
