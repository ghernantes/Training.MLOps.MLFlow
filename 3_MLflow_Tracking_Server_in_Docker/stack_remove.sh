echo "--> Stack: -------------------------------------------------------------------------------------"
docker compose down


# ======================================================================================================================
# Remove mlflow server container stack with:
# ======================================================================================================================

# $ source ./stack_remove

# --> Stack: -------------------------------------------------------------------------------------
# [+] Running 4/4
#  ⠿ Container mlflow_phpmyadmin_8087                                           Removed      1.4s
#  ⠿ Container mlflow_tracker_5007                                              Removed     10.5s
#  ⠿ Container mlflow_mysql_3307                                                Removed      3.0s
#  ⠿ Network 2_mlflow_backend_and_artifact_storage_scenarios_1_2_and_3_default  Removed      0.3s