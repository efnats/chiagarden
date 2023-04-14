# composerize - automatically update docker-compose files for machinaris

This bash script will update configuration files for a Docker setup, specifically for a Machinaris. The script accepts input arguments for the mount directory or label and an optional subdirectory. It then finds the relevant devices and directories, generates an updated list of devices and directories for Chia and Gigahorse plots, and updates the .env file and docker-compose file accordingly.

This is to be seen as a middleware to automatically update docker-compose files depending on disks installed in the system. By reading out parameters from the system and writing them into a docker compatible .env file we manage to keep the compose file(s) static while dynamic variables can be written into the environment file. Referenced variables are 
written into the compose file in a docker style format. See https://docs.docker.com/compose/environment-variables/set-environment-variables/
Unfortunately the devices: section can not be referenced in the same fashion. Thats why we have to modify this section directly.

By splitting the various docker-compose sections for each fork into seperate files we are able to move unused files out of the main folder and have this tool automatically include in the .env file whatever compose file needs to be added to the setup.

Here is a more detailed rundown of the execution of the script

- Generate a list of devices based on the mount points found. This will be referenced in the `devices:` section of the docker compose file of machinaris
- Generate a list of directories for Chia plots based on the provided mount directory or label. This is referenced in the `volumes:` section of machinaris
- Generate the list of Docker compose files for the environment file to be included.
- Update the .env file with the new values for Chia and Gigahorse plots directories and the compose file list.
- Update the docker-compose file with the new list of devices.

Since this is currently work in progress in a highly customized setup I dont expect this to be useful for anyone at the moment.

## Usage

```bash
./composerize --mount-dir /path/to/dir
```
or
```bash
./composerize --label CHIA
```


