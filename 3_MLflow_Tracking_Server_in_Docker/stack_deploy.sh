#!/bin/sh -eu

# We have two separate .env files, one for regular env variables and the other for secrets in env variables (which is not pushed to any repo).
# Using this kind of script we can load as many .env files as we need before getting up the applicatio stack.

set -a
. .env
. .secrets/env-secrets

docker compose up -d

# Variables are now picked up using source from .env and .env-secrets, exported, and then are available for substitution in the compose file for docker.

# alternativelly, directly in the shell:

# $ set -a && . .env && . .env-secrets && set +a
# $ docker compose up -d

# 'set -a' adds the export attribute to every variable that is created in the shell session. 'set +a' restores the default behavior.


# ======================================================================================================================
# Start mlflow server container stack with:
# ======================================================================================================================

# $ source ./stack_deploy
# [+] Running 5/5
#  ⠿ Network 2_mlflow_backend_and_artifact_storage_scenarios_1_2_and_3_default           Created                                                                                         0.1s
#  ⠿ Volume "2_mlflow_backend_and_artifact_storage_scenarios_1_2_and_3_database_volume"  Created                                                                                         0.0s
#  ⠿ Container mlflow_mysql_3307                                                         Started                                                                                         0.9s
#  ⠿ Container mlflow_tracker_5007                                                       Started                                                                                         1.6s
#  ⠿ Container mlflow_phpmyadmin_8087                                                    Started


# ======================================================================================================================
# Logged info in for mlflow_tracker_5007 container in Docker Desktop:
# ======================================================================================================================

# 2023-03-26 13:10:13 2023/03/26 11:10:13 WARNING mlflow.store.db.utils: SQLAlchemy engine could not be created. The following exception is caught.
# 2023-03-26 13:10:13 (pymysql.err.OperationalError) (2003, "Can't connect to MySQL server on 'mysql' ([Errno 111] Connection refused)")
# 2023-03-26 13:10:13 (Background on this error at: https://sqlalche.me/e/20/e3q8)
# 2023-03-26 13:10:13 Operation will be retried in 3.1 seconds
# 2023-03-26 13:10:17 2023/03/26 11:10:17 WARNING mlflow.store.db.utils: SQLAlchemy engine could not be created. The following exception is caught.
# 2023-03-26 13:10:17 (pymysql.err.OperationalError) (2003, "Can't connect to MySQL server on 'mysql' ([Errno 111] Connection refused)")
# 2023-03-26 13:10:17 (Background on this error at: https://sqlalche.me/e/20/e3q8)
# 2023-03-26 13:10:17 Operation will be retried in 6.3 seconds
# 2023-03-26 13:10:23 2023/03/26 11:10:23 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023-03-26 13:10:23 2023/03/26 11:10:23 INFO mlflow.store.db.utils: Updating database tables
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade  -> 451aebb31d03, add metric step
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 451aebb31d03 -> 90e64c465722, migrate user column to tags
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 90e64c465722 -> 181f10493468, allow nulls for metric values
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 181f10493468 -> df50e92ffc5e, Add Experiment Tags Table
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade df50e92ffc5e -> 7ac759974ad8, Update run tags with larger limit
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 7ac759974ad8 -> 89d4b8295536, create latest metrics table
# 2023-03-26 13:10:23 INFO  [89d4b8295536_create_latest_metrics_table_py] Migration complete!
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 89d4b8295536 -> 2b4d017a5e9b, add model registry tables to db
# 2023-03-26 13:10:23 INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Adding registered_models and model_versions tables to database.
# 2023-03-26 13:10:23 INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Migration complete!
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 2b4d017a5e9b -> cfd24bdc0731, Update run status constraint with killed
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade cfd24bdc0731 -> 0a8213491aaa, drop_duplicate_killed_constraint
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 0a8213491aaa -> 728d730b5ebd, add registered model tags table
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 728d730b5ebd -> 27a6a02d2cf1, add model version tags table
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 27a6a02d2cf1 -> 84291f40a231, add run_link to model_version
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 84291f40a231 -> a8c4a736bde6, allow nulls for run_id
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade a8c4a736bde6 -> 39d1c3be5f05, add_is_nan_constraint_for_metrics_tables_if_necessary
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 39d1c3be5f05 -> c48cb773bb87, reset_default_value_for_is_nan_in_metrics_table_for_mysql
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade c48cb773bb87 -> bd07f7e963c5, create index on run_uuid
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade bd07f7e963c5 -> 0c779009ac13, add deleted_time field to runs table
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade 0c779009ac13 -> cc1f77228345, change param value length to 500
# 2023-03-26 13:10:23 INFO  [alembic.runtime.migration] Running upgrade cc1f77228345 -> 97727af70f4d, Add creation_time and last_update_time to experiments table
# 2023-03-26 13:10:24 INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# 2023-03-26 13:10:24 INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023-03-26 13:10:24 2023/03/26 11:10:24 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023-03-26 13:10:24 2023/03/26 11:10:24 INFO mlflow.store.db.utils: Updating database tables
# 2023-03-26 13:10:24 INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# 2023-03-26 13:10:24 INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023-03-26 13:10:24 [2023-03-26 11:10:24 +0000] [23] [INFO] Starting gunicorn 20.1.0
# 2023-03-26 13:10:24 [2023-03-26 11:10:24 +0000] [23] [INFO] Listening at: http://0.0.0.0:5000 (23)
# 2023-03-26 13:10:24 [2023-03-26 11:10:24 +0000] [23] [INFO] Using worker: sync
# 2023-03-26 13:10:24 [2023-03-26 11:10:24 +0000] [24] [INFO] Booting worker with pid: 24
# 2023-03-26 13:10:24 [2023-03-26 11:10:24 +0000] [25] [INFO] Booting worker with pid: 25
# 2023-03-26 13:10:24 [2023-03-26 11:10:24 +0000] [26] [INFO] Booting worker with pid: 26
# 2023-03-26 13:10:24 [2023-03-26 11:10:24 +0000] [27] [INFO] Booting worker with pid: 27


# ======================================================================================================================
# Debug info:
# ======================================================================================================================

# Open terminal in the mlflow_tracker_5007 container and run 'ps fax':

# $ ps fax
#
# PID TTY      STAT   TIME COMMAND
#  88 pts/0    Ss     0:00 /bin/sh
#  94 pts/0    R+     0:00  \_ ps fax
#   1 ?        Ss     0:00 /bin/sh -c mlflow server --backend-store-uri ${BACKEND_STORE_URI} --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} --host 0.0.0.0 --port 5000
#   7 ?        Sl     0:02 /usr/local/bin/python /usr/local/bin/mlflow server --backend-store-uri mysql+pymysql://mlflow_user1:Passw0rd@mysql:3306/mlflow_db --default-artifact-r
#  23 ?        S      0:00  \_ /usr/local/bin/python /usr/local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#  24 ?        Sl     0:01      \_ /usr/local/bin/python /usr/local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#  25 ?        Sl     0:01      \_ /usr/local/bin/python /usr/local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#  26 ?        Sl     0:01      \_ /usr/local/bin/python /usr/local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#  27 ?        Sl     0:01      \_ /usr/local/bin/python /usr/local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app