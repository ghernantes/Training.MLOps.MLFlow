#!bin/bash

#set -euo pipefail

# Inspect the container and get all info we need -----------------------------------------------------------------------------------------

# $ docker container list -a
# CONTAINER ID   IMAGE                                   COMMAND                  CREATED          STATUS         PORTS                                              NAMES
# b1cda594b992   phpmyadmin:latest                       "/docker-entrypoint.…"   10 seconds ago   Up 8 seconds   0.0.0.0:8082->80/tcp                               passbolt_phpmyadmin_8082
# 16b306590781   passbolt/passbolt:3.8.3-1-ce-non-root   "/usr/bin/wait-for.s…"   10 seconds ago   Up 8 seconds   0.0.0.0:8080->8080/tcp, 0.0.0.0:443->4433/tcp      passbolt_8080
# 22464ed938da   mariadb:10.3                            "docker-entrypoint.s…"   10 seconds ago   Up 9 seconds   0.0.0.0:3306->3306/tcp, 0.0.0.0:33060->33060/tcp   passbolt_mysql_3306

# $ docker inspect -f '{{ .Mounts }}' passbolt_mysql_3306
# [{bind  /home/gustavo/training/Training.Docker/2.WebServices/3.Passbolt/Ex0_Passbolt/db/.secrets/mysql-passboltuser-password.txt /run/secrets/password2   false rprivate} {volume ex0_passbolt_database_volume /var/lib/docker/volumes/ex0_passbolt_database_volume/_data /var/lib/mysql local z true } {bind  /run/desktop/mnt/host/wsl/docker-desktop-bind-mounts/Ubuntu/aa3dc3b9bd3cf754fc9b982f96d072b7f72ebd4f0e4d48f104082da73a73c767 /run/secrets/password1   false rprivate}]

# $ docker inspect passbolt_mysql_3306 | grep -A 10 Mounts
# "Mounts": [
#                 {
#                     "Type": "bind",
#                     "Source": "/home/gustavo/training/Training.Docker/2.WebServices/3.Passbolt/Ex0_Passbolt/db/.secrets/mysql-passboltuser-password.txt",
#                     "Target": "/run/secrets/password2",
#                     "ReadOnly": true
#                 },
#                 {
#                     "Type": "volume",
#                     "Source": "ex0_passbolt_database_volume",
#                     "Target": "/var/lib/mysql",
#                     "VolumeOptions": {}
#                 },
#                 {
#                     "Type": "bind",
#                     "Source": "/run/desktop/mnt/host/wsl/docker-desktop-bind-mounts/Ubuntu/aa3dc3b9bd3cf754fc9b982f96d072b7f72ebd4f0e4d48f104082da73a73c767",
#                     "Target": "/run/secrets/password1",
#                     "ReadOnly": true
#                 }
#             ],
# --
        # "Mounts": [
        #     {
        #         "Type": "bind",
        #         "Source": "/home/gustavo/training/Training.Docker/2.WebServices/3.Passbolt/Ex0_Passbolt/db/.secrets/mysql-passboltuser-password.txt",
        #         "Destination": "/run/secrets/password2",
        #         "Mode": "",
        #         "RW": false,
        #         "Propagation": "rprivate"
        #     },
        #     {
        #         "Type": "volume",
        #         "Name": "ex0_passbolt_database_volume",
        #         "Source": "/var/lib/docker/volumes/ex0_passbolt_database_volume/_data",
        #         "Destination": "/var/lib/mysql",
        #         "Driver": "local",
        #         "Mode": "z",
        #         "RW": true,
        #         "Propagation": ""
        #     },
        #     {
        #         "Type": "bind",
        #         "Source": "/run/desktop/mnt/host/wsl/docker-desktop-bind-mounts/Ubuntu/aa3dc3b9bd3cf754fc9b982f96d072b7f72ebd4f0e4d48f104082da73a73c767",
        #         "Destination": "/run/secrets/password1",
        #         "Mode": "",
        #         "RW": false,
        #         "Propagation": "rprivate"
        #     }
        # ],

# $ docker volume list
# DRIVER    VOLUME NAME
# local     ex0_passbolt_database_volume
# local     ex0_passbolt_gpg_volume
# local     ex0_passbolt_jwt_volume


# Get the backup --------------------------------------------------------------------------------------------------------------------------

# Change the container name as needed:

docker run --rm \
           --volumes-from passbolt_mysql_3306 \
           -v $(pwd)/db/volumes_backups:/backup \
           ubuntu \
           bash -c "cd /var/lib/mysql && tar cvf /backup/ex0_passbolt_database_volume_backup_test_2023_02_07.tar ."

# Execute with: . ./db/db_volume_backup.sh


# Back up a volume How To ----------------------------------------------------------------------------------------------------------------

# Volumes are useful for backups, restores, and migrations. Use the --volumes-from flag to create a new container that mounts that volume.

# For example, create a new container named dbstore:

#  docker run -v /dbdata --name dbstore ubuntu /bin/bash

# In the next command:

#     Launch a new container and mount the volume from the dbstore container
#     Mount a local host directory as /backup
#     Pass a command that tars the contents of the dbdata volume to a backup.tar file inside our /backup directory.

# $ docker run --rm --volumes-from dbstore -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /dbdata

# When the command completes and the container stops, it creates a backup of the dbdata volume.