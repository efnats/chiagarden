# Chiagarden

Chiagarden is a collection of tools designed to help you build, manage, and maintain a Chia PoST (Proof of Space and Time) farm on a linux based system. These tools make it easy to prepare and mount your hard disks, and manage your plots for your farm.

Have you typed your individual disk paths one too many times? Plots missing? Are you just done with searching the one typo you made in fstab? If yes, then this is for you. The general concept is to uniquely label drives with a certain pattern (for example CHIA-[SERIALNR]) which then makes it very easy for later processing.

With that said, you can still use most of these tools without (re)labelling your drives. 

## chiainit

[chiainit](https://github.com/efnats/chiagarden/tree/main/chiainit) is a bash script that helps you prepare and manage hard drives for PoST farming. It automates the process of wiping, formatting, and labeling multiple drives at once, making it easy to set up and maintain your Chia farming storage.

## garden-mount

[garden-mount](https://github.com/efnats/chiagarden/tree/main/) is a script for (un)mounting drives based on a specified label prefix. Additionally, this repository provides systemd service files for managing the mounting and unmounting process.

## plotting

[plotting](https://github.com/efnats/chiagarden/tree/main/plotting) contains various scripts for managing, monitoring and automating the (re)plotting process.

## Getting Started

To get started with Chia Garden, clone the repository, and follow the instructions in each directory for setting up and configuring your Chia farm.

```bash
git clone https://github.com/efnats/chiagarden.git
cd chiagarden
```

## Contributing
Contributions to ChiaGarden are welcome. Feel free to submit pull requests or open issues to improve the tools and make them more useful for the Chia farming community.

## License
Chia Garden is released under the MIT License. See the LICENSE file for more information.


