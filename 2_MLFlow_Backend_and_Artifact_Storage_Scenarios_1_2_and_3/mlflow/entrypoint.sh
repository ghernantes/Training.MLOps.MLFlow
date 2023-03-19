#!/bin/bash

# Enable strict mode.
set -euo pipefail

# ======================================================================================================================
# exec the final command: mlflow server
# ======================================================================================================================

exec mlflow server --backend-store-uri mysql+pymysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql:3306/${MYSQL_DATABASE} \
                   --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} \
                   --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} \
                   --no-serve-artifacts \
                   --host 0.0.0.0 --port 5000

# exec mlflow server --backend-store-uri mysql+pymysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql:3306/${MYSQL_DATABASE} \
#                    --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} \
#                    --no-serve-artifacts \
#                    -h 0.0.0.0

# NOTE: 'mysql' is the service name given to db in the docker-compose.yml file