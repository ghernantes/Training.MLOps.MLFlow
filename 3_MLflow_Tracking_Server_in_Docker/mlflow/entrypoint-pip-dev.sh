#!/bin/bash

# Enable strict mode.
set -euo pipefail

# ======================================================================================================================
# Debug info:
# ======================================================================================================================

# ### This debug section can be deleted when building a production 'mlflow_tracker' image ###

echo "1. Basic OS info: --------------------------------------------------------------------"
echo "--> Host: ostype, osrelease, version ..."
#uname -a
cat /proc/sys/kernel/{ostype,osrelease,version}

echo "--> Container: /etc/os-release ..."
cat /etc/os-release | grep PRETTY_NAME
# apt install lsb-core
# lsb_release -d

echo "--> Running as ..."
whoami

echo "2. Checking system pip setup: --------------------------------------------------------"
echo "--> Checking system pip setup ..."
pip --version
echo "--> Pip installed packages ..."
pip list
echo "--> Which python and version ..."
which python && python --version
echo "--> Which mlflow ..."
mlflow --version

echo "3. Debug env variables: --------------------------------------------------------------"
echo "--> Checking env variables:"
printenv

# NOTE:
# All .env and .env-secret variables are loaded and exported in the first bash script executed: stack_deploy.sh,
# making them avalaible in the docker-compose.yml and entrypoint.sh files.

echo "4. Debug running procs: --------------------------------------------------------------"
echo "--> Checking procs:"
ps fax


# ======================================================================================================================
# exec the final command: mlflow server
# ======================================================================================================================

exec mlflow server --backend-store-uri mysql+pymysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql:3306/${MYSQL_DATABASE} \
                   --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} \
                   --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} \
                   --no-serve-artifacts \
                   --host 0.0.0.0 --port 5000
# NOTES:
# - Option 'default-artifact-root' is required when backend store is not local file based and artifact serving is disabled.
# - 'mysql' is the service name given to db in the docker-compose.yml file


# ======================================================================================================================
# DEBUGGED INFO:
# ======================================================================================================================

# 1. Basic OS info: --------------------------------------------------------------------
# --> Host: ostype, osrelease, version ...
# Linux
# 5.15.90.1-microsoft-standard-WSL2
# #1 SMP Fri Jan 27 02:56:13 UTC 2023
# --> Container: /etc/os-release ...
# PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
# --> Running as ...
# mlflowuser

# 2. Checking system pip setup: --------------------------------------------------------
# --> Checking system pip setup ...
# pip 23.0.1 from /usr/local/lib/python3.10/site-packages/pip (python 3.10)
# --> Pip installed packages ...
# Package            Version
# ------------------ ---------
# alembic            1.10.2
# certifi            2022.12.7
# charset-normalizer 3.1.0
# click              8.1.3
# cloudpickle        2.2.1
# contourpy          1.0.7
# cycler             0.11.0
# databricks-cli     0.17.6
# docker             6.0.1
# entrypoints        0.4
# Flask              2.2.3
# fonttools          4.39.3
# gitdb              4.0.10
# GitPython          3.1.31
# greenlet           2.0.2
# gunicorn           20.1.0
# idna               3.4
# importlib-metadata 6.1.0
# itsdangerous       2.1.2
# Jinja2             3.1.2
# joblib             1.2.0
# kiwisolver         1.4.4
# llvmlite           0.39.1
# Mako               1.2.4
# Markdown           3.4.3
# MarkupSafe         2.1.2
# matplotlib         3.7.1
# mlflow             2.2.1
# numba              0.56.4
# numpy              1.23.5
# oauthlib           3.2.2
# packaging          23.0
# pandas             1.5.3
# Pillow             9.4.0
# pip                23.0.1
# protobuf           4.22.1
# pyarrow            11.0.0
# PyJWT              2.6.0
# PyMySQL            1.0.3
# pyparsing          3.0.9
# python-dateutil    2.8.2
# pytz               2022.7.1
# PyYAML             6.0
# querystring-parser 1.2.4
# requests           2.28.2
# scikit-learn       1.2.2
# scipy              1.10.1
# setuptools         65.5.1
# shap               0.41.0
# six                1.16.0
# slicer             0.0.7
# smmap              5.0.0
# SQLAlchemy         2.0.8
# sqlparse           0.4.3
# tabulate           0.9.0
# threadpoolctl      3.1.0
# tqdm               4.65.0
# typing_extensions  4.5.0
# urllib3            1.26.15
# websocket-client   1.5.1
# Werkzeug           2.2.3
# wheel              0.40.0
# zipp               3.15.0
# --> Which python and version ...
# /usr/local/bin/python
# Python 3.10.10
# --> Which mlflow ...
# mlflow, version 2.2.1

# 3. Debug env variables: --------------------------------------------------------------
# --> Checking env variables:
# HOSTNAME=mlflow_phpmyadmin_5005
# MLFLOW_PORT=5005
# PYTHON_VERSION=3.10.10
# PWD=/home/mlflowuser/mlflow
# PYTHON_SETUPTOOLS_VERSION=65.5.1
# MYSQL_PASSWORD=Passw0rd
# MYSQL_USER=mlflow_user1
# HOME=/home/mlflowuser
# LANG=C.UTF-8
# GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D
# MLFLOW_ENDPOINT_URL=http://localhost:5005
# BACKEND_STORE_URI=mysql+pymysql://mlflow_user1:Passw0rd@mysql:3306/mlflow_db
# SHLVL=1
# MYSQL_DATABASE=mlflow_db
# MYSQL_PORT2=33050
# MYSQL_PORT1=3305
# PYTHON_PIP_VERSION=22.3.1
# PYTHON_GET_PIP_SHA256=394be00f13fa1b9aaa47e911bdb59a09c3b2986472130f30aa0bfaf7f3980637
# PHPMYADMIN_PORT=8085
# PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/d5cb0afaf23b8520f1bbcfed521017b4a95f5c01/public/get-pip.py
# DEFAULT_ARTIFACT_ROOT=./mlruns
# PATH=/home/mlflowuser/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# _=/usr/bin/printenv

# 4. Debug running procs: --------------------------------------------------------------
# --> Checking procs:
#     PID TTY      STAT   TIME COMMAND
#       1 ?        Ss     0:00 /bin/bash ./entrypoint-pip-dev.sh
#      34 ?        R      0:00 ps fax
# INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# INFO mlflow.store.db.utils: Updating database tables
#

#
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Running upgrade  -> 451aebb31d03, add metric step
# INFO  [alembic.runtime.migration] Running upgrade 451aebb31d03 -> 90e64c465722, migrate user column to tags
# INFO  [alembic.runtime.migration] Running upgrade 90e64c465722 -> 181f10493468, allow nulls for metric values
# INFO  [alembic.runtime.migration] Running upgrade 181f10493468 -> df50e92ffc5e, Add Experiment Tags Table
# INFO  [alembic.runtime.migration] Running upgrade df50e92ffc5e -> 7ac759974ad8, Update run tags with larger limit
# INFO  [alembic.runtime.migration] Running upgrade 7ac759974ad8 -> 89d4b8295536, create latest metrics table
# INFO  [89d4b8295536_create_latest_metrics_table_py] Migration complete!
# INFO  [alembic.runtime.migration] Running upgrade 89d4b8295536 -> 2b4d017a5e9b, add model registry tables to db
# INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Adding registered_models and model_versions tables to database.
# INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Migration complete!
# INFO  [alembic.runtime.migration] Running upgrade 2b4d017a5e9b -> cfd24bdc0731, Update run status constraint with killed
# INFO  [alembic.runtime.migration] Running upgrade cfd24bdc0731 -> 0a8213491aaa, drop_duplicate_killed_constraint
# INFO  [alembic.runtime.migration] Running upgrade 0a8213491aaa -> 728d730b5ebd, add registered model tags table
# INFO  [alembic.runtime.migration] Running upgrade 728d730b5ebd -> 27a6a02d2cf1, add model version tags table
# INFO  [alembic.runtime.migration] Running upgrade 27a6a02d2cf1 -> 84291f40a231, add run_link to model_version
# INFO  [alembic.runtime.migration] Running upgrade 84291f40a231 -> a8c4a736bde6, allow nulls for run_id
# INFO  [alembic.runtime.migration] Running upgrade a8c4a736bde6 -> 39d1c3be5f05, add_is_nan_constraint_for_metrics_tables_if_necessary
# INFO  [alembic.runtime.migration] Running upgrade 39d1c3be5f05 -> c48cb773bb87, reset_default_value_for_is_nan_in_metrics_table_for_mysql
# INFO  [alembic.runtime.migration] Running upgrade c48cb773bb87 -> bd07f7e963c5, create index on run_uuid
# INFO  [alembic.runtime.migration] Running upgrade bd07f7e963c5 -> 0c779009ac13, add deleted_time field to runs table
# INFO  [alembic.runtime.migration] Running upgrade 0c779009ac13 -> cc1f77228345, change param value length to 500
# INFO  [alembic.runtime.migration] Running upgrade cc1f77228345 -> 97727af70f4d, Add creation_time and last_update_time to experiments table
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# [50] [INFO] Starting gunicorn 20.1.0
# [50] [INFO] Listening at: http://0.0.0.0:5000 (50)
# [50] [INFO] Using worker: sync
# [51] [INFO] Booting worker with pid: 51
# [52] [INFO] Booting worker with pid: 52
# [53] [INFO] Booting worker with pid: 53
# [54] [INFO] Booting worker with pid: 54


# ======================================================================================================================================
# DEBUGGED INFO: when using 'mlflow_tracker_slim_as_root' image build with 'Dockerfile_as_root'
# ======================================================================================================================================

#  1. Basic OS info: --------------------------------------------------------------------
#  --> Host: ostype, osrelease, version ...
#  Linux
#  5.15.90.1-microsoft-standard-WSL2
#  #1 SMP Fri Jan 27 02:56:13 UTC 2023
#  --> Container: /etc/os-release ...
#  PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
#  --> Running as ...
#  root

#  2. Checking system pip setup: --------------------------------------------------------
#  --> Checking system pip setup ...
#  pip 23.0.1 from /usr/local/lib/python3.10/site-packages/pip (python 3.10)
#  --> Pip installed packages ...
#  Package            Version
#  ------------------ ---------
#  alembic            1.10.2
#  certifi            2022.12.7
#  charset-normalizer 3.1.0
#  click              8.1.3
#  cloudpickle        2.2.1
#  contourpy          1.0.7
#  cycler             0.11.0
#  databricks-cli     0.17.6
#  docker             6.0.1
#  entrypoints        0.4
#  Flask              2.2.3
#  fonttools          4.39.2
#  gitdb              4.0.10
#  GitPython          3.1.31
#  greenlet           2.0.2
#  gunicorn           20.1.0
#  idna               3.4
#  importlib-metadata 6.1.0
#  itsdangerous       2.1.2
#  Jinja2             3.1.2
#  joblib             1.2.0
#  kiwisolver         1.4.4
#  llvmlite           0.39.1
#  Mako               1.2.4
#  Markdown           3.4.3
#  MarkupSafe         2.1.2
#  matplotlib         3.7.1
#  mlflow             2.2.1
#  numba              0.56.4
#  numpy              1.23.5
#  oauthlib           3.2.2
#  packaging          23.0
#  pandas             1.5.3
#  Pillow             9.4.0
#  pip                23.0.1
#  protobuf           4.22.1
#  pyarrow            11.0.0
#  PyJWT              2.6.0
#  PyMySQL            1.0.2
#  pyparsing          3.0.9
#  python-dateutil    2.8.2
#  pytz               2022.7.1
#  PyYAML             6.0
#  querystring-parser 1.2.4
#  requests           2.28.2
#  scikit-learn       1.2.2
#  scipy              1.10.1
#  setuptools         65.5.1
#  shap               0.41.0
#  six                1.16.0
#  slicer             0.0.7
#  smmap              5.0.0
#  SQLAlchemy         2.0.7
#  sqlparse           0.4.3
#  tabulate           0.9.0
#  threadpoolctl      3.1.0
#  tqdm               4.65.0
#  typing_extensions  4.5.0
#  urllib3            1.26.15
#  websocket-client   1.5.1
#  Werkzeug           2.2.3
#  wheel              0.40.0
#  zipp               3.15.0
#  --> Which python and version ...
#  /usr/local/bin/python
#  Python 3.10.10
#  --> Which mlflow ...
#  mlflow, version 2.2.1

#  3. Debug env variables: --------------------------------------------------------------
#  --> Checking env variables:
#  HOSTNAME=mlflow_phpmyadmin_5007
#  MLFLOW_PORT=5007
#  PYTHON_VERSION=3.10.10
#  PWD=/mlflow
#  PYTHON_SETUPTOOLS_VERSION=65.5.1
#  MYSQL_PASSWORD=Passw0rd
#  MYSQL_USER=mlflow_user1
#  HOME=/root
#  LANG=C.UTF-8
#  GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D
#  MLFLOW_ENDPOINT_URL=http://localhost:5007
#  DEFAULT_ARTIFACTS_DESTINATION=/
#  BACKEND_STORE_URI=mysql+pymysql://mlflow_user1:Passw0rd@mysql:3306/mlflow_db
#  SHLVL=1
#  MYSQL_DATABASE=mlflow_db
#  MYSQL_PORT2=33070
#  MYSQL_PORT1=3307
#  PYTHON_PIP_VERSION=22.3.1
#  PYTHON_GET_PIP_SHA256=394be00f13fa1b9aaa47e911bdb59a09c3b2986472130f30aa0bfaf7f3980637
#  PHPMYADMIN_PORT=8087
#  PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/d5cb0afaf23b8520f1bbcfed521017b4a95f5c01/public/get-pip.py
#  DEFAULT_ARTIFACT_ROOT=./mlruns
#  PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#  _=/usr/bin/printenv

#  4. Debug running procs: --------------------------------------------------------------
#  --> Checking procs:
#      PID TTY      STAT   TIME COMMAND
#        1 ?        Ss     0:00 /bin/bash ./entrypoint-pip-dev.sh
#       34 ?        R      0:00 ps fax
#
#
#
#  INFO mlflow.store.db.utils: Creating initial MLflow database tables...
#  INFO mlflow.store.db.utils: Updating database tables
#  INFO  [alembic.runtime.migration] Context impl MySQLImpl.
#  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
#  INFO  [alembic.runtime.migration] Context impl MySQLImpl.
#  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
#  INFO mlflow.store.db.utils: Creating initial MLflow database tables...
#  INFO mlflow.store.db.utils: Updating database tables
#  INFO  [alembic.runtime.migration] Context impl MySQLImpl.
#  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
#  [50] [INFO] Starting gunicorn 20.1.0
#  [50] [INFO] Listening at: http://0.0.0.0:5000 (50)
#  [50] [INFO] Using worker: sync
#  [51] [INFO] Booting worker with pid: 51
#  [52] [INFO] Booting worker with pid: 52
#  [53] [INFO] Booting worker with pid: 53
#  [54] [INFO] Booting worker with pid: 54
