import os
from random import random, randint
import mlflow

if __name__ == "__main__":

    from utils.process_info import print_process_info
    print_process_info(os.getpid())

    # Set the tracking server: Scenario 3 -----------------------------------------------

    mlflow.set_tracking_uri("http://localhost:5005")

    tracking_uri = mlflow.get_tracking_uri()
    print("Current tracking uri: {}".format(tracking_uri))

    # Create/set the experiment we want to track to: ------------------------------------

    experiment = mlflow.set_experiment('quickstart')
    print(f"Current artifact store uri: {experiment.artifact_location}")

    # Log a parameter (key-value pair): -------------------------------------------------

    mlflow.log_param("param1", randint(0, 100))

    # Log a metric; metrics can be updated throughout the run: --------------------------

    mlflow.log_metric("foo", random())
    mlflow.log_metric("foo", random() + 1)
    mlflow.log_metric("foo", random() + 2)

    # Log artifacts: --------------------------------------------------------------------

    # Prepare artifacts to log: ------------------------------------------

    current_working_dir = os.getcwd()
    print(f"Current working directory: {current_working_dir}")

    outputs_dir = 'examples/quickstart/outputs'             # Set your artifacts temporal folder
    outputs_fullpath = os.path.join(current_working_dir, outputs_dir)
    if not os.path.exists(outputs_fullpath):
        os.makedirs(outputs_fullpath)
        print(f"Temporal directory '{outputs_fullpath}' created")

    with open(os.path.join(outputs_fullpath, "test.txt"), "w") as f:
        f.write("hello world!")

    # Log artifacts folder (track all artifacts in outputs folder): -----

    run_artifacts_full_path = mlflow.get_artifact_uri()     # The absolute artifact root URI of the currently active run will be returned.
                                                            # If: DEFAULT_ARTIFACT_ROOT=file:///home/mlflow/mlruns
                                                            # Then: artifacts_path='file:///home/gustavo/mlflow/mlruns/1/2fd77bf035aa410dbf9bda47fa4b66dd/artifacts'
                                                            # If: DEFAULT_ARTIFACT_ROOT=s3://<bucket_name>/path/to/artifact/root
                                                            # Then: artifacts_path='s3://<bucket_name>/mlruns/1/2fd77bf035aa410dbf9bda47fa4b66dd/artifacts'
                                                            # Calls to log_artifact() and log_artifacts() write artifact(s) to subdirectories of the artifact root URI.

    mlflow.log_artifacts(outputs_fullpath)                  # Log all the contents of a local directory (outputs_fullpath) as artifacts of the currently active run.
                                                            # Artifacts are logged in the absolute artifact root URI of the currently active run.

    print(f"Tracked artifacts in temp '{outputs_dir}' folder!")
    print(f"Artifacts full path: {run_artifacts_full_path}")

    # Clean after tracking: ---------------------------------------------

    if os.path.exists(outputs_fullpath):
        try:
            os.remove(os.path.join(outputs_fullpath, "test.txt"))
            os.rmdir(outputs_fullpath)
            print(f"Temporal directory '{outputs_fullpath}' has been removed successfully")
        except OSError as error:
            print(error)
            print(f"Temporal directory '{outputs_fullpath}' can not be removed")



# 1. Launch your tracking server: ---------------------------------------------------
# Open a terminal and run:
# $ . stack_deploy.sh
# [+] Running 4/4
#  ⠿ Network 3_mlflow_tracking_server_in_docker_default  Created    0.0s
#  ⠿ Container mlflow_mysql_3305                         Started    0.8s
#  ⠿ Container mlflow_phpmyadmin_8085                    Started    1.3s
#  ⠿ Container mlflow_tracker_5005                       Started    1.4s
# ...

# 2. Run your experiment: ----------------------------------------------------------
# Open another terminal in the lab3 folder and run:
# $ conda activate mlflow
# (mlflow)$
# (mlflow)$ export MLFLOW_TRACKING_URI="http://localhost:5005"
# (mlflow)$
# (mlflow)$ python ./examples/quickstart/mlflow_tracking.py
# Process ID: 8118
# Process Name: python
# Process Status: R (running)
# Process UID: 1000
# Process Owner: gustavo
# Current tracking uri: http://localhost:5005
# Current artifact store uri: file:///home/gustavo/mlflow/mlruns/1
# Current working directory: /home/gustavo/training/GitHub/Training.MLOps.MLFlow/lab3
# Temporal directory '/home/gustavo/training/GitHub/Training.MLOps.MLFlow/lab3/examples/quickstart/outputs' created
# Tracked artifacts in temp 'examples/quickstart/outputs' folder!
# Artifacts full path: file:///home/gustavo/mlflow/mlruns/0/c38ace2a2b7b4a239246f7639ef940c6/artifacts
# Temporal directory '/home/gustavo/training/GitHub/Training.MLOps.MLFlow/lab3/examples/quickstart/outputs' has been removed successfully