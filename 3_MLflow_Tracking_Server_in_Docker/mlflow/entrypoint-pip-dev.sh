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
                   --host 0.0.0.0 --port 5000
# NOTE: Option 'default-artifact-root' is required when backend store is not local file based and artifact serving is disabled.

# exec mlflow server --backend-store-uri mysql+pymysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql:3306/${MYSQL_DATABASE} \
#                    --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} \
#                    --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} \
#                    --no-serve-artifacts \
#                    --host 0.0.0.0 --port 5000

# NOTE: 'mysql' is the service name given to db in the docker-compose.yml file


# ======================================================================================================================================
# DEBUGGED INFO:
# ======================================================================================================================================

# 2023-03-31 21:40:53 1. Basic OS info: --------------------------------------------------------------------
# 2023-03-31 21:40:53 --> Host: ostype, osrelease, version ...
# 2023-03-31 21:40:53 Linux
# 2023-03-31 21:40:53 5.15.90.1-microsoft-standard-WSL2
# 2023-03-31 21:40:53 #1 SMP Fri Jan 27 02:56:13 UTC 2023
# 2023-03-31 21:40:53 --> Container: /etc/os-release ...
# 2023-03-31 21:40:53 PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
# 2023-03-31 21:40:53 --> Running as ...
# 2023-03-31 21:40:53 mlflowuser

# 2023-03-31 21:40:53 2. Checking system pip setup: --------------------------------------------------------
# 2023-03-31 21:40:53 --> Checking system pip setup ...
# 2023-03-31 21:40:53 pip 23.0.1 from /usr/local/lib/python3.10/site-packages/pip (python 3.10)
# 2023-03-31 21:40:53 --> Pip installed packages ...
# 2023-03-31 21:40:53 Package            Version
# 2023-03-31 21:40:53 ------------------ ---------
# 2023-03-31 21:40:53 alembic            1.10.2
# 2023-03-31 21:40:53 certifi            2022.12.7
# 2023-03-31 21:40:53 charset-normalizer 3.1.0
# 2023-03-31 21:40:53 click              8.1.3
# 2023-03-31 21:40:53 cloudpickle        2.2.1
# 2023-03-31 21:40:53 contourpy          1.0.7
# 2023-03-31 21:40:53 cycler             0.11.0
# 2023-03-31 21:40:53 databricks-cli     0.17.6
# 2023-03-31 21:40:53 docker             6.0.1
# 2023-03-31 21:40:53 entrypoints        0.4
# 2023-03-31 21:40:53 Flask              2.2.3
# 2023-03-31 21:40:53 fonttools          4.39.3
# 2023-03-31 21:40:53 gitdb              4.0.10
# 2023-03-31 21:40:53 GitPython          3.1.31
# 2023-03-31 21:40:53 greenlet           2.0.2
# 2023-03-31 21:40:53 gunicorn           20.1.0
# 2023-03-31 21:40:53 idna               3.4
# 2023-03-31 21:40:53 importlib-metadata 6.1.0
# 2023-03-31 21:40:53 itsdangerous       2.1.2
# 2023-03-31 21:40:53 Jinja2             3.1.2
# 2023-03-31 21:40:53 joblib             1.2.0
# 2023-03-31 21:40:53 kiwisolver         1.4.4
# 2023-03-31 21:40:53 llvmlite           0.39.1
# 2023-03-31 21:40:53 Mako               1.2.4
# 2023-03-31 21:40:53 Markdown           3.4.3
# 2023-03-31 21:40:53 MarkupSafe         2.1.2
# 2023-03-31 21:40:53 matplotlib         3.7.1
# 2023-03-31 21:40:53 mlflow             2.2.1
# 2023-03-31 21:40:53 numba              0.56.4
# 2023-03-31 21:40:53 numpy              1.23.5
# 2023-03-31 21:40:53 oauthlib           3.2.2
# 2023-03-31 21:40:53 packaging          23.0
# 2023-03-31 21:40:53 pandas             1.5.3
# 2023-03-31 21:40:53 Pillow             9.4.0
# 2023-03-31 21:40:53 pip                23.0.1
# 2023-03-31 21:40:53 protobuf           4.22.1
# 2023-03-31 21:40:53 pyarrow            11.0.0
# 2023-03-31 21:40:53 PyJWT              2.6.0
# 2023-03-31 21:40:53 PyMySQL            1.0.3
# 2023-03-31 21:40:53 pyparsing          3.0.9
# 2023-03-31 21:40:53 python-dateutil    2.8.2
# 2023-03-31 21:40:53 pytz               2022.7.1
# 2023-03-31 21:40:53 PyYAML             6.0
# 2023-03-31 21:40:53 querystring-parser 1.2.4
# 2023-03-31 21:40:53 requests           2.28.2
# 2023-03-31 21:40:53 scikit-learn       1.2.2
# 2023-03-31 21:40:53 scipy              1.10.1
# 2023-03-31 21:40:53 setuptools         65.5.1
# 2023-03-31 21:40:53 shap               0.41.0
# 2023-03-31 21:40:53 six                1.16.0
# 2023-03-31 21:40:53 slicer             0.0.7
# 2023-03-31 21:40:53 smmap              5.0.0
# 2023-03-31 21:40:53 SQLAlchemy         2.0.8
# 2023-03-31 21:40:53 sqlparse           0.4.3
# 2023-03-31 21:40:53 tabulate           0.9.0
# 2023-03-31 21:40:53 threadpoolctl      3.1.0
# 2023-03-31 21:40:53 tqdm               4.65.0
# 2023-03-31 21:40:53 typing_extensions  4.5.0
# 2023-03-31 21:40:53 urllib3            1.26.15
# 2023-03-31 21:40:53 websocket-client   1.5.1
# 2023-03-31 21:40:53 Werkzeug           2.2.3
# 2023-03-31 21:40:53 wheel              0.40.0
# 2023-03-31 21:40:53 zipp               3.15.0
# 2023-03-31 21:40:54 --> Which python and version ...
# 2023-03-31 21:40:54 /usr/local/bin/python
# 2023-03-31 21:40:54 Python 3.10.10
# 2023-03-31 21:40:54 --> Which mlflow ...
# 2023-03-31 21:40:55 mlflow, version 2.2.1

# 2023-03-31 21:40:55 3. Debug env variables: --------------------------------------------------------------
# 2023-03-31 21:40:55 --> Checking env variables:
# 2023-03-31 21:40:55 HOSTNAME=mlflow_phpmyadmin_5005
# 2023-03-31 21:40:55 MLFLOW_PORT=5005
# 2023-03-31 21:40:55 PYTHON_VERSION=3.10.10
# 2023-03-31 21:40:55 PWD=/home/mlflowuser/mlflow
# 2023-03-31 21:40:55 PYTHON_SETUPTOOLS_VERSION=65.5.1
# 2023-03-31 21:40:55 MYSQL_PASSWORD=Passw0rd
# 2023-03-31 21:40:55 MYSQL_USER=mlflow_user1
# 2023-03-31 21:40:55 HOME=/home/mlflowuser
# 2023-03-31 21:40:55 LANG=C.UTF-8
# 2023-03-31 21:40:55 GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D
# 2023-03-31 21:40:55 MLFLOW_ENDPOINT_URL=http://localhost:5005
# 2023-03-31 21:40:55 BACKEND_STORE_URI=mysql+pymysql://mlflow_user1:Passw0rd@mysql:3306/mlflow_db
# 2023-03-31 21:40:55 SHLVL=1
# 2023-03-31 21:40:55 MYSQL_DATABASE=mlflow_db
# 2023-03-31 21:40:55 MYSQL_PORT2=33050
# 2023-03-31 21:40:55 MYSQL_PORT1=3305
# 2023-03-31 21:40:55 PYTHON_PIP_VERSION=22.3.1
# 2023-03-31 21:40:55 PYTHON_GET_PIP_SHA256=394be00f13fa1b9aaa47e911bdb59a09c3b2986472130f30aa0bfaf7f3980637
# 2023-03-31 21:40:55 PHPMYADMIN_PORT=8085
# 2023-03-31 21:40:55 PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/d5cb0afaf23b8520f1bbcfed521017b4a95f5c01/public/get-pip.py
# 2023-03-31 21:40:55 DEFAULT_ARTIFACT_ROOT=./mlruns
# 2023-03-31 21:40:55 PATH=/home/mlflowuser/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# 2023-03-31 21:40:55 _=/usr/bin/printenv

# 2023-03-31 21:40:55 4. Debug running procs: --------------------------------------------------------------
# 2023-03-31 21:40:55 --> Checking procs:
# 2023-03-31 21:40:55     PID TTY      STAT   TIME COMMAND
# 2023-03-31 21:40:55       1 ?        Ss     0:00 /bin/bash ./entrypoint-pip-dev.sh
# 2023-03-31 21:40:55      34 ?        R      0:00 ps fax
# 2023-03-31 21:40:56 2023/03/31 19:40:56 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023-03-31 21:40:56 2023/03/31 19:40:56 INFO mlflow.store.db.utils: Updating database tables
#
#
#
# 2023-03-31 21:40:56 INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# 2023-03-31 21:40:56 INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023-03-31 21:40:56 INFO  [alembic.runtime.migration] Running upgrade  -> 451aebb31d03, add metric step
# 2023-03-31 21:40:56 INFO  [alembic.runtime.migration] Running upgrade 451aebb31d03 -> 90e64c465722, migrate user column to tags
# 2023-03-31 21:40:56 INFO  [alembic.runtime.migration] Running upgrade 90e64c465722 -> 181f10493468, allow nulls for metric values
# 2023-03-31 21:40:56 INFO  [alembic.runtime.migration] Running upgrade 181f10493468 -> df50e92ffc5e, Add Experiment Tags Table
# 2023-03-31 21:40:56 INFO  [alembic.runtime.migration] Running upgrade df50e92ffc5e -> 7ac759974ad8, Update run tags with larger limit
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 7ac759974ad8 -> 89d4b8295536, create latest metrics table
# 2023-03-31 21:40:57 INFO  [89d4b8295536_create_latest_metrics_table_py] Migration complete!
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 89d4b8295536 -> 2b4d017a5e9b, add model registry tables to db
# 2023-03-31 21:40:57 INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Adding registered_models and model_versions tables to database.
# 2023-03-31 21:40:57 INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Migration complete!
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 2b4d017a5e9b -> cfd24bdc0731, Update run status constraint with killed
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade cfd24bdc0731 -> 0a8213491aaa, drop_duplicate_killed_constraint
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 0a8213491aaa -> 728d730b5ebd, add registered model tags table
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 728d730b5ebd -> 27a6a02d2cf1, add model version tags table
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 27a6a02d2cf1 -> 84291f40a231, add run_link to model_version
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 84291f40a231 -> a8c4a736bde6, allow nulls for run_id
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade a8c4a736bde6 -> 39d1c3be5f05, add_is_nan_constraint_for_metrics_tables_if_necessary
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 39d1c3be5f05 -> c48cb773bb87, reset_default_value_for_is_nan_in_metrics_table_for_mysql
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade c48cb773bb87 -> bd07f7e963c5, create index on run_uuid
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade bd07f7e963c5 -> 0c779009ac13, add deleted_time field to runs table
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade 0c779009ac13 -> cc1f77228345, change param value length to 500
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Running upgrade cc1f77228345 -> 97727af70f4d, Add creation_time and last_update_time to experiments table
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023-03-31 21:40:57 2023/03/31 19:40:57 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# 2023-03-31 21:40:57 2023/03/31 19:40:57 INFO mlflow.store.db.utils: Updating database tables
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# 2023-03-31 21:40:57 INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# 2023-03-31 21:40:57 [2023-03-31 19:40:57 +0000] [50] [INFO] Starting gunicorn 20.1.0
# 2023-03-31 21:40:57 [2023-03-31 19:40:57 +0000] [50] [INFO] Listening at: http://0.0.0.0:5000 (50)
# 2023-03-31 21:40:57 [2023-03-31 19:40:57 +0000] [50] [INFO] Using worker: sync
# 2023-03-31 21:40:57 [2023-03-31 19:40:57 +0000] [51] [INFO] Booting worker with pid: 51
# 2023-03-31 21:40:57 [2023-03-31 19:40:57 +0000] [52] [INFO] Booting worker with pid: 52
# 2023-03-31 21:40:58 [2023-03-31 19:40:58 +0000] [53] [INFO] Booting worker with pid: 53
# 2023-03-31 21:40:58 [2023-03-31 19:40:58 +0000] [54] [INFO] Booting worker with pid: 54

# ======================================================================================================================================
# DEBUGGED INFO: when using 'mlflow_tracker_slim' image build with 'Dockerfile_as_root'
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
#
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
#
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
#
#  4. Debug running procs: --------------------------------------------------------------
#  --> Checking procs:
#      PID TTY      STAT   TIME COMMAND
#        1 ?        Ss     0:00 /bin/bash ./entrypoint-pip-dev.sh
#       34 ?        R      0:00 ps fax
#
#
#
#  2023/03/26 12:14:27 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
#  2023/03/26 12:14:27 INFO mlflow.store.db.utils: Updating database tables
#  INFO  [alembic.runtime.migration] Context impl MySQLImpl.
#  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
#  INFO  [alembic.runtime.migration] Context impl MySQLImpl.
#  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
#  2023/03/26 12:14:27 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
#  2023/03/26 12:14:27 INFO mlflow.store.db.utils: Updating database tables
#  INFO  [alembic.runtime.migration] Context impl MySQLImpl.
#  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
#  [2023-03-26 12:14:27 +0000] [50] [INFO] Starting gunicorn 20.1.0
#  [2023-03-26 12:14:27 +0000] [50] [INFO] Listening at: http://0.0.0.0:5000 (50)
#  [2023-03-26 12:14:27 +0000] [50] [INFO] Using worker: sync
#  [2023-03-26 12:14:27 +0000] [51] [INFO] Booting worker with pid: 51
#  [2023-03-26 12:14:27 +0000] [52] [INFO] Booting worker with pid: 52
#  [2023-03-26 12:14:27 +0000] [53] [INFO] Booting worker with pid: 53
#  [2023-03-26 12:14:27 +0000] [54] [INFO] Booting worker with pid: 54
