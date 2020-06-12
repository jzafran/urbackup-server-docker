### This image is decrepit. Please use the official docker image by uroni: https://hub.docker.com/r/uroni/urbackup-server 

## Multiarch (amd64/armhf/arm64(aarch64)) docker images for UrBackup server.
Pulling the `:latest` tag should automatically grab the right image for your arch.

Most of the original code is based on the image by [Whatang](https://github.com/Whatang/docker_urbackup)


## Running

### If you want to use docker run command:
For `PGID` and `PUID` please enter the UID/GID of the user who should own the files outside the container.

```
docker run -d \
                --name urbackup \
                --restart unless-stopped \
                -e PUID=1000 \  
                -e PGID=100  \
                -e TZ=Europe/Berlin \
                -v /path/to/your/backup/folder:/backups \
                -v /path/to/your/database/folder:/var/urbackup \
                --network host \
                morlan/urbackup_docker:latest
```

For BTRFS-Support add `--cap-add SYS_ADMIN` to the command above

If you want to externally bind-mount the www-folder add `-v /path/to/wwwfolder:/usr/share/urbackup`

### Or via docker-compose (compatible with stacks in Portainer): 

`docker-compose.yml`
```
version: '2'

services:
  urbackup:
    image: morlan/urbackup_docker:latest
    container_name: urbackup
    restart: unless-stopped
    environment:
      - PUID=1000 # Enter the UID of the user who should own the files here
      - PGID=100  # Enter the GID of the user who should own the files here
      - TZ=Europe/Berlin # Enter your timezone
    volumes:
      - /path/to/your/database/folder:/var/urbackup
      - /path/to/your/backup/folder:/backups
      # Uncomment the next line if you want to bind-mount the www-folder
      #- /path/to/wwwfolder:/usr/share/urbackup
    network_mode: "host"
    # Activate the following two lines for BTRFS support
    #cap_add:
    #  - SYS_ADMIN   
  
```              
	     
After running the container Urbackup should be reachable on the web interface on port :55414	     

## Building locally
Please use the provided `build.sh` script:
```
./build.sh
```
On default the script will build a container for amd64 with version 2.4.11.

To build for other architectures the script accepts following argument:
`./build.sh [ARCH] [VERSION]`

`[ARCH]` can be `amd64`, `armhf` or `arm64`; `[Version]` can be an existing version of UrBackup-server

For example if you want to build an image for version 2.4.10 on armhf use the following command:
```
./build.sh armhf 2.4.10
```
