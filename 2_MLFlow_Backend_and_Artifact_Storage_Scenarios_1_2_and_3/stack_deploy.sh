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
# Start mlflow server container with:
# ======================================================================================================================

# $ source ./stack_deploy


# ======================================================================================================================
# Logged info in Docker Desktop:
# ======================================================================================================================

# 2023/03/03 16:26:10 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023/03/03 16:26:11 INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023/03/03 16:26:11 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023/03/03 16:26:11 INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# [2023-03-03 16:26:11 +0000] [58] [INFO] Starting gunicorn 20.1.0
# [2023-03-03 16:26:11 +0000] [58] [INFO] Listening at: http://0.0.0.0:5007 (58)
# [2023-03-03 16:26:11 +0000] [58] [INFO] Using worker: sync
# [2023-03-03 16:26:11 +0000] [59] [INFO] Booting worker with pid: 59
# [2023-03-03 16:26:11 +0000] [60] [INFO] Booting worker with pid: 60
# [2023-03-03 16:26:11 +0000] [61] [INFO] Booting worker with pid: 61
# [2023-03-03 16:26:11 +0000] [62] [INFO] Booting worker with pid: 62
# 2023/03/03 16:26:22 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023/03/03 16:26:22 INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023/03/03 16:26:38 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023/03/03 16:26:38 INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023/03/03 16:27:25 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023/03/03 16:27:25 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023/03/03 16:27:25 INFO mlflow.store.db.utils: Updating database tables
# 2023/03/03 16:27:25 INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.


# ======================================================================================================================
# Debug info:
# ======================================================================================================================

# Open terminal in the container and run 'ps fax':

# $ ps fax
#     PID TTY      STAT   TIME COMMAND
#     123 pts/0    Ss     0:00 /bin/sh
#     129 pts/0    R+     0:00  \_ ps fax
#       1 ?        Ss     0:00 /opt/conda/bin/python /opt/conda/bin/conda run --no-capture-output -n mlflow_env /bin/bash ./entrypoint.sh
#       7 ?        S      0:00 /bin/bash /tmp/tmp5me_gnrf
#      15 ?        Sl     0:02  \_ /home/mlflowuser/.conda/envs/mlflow_env/bin/python /home/mlflowuser/.conda/envs/mlflow_env/bin/mlflow server --backend-store-uri mysql+pymysql://mlflow_user1:Passw0rd@mys
#      58 ?        S      0:00      \_ /home/mlflowuser/.conda/envs/mlflow_env/bin/python /home/mlflowuser/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5007 -w 4 mlflow.server:app
#      59 ?        Sl     0:02          \_ /home/mlflowuser/.conda/envs/mlflow_env/bin/python /home/mlflowuser/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5007 -w 4 mlflow.server:app
#      60 ?        Sl     0:02          \_ /home/mlflowuser/.conda/envs/mlflow_env/bin/python /home/mlflowuser/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5007 -w 4 mlflow.server:app
#      61 ?        Sl     0:02          \_ /home/mlflowuser/.conda/envs/mlflow_env/bin/python /home/mlflowuser/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5007 -w 4 mlflow.server:app
#      62 ?        Sl     0:02          \_ /home/mlflowuser/.conda/envs/mlflow_env/bin/python /home/mlflowuser/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5007 -w 4 mlflow.server:app