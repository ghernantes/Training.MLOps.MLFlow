#!/bin/bash --login
# The --login ensures the bash configuration is loaded, enabling Conda.

# Enable strict mode.
set -euo pipefail
# ... Run whatever commands ...

echo "Host: ostype, osrelease, version ..."
#uname -a
cat /proc/sys/kernel/{ostype,osrelease,version}

echo "Container: /etc/os-release ..."
cat /etc/os-release | grep PRETTY_NAME
# apt install lsb-core
# lsb_release -d

echo "Running as ..."
whoami

# Demonstrate the environment is activated:
echo "Checking conda environment activation ..."
conda --version
conda env list
echo "Environment packages ..."
conda list
echo "Which python and version ..."
which python && python --version

# Temporarily disable strict mode and activate conda:
set +euo pipefail

conda activate mlflow_env

# Re-enable strict mode:
set -euo pipefail

echo "Which mlflow ..."
mlflow --version

# exec the final command:
exec mlflow server --backend-store-uri mysql+pymysql://${MYSQL_USER}:${MYSQL_PASSWORD}@db:3306/${MYSQL_DATABASE} --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} -h 0.0.0.0
