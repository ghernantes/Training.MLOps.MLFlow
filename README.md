# MLFlow Training

- [1. MLflow install and Hello World](./1_MLFlow_Install_and_Hello_World/README.md)

    - [1. The promise](./1_MLFlow_Install_and_Hello_World/README.md#1-the-promise)
    - [2. Core components](./1_MLFlow_Install_and_Hello_World/README.md#2-core-components)
    - [3. Requirements and recommendations](./1_MLFlow_Install_and_Hello_World/README.md#3-requirements-and-recommendations)
    - [4. MLflow system pip install & UI run](./1_MLFlow_Install_and_Hello_World/README.md#4-mlflow-system-pip-install--ui-run)
        - [4.1 System MLflow setup](./1_MLFlow_Install_and_Hello_World/README.md#41-system-mlflow-setup)
        - [4.2 Conda env MLflow setup](./1_MLFlow_Install_and_Hello_World/README.md#42-conda-env-mlflow-setup)
        - [4.3 MLflow Tracking UI run](./1_MLFlow_Install_and_Hello_World/README.md#43-mlflow-tracking-ui-run)
    - [5. First MLFlow run with `mlflow.doctor`](./1_MLFlow_Install_and_Hello_World/README.md#5-first-mlflow-run-with-mlflowdoctor)
    - [6. Logging runs with MLflow Tracking](./1_MLFlow_Install_and_Hello_World/README.md#6-logging-runs-with-mlflow-tracking)
        - [6.1 Basic ML Sample App using the Tracking API](./1_MLFlow_Install_and_Hello_World/README.md#61-basic-ml-sample-app-using-the-tracking-api)
        - [6.2 Running the mlflow_tracking.py example (Scenario 1)](./1_MLFlow_Install_and_Hello_World/README.md#62-running-the-mlflow_trackingpy-example-scenario-1)
        - [6.3 Tracked data folders](./1_MLFlow_Install_and_Hello_World/README.md#63-tracked-data-folders)
        - [6.4 Viewing the tracked data using the Tracking UI](./1_MLFlow_Install_and_Hello_World/README.md#64-viewing-the-tracked-data-using-the-tracking-ui)
    - [7. Summary](./1_MLFlow_Install_and_Hello_World/README.md#7-summary)

- [2. MLFlow Backend and Artifact Storage. Scenarios 1, 2 and 3](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md)

    - [1. The parts: Client and Server; Backend and Artifact stores](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#1-the-parts-client-and-server-backend-and-artifact-stores)
    - [2. Scenario 1: MLFlow Client tracking to folders. No HTTP Tracking server. ('MLFLOW_TRACKING_URI="file:///tmp/my_tracking"')](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#2-scenario-1-mlflow-client-tracking-to-folders-no-http-tracking-server-mlflow_tracking_urifiletmpmy_tracking)
        - [2.1 Set the MLFlow Client's 'Backend store' and 'Artifacts store'](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#21-set-the-mlflow-clients-backend-store-and-artifacts-store)
        - [2.2 Launch the 'mlflow UI' server](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#22-launch-the-mlflow-ui-server)
        - [2.3 The 'quickstart' example under Scenario 1](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#23-the-quickstart-example-under-scenario-1)
    - [3. Scenario 2: MLFlow Client tracking to SQLite. No HTTP Tracking server. ('MLFLOW_TRACKING_URI="sqlite:///mlruns.db"')](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#3-scenario-2-mlflow-client-tracking-to-sqlite-no-http-tracking-server-mlflow_tracking_urisqlitemlflowdb)
        - [3.1 Set the MLFlow Client's 'Backend store' in a local SQLite database and 'Artifacts store' in a local folder](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#31-set-the-mlflow-clients-backend-store-in-a-local-sqlite-database-and-artifacts-store-in-a-local-folder)
        - [3.2 Launch the 'mlflow UI' server](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#32-launch-the-mlflow-ui-server)
        - [3.3 The 'quickstart' example under Scenario 2](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#33-the-quickstart-example-under-scenario-2)
    - [4. Scenario 3: MLFlow Client + HTTP Server tracking ('MLFLOW_TRACKING_URI="http://localhost:5003"')](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#4-scenario-3-mlflow-client--http-tracking-server-mlflow_tracking_urihttplocalhost5003)
        - [4.1 Set HTTP Tracking server's 'Backend store' and the MLFlow Client's 'Artifacts store' locally](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#41-set-http-tracking-servers-backend-store-and-the-mlflow-clients-artifacts-store-locally)
        - [4.2 Launch a new local MLFlow Tracking server (Scenario 3b)](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#42-launch-a-new-local-mlflow-tracking-server-scenario-3b)
        - [4.3 The 'quickstart' example  under Scenario 3b](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#43-the-quickstart-example-under-scenario-3b)
    - [5. Execute the 'Palmer pinguins' example under Scenario 3b](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#5-execute-the-palmer-pinguins-example-under-scenario-3b)
        - [5.1 Notebook 1_Run_and_track_experiments.ipynb](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#51-notebook-1_run_and_track_experimentsipynb)
        - [5.2 Tracking training code and model with MLflow.](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#52-tracking-training-code-and-model-with-mlflow)
    - [6. Summary](./2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3/README.md#7-summary)

- [3_MLflow_Tracking_Server_in_Docker](./3_MLflow_Tracking_Server_in_Docker/README.md)

    - [1. Introduction](./3_MLflow_Tracking_Server_in_Docker/README.md#1-introduction)
        - [1.1 What is Scenario 3b](./3_MLflow_Tracking_Server_in_Docker/README.md#11-what-is-scenario-3b)
        - [1.2 What are the Benefits of Dockerizing an MLflow Tracking Server?](./3_MLflow_Tracking_Server_in_Docker/README.md#12-what-are-the-benefits-of-dockerizing-an-mlflow-tracking-server)
    - [2. Building a basic Docker image for MLflow](./3_MLflow_Tracking_Server_in_Docker/README.md#2-building-a-docker-image-for-mlflow)
        - [2.1 A basic Docker image: `Dockerfile-as-root`](./3_MLflow_Tracking_Server_in_Docker/README.md#21-a-basic-docker-image-dockerfile-as-root)
        - [2.2 A better Docker image: `Dockerfile-as-user`](./3_MLflow_Tracking_Server_in_Docker/README.md#22-a-better-docker-image-dockerfile-as-user)
        - [2.3 An alternative Docker image: `Dockerfile-conda`](./3_MLflow_Tracking_Server_in_Docker/README.md#23-an-alternative-docker-image-dockerfile-conda)
    - [3. Using MariaDB as Tracking Backend Storage](./3_MLflow_Tracking_Server_in_Docker/README.md#3-using-mariadb-as-tracking-backend-storage)
    - [4. A Docker stack for MLflow](./3_MLflow_Tracking_Server_in_Docker/README.md#4-a-docker-stack-for-mlflow)
    - [5. Dockerized Scenario 3b: MLflow Client + Dockerized HTTP Tracking server ('MLFLOW_TRACKING_URI="http://localhost:5005"'](./3_MLflow_Tracking_Server_in_Docker/README.md#5-dockerized-scenario-3b-mlflow-client--dockerized-http-tracking-server-mlflow_tracking_urihttplocalhost5005)
        - [5.1 Set HTTP Tracking server's 'Backend store' and the MLflow Client's 'Artifacts store'](./3_MLflow_Tracking_Server_in_Docker/README.md#51-set-http-tracking-servers-backend-store-and-the-mlflow-clients-artifacts-store)
        - [5.2 Launch a new Dockerized MLflow Tracking server (Scenario 3b)](./3_MLflow_Tracking_Server_in_Docker/README.md#52-launch-a-new-dockerized-mlflow-tracking-server-scenario-3b)
        - [5.3 The 'quickstart' example under Scenario 3b](./3_MLflow_Tracking_Server_in_Docker/README.md#53-the-quickstart-example-under-scenario-3b)
    - [6. How MLflow records the path to the artifact store for each experiment](./3_MLflow_Tracking_Server_in_Docker/README.md#6-how-mlflow-records-the-path-to-the-artifact-store-for-each-experiment)
    - [7. Summary](./3_MLflow_Tracking_Server_in_Docker/README.md#7-summary)