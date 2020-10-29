# Base image can be specified by --build-arg IMAGE_ARCH= ; defaults to debian:stretch
ARG IMAGE_ARCH=debian:buster
FROM ${IMAGE_ARCH}

ENV DEBIAN_FRONTEND=noninteractive
ARG VERSION=2.4.13
ENV VERSION ${VERSION}
ARG ARCH=amd64
ARG QEMU_ARCH
ENV FILE urbackup-server_${VERSION}_${ARCH}.deb
ENV URL https://hndl.urbackup.org/Server/${VERSION}/${FILE}

# Copy the entrypoint-script and the emulator needed for autobuild function of DockerHub
COPY entrypoint.sh qemu-${QEMU_ARCH}-static* /usr/bin/
ADD ${URL} /root/${FILE}

# Install UrBackup-server
RUN apt-get update \
        && echo "urbackup-server urbackup/backuppath string /backups" | debconf-set-selections \
        && echo "/var/urbackup" | apt-get install -y --no-install-recommends /root/${FILE} btrfs-tools \
        && rm /root/${FILE} \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Backing up www-folder
RUN mkdir /web-backup && cp -R /usr/share/urbackup/* /web-backup
# Making entrypoint-script executable
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 55413
EXPOSE 55414
EXPOSE 55415
EXPOSE 35623/udp

# /usr/share/urbackup will not be exported to a volume by default, but it still can be bind mounted
VOLUME [ "/var/urbackup", "/var/log", "/backups" ]
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["run"]
