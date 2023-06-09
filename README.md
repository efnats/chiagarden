# ChiaGarden

ChiaGarden is a collection of tools designed to help you build, manage, and maintain a PoST (Proof of Space and Time) farm on a linux based system. These tools make it easy to prepare and mount your hard disks, and manage your plots for your farm.

If you agree that typing disk paths is a job you shouldn't be doing, then this is for you. chiagarden lets you uniquely label drives with a certain pattern (for example CHIA-[SERIALNR]) which then makes it very easy for later processing.

With that said, you don't have to (re)label your drives in order for these tools to function. Most of the tools in the repo let you chose between two operatin modes:
`--label` lets you search and process plots based on disks labelled.
`--mount-dir` lets you search and process plots based on mountpoints.
As long as your disks are mounted to the same mountpoint exclusively, there is absolutely no difference.

## chiainit

[chiainit](https://github.com/efnats/chiagarden/tree/main/chiainit) is a bash script that helps you prepare and manage hard drives for PoST farming. It automates the process of wiping, formatting, and labeling multiple drives at once, making it easy to set up and maintain your Chia farming storage.

## garden-mount

[garden-mount](https://github.com/efnats/chiagarden/tree/main/garden-mount) is a script for (un)mounting drives based on a specified label prefix. Additionally, this repository provides systemd service files for managing the mounting and unmounting process.

## plotting

[plotting](https://github.com/efnats/chiagarden/tree/main/plotting) contains various scripts for managing, monitoring and automating the (re)plotting process.

## taco_list

[taco_list](https://github.com/efnats/chiagarden/tree/main/taco_list) is a simple wrapper script to list your destination disks and execute any command with the given parameters - for example chia_plot_sink

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


