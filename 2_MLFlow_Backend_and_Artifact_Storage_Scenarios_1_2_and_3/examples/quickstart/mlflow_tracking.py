import os
from random import random, randint
import mlflow

if __name__ == "__main__":

    #mlflow.set_tracking_uri("./mlruns")                     # Scenario 1
    #mlflow.set_tracking_uri("sqlite:///mlruns.db")          # Scenario 2
    #mlflow.set_tracking_uri("http://localhost:5000")        # Scenario 3
    mlflow.set_tracking_uri("http://localhost:5007")        # Scenario 4

    tracking_uri = mlflow.get_tracking_uri()
    print("Current tracking uri: {}".format(tracking_uri))

    mlflow.set_experiment('quickstar')                       # <-- set the experiment we want to track to

    # Log a parameter (key-value pair)
    mlflow.log_param("param1", randint(0, 100))              # <-- Track parameters

    # Log a metric; metrics can be updated throughout the run
    mlflow.log_metric("foo", random())                       # <-- Track metrics
    mlflow.log_metric("foo", random() + 1)
    mlflow.log_metric("foo", random() + 2)

    # Log artifacts
    # Prepare artifacts to log:
    current_working_dir = os.getcwd()
    print(f"Current working directory: {current_working_dir}")

    outputs_dir = 'examples/quickstart/outputs'
    outputs_fullpath = os.path.join(current_working_dir, outputs_dir)
    if not os.path.exists(outputs_fullpath):
        os.makedirs(outputs_fullpath)
        print(f"Directory '{outputs_dir}' created")

    with open(os.path.join(outputs_fullpath, "test.txt"), "w") as f:
        f.write("hello world!")

    # Log artifacts folder (track all artifacts in outputs folder):
    mlflow.log_artifacts(outputs_fullpath)
    print(f"Artifacts in '{outputs_dir}' tracked!")

    # Clean after tracking:
    if os.path.exists(outputs_fullpath):
        try:
            os.remove(os.path.join(outputs_fullpath, "test.txt"))
            os.rmdir(outputs_fullpath)
            print(f"Directory '{outputs_dir}' has been removed successfully")
        except OSError as error:
            print(error)
            print(f"Directory '{outputs_dir}' can not be removed")

# 1. Launch your tracking server: ---------------------------------------------------
# Open a terminal in Ex2 folder and run:
# $ conda activate mlflow
# For scenario 1:
# $ mlflow ui
# For scenario 3:
# $ mlflow server --backend-store-uri sqlite:///mflow.db --default-artifact-root mlruns/ --host 0.0.0.0 --port 5000
# ...

# 2. Open another terminal in the Ex2 folder and run: ------------------------------
# $ conda activate mlflow
# $ python examples/quickstart/mlflow_tracking.py
# Current tracking uri: http://localhost:5000
# 2023/03/01 12:01:38 INFO mlflow.tracking.fluent: Experiment with name 'quickstar' does not exist. Creating a new experiment.
# Current working directory: /home/gustavo/training/Training.Docker/2.WebServices/6.MLFlow/Ex2_MLFlow_on_localhost_with_Dockerized_Tracking_Server