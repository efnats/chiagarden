# ChiaGarden

ChiaGarden is a collection of sysprep tools designed to build, manage, and maintain a PoST (Proof of Space and Time) farm on a linux based system. These tools make it easy to prepare and mount your hard disks, manage and monitor your plots for your farm.

If you agree that typing disk paths is a job you shouldn't be doing, then this is for you. If you are already plotted and have no intention of reformatting anything, do read on: ChiaGarden will let you uniquely label drives with a certain pattern (for example CHIA-[SERIALNR]) which then which then facilitates subsequent processing.

And if you've already given out creative disk labels (Heinz, Hans and Franz, I guess) or if you think that changing disk labels may be destroying your plots (although that is not the case) here is good news, too
Most of the ChiaGarden tools offer you a choice between two operating modes:

`--label` search and process plots based on disk labels.
`--mount-dir` search and process plots based on mount points.

As long as your disks are mounted to the same mount point consistently, there's no distinction.

## chiainit

[chiainit](https://github.com/efnats/chiagarden/tree/main/chiainit) is a bash script for preparing hard drives for PoST farming. It automates the process of formatting and labeling multiple drives at once.

## gardenmount

[gardenmount](https://github.com/efnats/chiagarden/tree/main/gardenmount) is a script for (un)mounting drives based on a specified label prefix. Additionally, this repository provides systemd service files for managing the mounting and unmounting process.

## plotting

[plotting](https://github.com/efnats/chiagarden/tree/main/plotting) contains various scripts for managing, monitoring and automating the (re)plotting process.

## taco_list

[taco_list](https://github.com/efnats/chiagarden/tree/main/taco_list) is a simple wrapper script to list your destination disks and execute any command with the given parameters - for example chia_plot_sink

## cropgains

[cropgains](https://github.com/efnats/chiagarden/tree/main/cropgains) is a profitability monitoring tool for your Chia farming operation providing infos about revenue, cost and profit. It supports automatically extracting energy consumption info from tasmota devices.

## machinaris

[machinaris](https://github.com/efnats/chiagarden/tree/main/machinaris) this folder contains script(s) that help with the setup and installation of [Machinaris](https://www.machinaris.app/), specifically with the docker-compose setup. This part is currently mostly work in progress

## Getting Started

To get started with ChiaGarden, clone the repository, and run the installer script install.sh.

```bash
git clone https://github.com/efnats/chiagarden.git
cd chiagarden
sudo ./install.sh
```
The installer script will guide you through the installation process, copy necessary files, and optionally enable and start the garden-mount.service.

Once you have installed ChiaGarden, use it to ensure all drives containing plot files are labeled with a unique label pattern (default: CHIA-[serialnr]). The chiainit tool can be used to (re)label available drives in your system. Relabeling a drive is a non-destructive action and will not delete any data on the drive.

Refer to the instructions in each directory for further configuration and usage information.
## Contributing
Contributions to ChiaGarden are welcome. Feel free to submit pull requests or open issues to improve the tools and make them more useful for the Chia farming community.

## License
Chia Garden is released under the MIT License. See the LICENSE file for more information.


