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

# any image: -----------------------------------------------------------------------------------------------------------

# $ source ./stack_deploy
# [+] Running 5/5
#  ⠿ Network 3_mlflow_tracking_server_in_docker_default     Created   0.1s
#  ⠿ Volume "3_MLflow_Tracking_Server_in_Docker_volume"     Created   0.0s
#  ⠿ Container mlflow_mysql_33075                           Started   0.9s
#  ⠿ Container mlflow_phpmyadmin_8085                       Started   0.0s
#  ⠿ Container mlflow_tracker_5005                          Started   1.6s


# ======================================================================================================================
# Logged info in for mlflow_tracker_5005 container in Docker Desktop:
# ======================================================================================================================

# for the 'mlflow_tracker_slim_as_gustavo' image: ----------------------------------------------------------------------

# 1. Basic OS info: --------------------------------------------------------------------
# --> Host: ostype, osrelease, version ...
# Linux
# 5.15.90.1-microsoft-standard-WSL2
# #1 SMP Fri Jan 27 02:56:13 UTC 2023
# --> Container: /etc/os-release ...
# PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
# --> Running as ...
# gustavo

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
# Pillow             9.5.0
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
# PWD=/home/gustavo/mlflow
# PYTHON_SETUPTOOLS_VERSION=65.5.1
# MYSQL_PASSWORD=Passw0rd
# MYSQL_USER=mlflow_user1
# HOME=/home/gustavo
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
# DEFAULT_ARTIFACT_ROOT=file:///home/gustavo/mlflow/mlruns
# PATH=/home/gustavo/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# _=/usr/bin/printenv

# 4. Debug running procs: --------------------------------------------------------------
# --> Checking procs:
#     PID TTY      STAT   TIME COMMAND
#       1 ?        Ss     0:00 /bin/bash ./entrypoint-pip-dev.sh
#      34 ?        R      0:00 ps fax

#
#
# INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# [INFO] Starting gunicorn 20.1.0
# [INFO] Listening at: http://0.0.0.0:5000 (50)
# [INFO] Using worker: sync
# [INFO] Booting worker with pid: 51
# [INFO] Booting worker with pid: 52
# [INFO] Booting worker with pid: 53
# [INFO] Booting worker with pid: 54


# for the 'mlflow_tracker_conda' image: --------------------------------------------------------------------------------

# 1. Basic OS info: --------------------------------------------------------------------
# --> Host: ostype, osrelease, version ...
# Linux
# 5.15.90.1-microsoft-standard-WSL2
# #1 SMP Fri Jan 27 02:56:13 UTC 2023
# --> Container: /etc/os-release ...
# PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
# --> Running as ...
# gustavo

# 2. Checking conda env setup: ---------------------------------------------------------
# conda 23.3.1
# # conda environments:
# #
# mlflow_env            *  /home/gustavo/.conda/envs/mlflow_env
# base                     /opt/conda
#
# --> Environment packages ...
# # packages in environment at /home/gustavo/.conda/envs/mlflow_env:
# #
# # Name                    Version                   Build  Channel
# _libgcc_mutex             0.1                 conda_forge    conda-forge
# _openmp_mutex             4.5                       2_gnu    conda-forge
# alembic                   1.10.2                   pypi_0    pypi
# bzip2                     1.0.8                h7f98852_4    conda-forge
# ca-certificates           2022.12.7            ha878542_0    conda-forge
# certifi                   2022.12.7                pypi_0    pypi
# charset-normalizer        3.1.0                    pypi_0    pypi
# click                     8.1.3                    pypi_0    pypi
# cloudpickle               2.2.1                    pypi_0    pypi
# contourpy                 1.0.7                    pypi_0    pypi
# cycler                    0.11.0                   pypi_0    pypi
# databricks-cli            0.17.6                   pypi_0    pypi
# docker                    6.0.1                    pypi_0    pypi
# entrypoints               0.4                      pypi_0    pypi
# flask                     2.2.3                    pypi_0    pypi
# fonttools                 4.39.3                   pypi_0    pypi
# gitdb                     4.0.10                   pypi_0    pypi
# gitpython                 3.1.31                   pypi_0    pypi
# greenlet                  2.0.2                    pypi_0    pypi
# gunicorn                  20.1.0                   pypi_0    pypi
# idna                      3.4                      pypi_0    pypi
# importlib-metadata        6.1.0                    pypi_0    pypi
# itsdangerous              2.1.2                    pypi_0    pypi
# jinja2                    3.1.2                    pypi_0    pypi
# joblib                    1.2.0                    pypi_0    pypi
# kiwisolver                1.4.4                    pypi_0    pypi
# ld_impl_linux-64          2.40                 h41732ed_0    conda-forge
# libffi                    3.4.2                h7f98852_5    conda-forge
# libgcc-ng                 12.2.0              h65d4601_19    conda-forge
# libgomp                   12.2.0              h65d4601_19    conda-forge
# libnsl                    2.0.0                h7f98852_0    conda-forge
# libsqlite                 3.40.0               h753d276_0    conda-forge
# libuuid                   2.38.1               h0b41bf4_0    conda-forge
# libzlib                   1.2.13               h166bdaf_4    conda-forge
# llvmlite                  0.39.1                   pypi_0    pypi
# mako                      1.2.4                    pypi_0    pypi
# markdown                  3.4.3                    pypi_0    pypi
# markupsafe                2.1.2                    pypi_0    pypi
# matplotlib                3.7.1                    pypi_0    pypi
# mlflow                    2.2.2                    pypi_0    pypi
# ncurses                   6.3                  h27087fc_1    conda-forge
# numba                     0.56.4                   pypi_0    pypi
# numpy                     1.23.5                   pypi_0    pypi
# oauthlib                  3.2.2                    pypi_0    pypi
# openssl                   3.1.0                h0b41bf4_0    conda-forge
# packaging                 23.0                     pypi_0    pypi
# pandas                    1.5.3                    pypi_0    pypi
# pillow                    9.5.0                    pypi_0    pypi
# pip                       22.3.1             pyhd8ed1ab_0    conda-forge
# protobuf                  4.22.1                   pypi_0    pypi
# pyarrow                   11.0.0                   pypi_0    pypi
# pyjwt                     2.6.0                    pypi_0    pypi
# pymysql                   1.0.3                    pypi_0    pypi
# pyparsing                 3.0.9                    pypi_0    pypi
# python                    3.10.9          he550d4f_0_cpython    conda-forge
# python-dateutil           2.8.2                    pypi_0    pypi
# pytz                      2022.7.1                 pypi_0    pypi
# pyyaml                    6.0                      pypi_0    pypi
# querystring-parser        1.2.4                    pypi_0    pypi
# readline                  8.2                  h8228510_1    conda-forge
# requests                  2.28.2                   pypi_0    pypi
# scikit-learn              1.2.2                    pypi_0    pypi
# scipy                     1.10.1                   pypi_0    pypi
# setuptools                67.6.1             pyhd8ed1ab_0    conda-forge
# shap                      0.41.0                   pypi_0    pypi
# six                       1.16.0                   pypi_0    pypi
# slicer                    0.0.7                    pypi_0    pypi
# smmap                     5.0.0                    pypi_0    pypi
# sqlalchemy                2.0.8                    pypi_0    pypi
# sqlparse                  0.4.3                    pypi_0    pypi
# tabulate                  0.9.0                    pypi_0    pypi
# threadpoolctl             3.1.0                    pypi_0    pypi
# tk                        8.6.12               h27826a3_0    conda-forge
# tqdm                      4.65.0                   pypi_0    pypi
# typing-extensions         4.5.0                    pypi_0    pypi
# tzdata                    2023c                h71feb2d_0    conda-forge
# urllib3                   1.26.15                  pypi_0    pypi
# websocket-client          1.5.1                    pypi_0    pypi
# werkzeug                  2.2.3                    pypi_0    pypi
# wheel                     0.40.0             pyhd8ed1ab_0    conda-forge
# xz                        5.2.6                h166bdaf_0    conda-forge
# zipp                      3.15.0                   pypi_0    pypi
# --> Which python and version ...
# /home/gustavo/.conda/envs/mlflow_env/bin/python
# Python 3.10.9
# --> Which mlflow ...
# mlflow, version 2.2.2

# 3. Debug env variables: --------------------------------------------------------------
# --> Checking env variables:
# CONDA_EXE=/opt/conda/bin/conda
# _CE_M=
# HOSTNAME=mlflow_phpmyadmin_5005
# MLFLOW_PORT=5005
# PWD=/home/gustavo
# CONDA_ROOT=/opt/conda
# CONDA_PREFIX=/home/gustavo/.conda/envs/mlflow_env
# MYSQL_PASSWORD=Passw0rd
# MYSQL_USER=mlflow_user1
# HOME=/home/gustavo
# LANG=C.UTF-8
# CONDA_PROMPT_MODIFIER=(mlflow_env)
# MLFLOW_ENDPOINT_URL=http://localhost:5005
# _CE_CONDA=
# DEFAULT_ARTIFACTS_DESTINATION=/
# CONDA_SHLVL=2
# BACKEND_STORE_URI=mysql+pymysql://mlflow_user1:Passw0rd@mysql:3306/mlflow_db
# SHLVL=2
# MYSQL_DATABASE=mlflow_db
# MYSQL_PORT2=33050
# MYSQL_PORT1=3305
# CONDA_PYTHON_EXE=/opt/conda/bin/python
# CONDA_DEFAULT_ENV=mlflow_env
# LC_ALL=C.UTF-8
# PHPMYADMIN_PORT=8085
# DEFAULT_ARTIFACT_ROOT=file:///home/gustavo/mlflow/mlruns
# PATH=/home/gustavo/.conda/envs/mlflow_env/bin:/opt/conda/condabin:/home/gustavo/.local/bin:/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# CONDA_PREFIX_1=/opt/conda
# _=/usr/bin/printenv

# 4. Debug running procs: --------------------------------------------------------------
# --> Checking procs:
#     PID TTY      STAT   TIME COMMAND
#       1 ?        Ss     0:00 /opt/conda/bin/python /opt/conda/bin/conda run --no-capture-output -n mlflow_env /bin/bash ./entrypoint-conda-dev.sh ./entrypoint-conda-dev.sh
#       7 ?        S      0:00 /bin/bash /tmp/tmpdhwd8d8f
#      15 ?        S      0:00  \_ /bin/bash ./entrypoint-conda-dev.sh ./entrypoint-conda-dev.sh
#      42 ?        R      0:00      \_ ps fax

#
#
# INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# INFO mlflow.store.db.utils: Creating initial MLflow database tables...
# INFO mlflow.store.db.utils: Updating database tables
# INFO  [alembic.runtime.migration] Context impl MySQLImpl.
# INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
# [58] [INFO] Starting gunicorn 20.1.0
# [58] [INFO] Listening at: http://0.0.0.0:5000 (58)
# [58] [INFO] Using worker: sync
# [59] [INFO] Booting worker with pid: 59
# [60] [INFO] Booting worker with pid: 60
# [61] [INFO] Booting worker with pid: 61
# [62] [INFO] Booting worker with pid: 62


# ======================================================================================================================
# Debug info:
# ======================================================================================================================

# Open terminal in the 'mlflow_tracker_5005' container and run 'ps fax':

# for the 'mlflow_tracker_slim_as_gustavo' image: ----------------------------------------------------------------------

# $ ps fax
#     PID TTY      STAT   TIME COMMAND
#     131 pts/0    Ss     0:00 /bin/sh
#     145 pts/0    R+     0:00  \_ ps fax
#       1 ?        Ssl    0:02 /usr/local/bin/python /home/gustavo/.local/bin/mlflow server --backend-store-uri mysql+pymysql://mlflow_user1:Passw0rd@mysql:3306/mlflow_db --default-
#      50 ?        S      0:00 /usr/local/bin/python /home/gustavo/.local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#      51 ?        Sl     0:02  \_ /usr/local/bin/python /home/gustavo/.local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#      52 ?        Sl     0:02  \_ /usr/local/bin/python /home/gustavo/.local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#      54 ?        Sl     0:02  \_ /usr/local/bin/python /home/gustavo/.local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#     115 ?        Sl     0:02  \_ /usr/local/bin/python /home/gustavo/.local/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app


# for the 'mlflow_tracker_conda' image: --------------------------------------------------------------------------------

# $ ps fax
#     PID TTY      STAT   TIME COMMAND
#     123 pts/0    Ss     0:00 /bin/sh
#     129 pts/0    R+     0:00  \_ ps fax
#       1 ?        Ss     0:00 /opt/conda/bin/python /opt/conda/bin/conda run --no-capture-output -n mlflow_env /bin/bash ./entrypoint-conda-dev.sh ./entrypoint-conda-dev.sh
#       7 ?        S      0:00 /bin/bash /tmp/tmpdhwd8d8f
#      15 ?        Sl     0:02  \_ /home/gustavo/.conda/envs/mlflow_env/bin/python /home/gustavo/.conda/envs/mlflow_env/bin/mlflow server --backend-store-uri mysql+pymysql://mlflow_
#      58 ?        S      0:00      \_ /home/gustavo/.conda/envs/mlflow_env/bin/python /home/gustavo/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#      59 ?        Sl     0:01          \_ /home/gustavo/.conda/envs/mlflow_env/bin/python /home/gustavo/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#      60 ?        Sl     0:01          \_ /home/gustavo/.conda/envs/mlflow_env/bin/python /home/gustavo/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#      61 ?        Sl     0:01          \_ /home/gustavo/.conda/envs/mlflow_env/bin/python /home/gustavo/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app
#      62 ?        Sl     0:01          \_ /home/gustavo/.conda/envs/mlflow_env/bin/python /home/gustavo/.conda/envs/mlflow_env/bin/gunicorn -b 0.0.0.0:5000 -w 4 mlflow.server:app

