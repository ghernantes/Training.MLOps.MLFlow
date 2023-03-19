#!bin/bash

#set -euo pipefail

# Get the backup ------------------------------------------------------------------------------------------------------------------------------

# docker run --rm \
#            --volumes-from passbolt_mysql_3306 \
#            -v $(pwd)/db/volumes_backups:/backup \
#            ubuntu \
#            bash -c "cd /var/lib/mysql && tar cvf /backup/ex0_passbolt_database_volume_backup_test_2023_02_07.tar ."

# Execute with: . ./db/db_volume_backup.sh


# Restore the backup --------------------------------------------------------------------------------------------------------------------------

# Change the volume name as needed: database_volume2 --> ex0_passbolt_database_volume

docker run --rm \
           -v ex0_passbolt_database_volume:/dbdata \
           -v $(pwd)/db/.docker_volumes/mariadb_backups:/backup \
           ubuntu \
           bash -c "cd /dbdata && tar xvf /backup/ex2_passbolt_stack_database_volume_backup_2023_02_07.tar --strip 1 && ls -la"

# Execute with: . ./db/db_volume_restore.sh


# Restore volume from a backup How To --------------------------------------------------------------------------------------------------------

# With the backup just created, you can restore it to the same container, or to another container that you created elsewhere.

# For example, create a new container named dbstore2:

# $ docker run -v /dbdata --name dbstore2 ubuntu /bin/bash

# Then, un-tar the backup file in the new container’s data volume:

# $ docker run --rm \
#              --volumes-from dbstore2 \
#              -v $(pwd):/backup \
#              ubuntu bash -c "cd /dbdata && tar xvf /backup/backup.tar --strip 1"

# You can use the techniques above to automate backup, migration, and restore testing using your preferred tools.