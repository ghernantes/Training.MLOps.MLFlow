# 2. MLFlow Backend and Artifact Storage. Scenarios 1, 2 and 3
[Go to Root Index](../README.md)

- [1. Introduction](#1-introduction)
- [2. Scenario 1: MLFlow Client tracking. No HTTP Tracking server. ('MLFLOW_TRACKING_URI="file:///tmp/my_tracking"')](#2-scenario-1-mlflow-client-tracking-no-http-tracking-server-mlflow_tracking_urifiletmpmy_tracking)
  - [2.1 Set the MLFlow Client's 'Backend store' and 'Artifacts store'](#21-set-the-mlflow-clients-backend-store-and-artifacts-store)
  - [2.2 Launch the 'mlflow UI' server](#22-launch-the-mlflow-ui-server)
  - [2.3 The 'quickstart' example under Scenario 1](#23-the-quickstart-example-under-scenario-1)
- [3. Scenario 2: MLFlow Client tracking. No HTTP Tracking server. ('MLFLOW_TRACKING_URI="sqlite:///mlruns.db"')](#3-scenario-2-mlflow-client-tracking-no-http-tracking-server-mlflow_tracking_urisqlitemlrunsdb)
  - [3.1 Set the MLFlow Client's 'Backend store' in a local SQLite database and 'Artifacts store' in a local folder](#31-set-the-mlflow-clients-backend-store-in-a-local-sqlite-database-and-artifacts-store-in-a-local-folder)
  - [3.2 Launch the 'mlflow UI' server](#32-launch-the-mlflow-ui-server)
  - [3.3 The 'quickstart' example under Scenario 2](#33-the-quickstart-example-under-scenario-2)
- [4. Scenario 3: MLFlow Client + Server  tracking ('MLFLOW_TRACKING_URI="http://localhost:5000"')](#4-scenario-3-mlflow-client--http-tracking-server-mlflow_tracking_urihttplocalhost5000)
  - [4.1 Set HTTP Tracking server's 'Backend store' and the MLFlow Client's 'Artifacts store' locally](#41-set-http-tracking-servers-backend-store-and-the-mlflow-clients-artifacts-store-locally)
  - [4.2 Launch a new local MLFlow Tracking server](#42-launch-a-new-local-mlflow-tracking-server)
  - [4.3 The 'quickstart' example  under Scenario 3b](#43-the-quickstart-example-under-scenario-3b)
- [5. Execute the 'Palmer pinguins' example under Scenario 3b](#5-execute-the-palmer-pinguins-example-under-scenario-3b)

## 1. Introduction
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

**MlFlow tracking** is implemented by means of an **MLFlow client-server** pair:

- The **MLFlow client** implements the former `log_param(), log_metric() and log_artifacts()` function calls, which are part of the API known as the **MLflow Tracking API**.
- The **MLFlow client** can then communicate to the **MLFlow server**, depending on how the env variable `MLFLOW_TRACKING_URL` is configured for the client.

Addtionally, for storing runs and artifacts, the MLFlow client and/or server can use two storage components:
- The **Backend store**:
  - persists MLFlow entities (runs, parameters, metrics, tags, notes, metadata, etc)
  - implementation:
    - `AbstractStore` abstract class .
    - `FileStore`, `RestStore`, and `SQLAlchemyStore` are concrete implementations of the abstract class `AbstractStore`.
- The **Artifact store**:
  - persists artifacts (files, models, images, in-memory objects, or model summary, etc)
  - implementation:
    - `ArtifactRepository`abstract class .
    - `LocalArtifactRepository`, `AzureBlobArtifactRepository` and `S3ArtifactRepository` are concrete implementations of the abstract class `ArtifactRepository`.

Depending on how you configure the storage of your MLFlow client and/or server instances, you will have several scenarios.

In this lab/article, you will practice 3 basic scenarios.

To do that, create your own `project/poc` folder, and `cd` into it. You can create a copy of this `2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3` repo folder. I will refer to it as `poc2` to abbreviate.

Open three different terminals under `poc2`:.

- Terminal 1: to inspect folder contents
- Terminal 2: to run mlflow servers
- Terminal 3: to run experiments

Let's inspect `poc2` folder. On **terminal 1** under `poc2`, run `tree .`:

```bash
$ tree .
.
├── README.md
├── db
│   └── ...
├── examples
│   ├── quickstart
│   │   ├── img
│   │   │   ├── ...
│   │   └── mlflow_tracking.py
│   └── palmer_pinguins
│       ├── data
│       │   └── penguins_classification.csv
│       ├── img
│       │   ├── ...
│       └── notebooks
│           ├── 1_Run_and_track_experiments.ipynb
│           ├── 2_Deploy_and_manage.ipynb
│           └── 3_Tips_and_tricks.ipynb

├── mlflow
│   ├── Docker_PoCs
│   │   └── ...
│   ├── Dockerfile
│   ├── Dockerfile-conda
│   ├── Dockerfile-conda-dev
│   ├── conda.yml
│   ├── entrypoint-dev.sh
│   ├── entrypoint.sh
├── docker-compose.yml
├── show_all.sh
├── stack_deploy.sh
└── stack_remove.sh
```

We have two examples:

- **Quickstart**: a very simple ML modular example.
- **Palmer Pinguins**: an ML notebook example.

Let's run first the Quickstar example under those three basic scenarios:

- **Scenario 1**: client tracking on folders: with `MLFLOW_TRACKING_URI="./mlruns"` (No HTTP Tracking server)
- **Scenario 2**: client tracking on database, such as SQLite: with `MLFLOW_TRACKING_URI="sqlite:///mlruns.db"` (No HTTP Tracking server)
- **Scenario 3**: server tracking on folders/database: with `MLFLOW_TRACKING_URI="http://localhost:5000"')

## 2. Scenario 1: MLFlow Client tracking. No HTTP Tracking server. ('MLFLOW_TRACKING_URI="file:///tmp/my_tracking"')
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

In this scenario:

- The **MLFlow client** directly interfaces with an instance of a `FileStore` and `LocalArtifactRepository`
- Both, **backend store** and **artifact store**, share a directory on the (local) filesystem: `./mlruns`, and

<img src='./examples/quickstart/img/scenario_1.png' alt='' width='380'>

### **2.1 Set the MLFlow Client's 'Backend store' and 'Artifacts store'**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

To set your backend and artifacts stores locally, use:

- relative paths such as: `mlflow.set_tracking_uri("./mlruns)`
- in general, you can use: `mlflow.set_tracking_uri("file:///tmp/my_tracking")`, as for example: `mlflow.set_tracking_uri("file://$PWD/mlruns")`

```python
import os
from random import random, randint
from mlflow import set_tracking_uri, get_tracking_uri, log_metric, log_param, log_artifacts

if __name__ == "__main__":
    set_tracking_uri("./mlruns")                  # You specify a file store backend as './path_to_store' relative path or 'file:///path_to_store' full path
                                                  # Default is './mlruns'. Used as backend store and artifacts store. You can use 'file://$PWD/mlruns' too.
...
```
More info at: https://mlflow.org/docs/latest/tracking.html#scenario-1-mlflow-on-localhost

### **2.2 Launch the 'mlflow UI' server**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

We can launch locally the mlflow UI server with:

```bash
$ mlflow ui --port 5001
```

This launches a **'MLFlow UI server'** at http://127.0.0.1:5001 with the following default **'MLFlow Client'** backend and artifact store configuration:

```bash
mlflow server --backend-store-uri ./mlruns --default-artifact-root ./mlruns--host 0.0.0.0 --port 5000
```

Go to **terminal 2**, move under `poc2/mlflow` folder and run `mlflow ui`:

```bash
$ conda activate mlflow --port 5001
(mlflow)$
(mlflow)$ cd mlflow
(mlflow)$ mlflow ui
[2023-03-06 11:21:15 +0100] [97269] [INFO] Starting gunicorn 20.1.0
[2023-03-06 11:21:15 +0100] [97269] [INFO] Listening at: http://127.0.0.1:5001 (97269)
[2023-03-06 11:21:15 +0100] [97269] [INFO] Using worker: sync
[2023-03-06 11:21:15 +0100] [97270] [INFO] Booting worker with pid: 97270
[2023-03-06 11:21:15 +0100] [97271] [INFO] Booting worker with pid: 97271
[2023-03-06 11:21:15 +0100] [97272] [INFO] Booting worker with pid: 97272
[2023-03-06 11:21:15 +0100] [97273] [INFO] Booting worker with pid: 97273
```



Open our initial **terminal 1** under the `poc2` and run `tree .`:

```bash
$ tree .
.
├── README.md
├── db
│   ├── db_volume_backup.sh
│   ├── db_volume_restore.sh
│   └── volumes_backups
├── examples
│   ├── palmer_pinguins
│   │   ├── data
│   │   │   └── penguins_classification.csv
│   │   ├── img
│   │   │   ├── ...
│   │   └── notebooks
│   │       ├── 1_Run_and_track_experiments.ipynb
│   │       ├── 2_Deploy_and_manage.ipynb
│   │       └── 3_Tips_and_tricks.ipynb
│   └── quickstart
│       ├── img
│       │   ├── mlflow_ui_quickstart_first_run_details.png
│       │   └── mlflow_ui_quickstart_runs_list.png
│       └── mlflow_tracking.py
├── mlflow
│   ├── Docker_PoCs
│   │   └── ...
│   ├── Dockerfile
│   ├── Dockerfile-conda
│   ├── Dockerfile-conda-dev
│   ├── conda.yml
│   ├── entrypoint-dev.sh
│   ├── entrypoint.sh
│   └── mlruns                <- This folder is created
│       ├── 0
│       │   └── meta.yaml
│       └── models
├── docker-compose.yml
├── show_all.sh
├── stack_deploy.sh
└── stack_remove.sh
```

Observe how the `mlruns` folder is created under `mlflow`.

Under `mlruns` we have the 'Default' experiment (folder 0) and no runs.

```bash
$ tree .
.
├── ...
├── mlflow
│   └── mlruns
│       ├── 0
│       │   └── meta.yaml
│       └── models
```

This `mlruns` folder is now monitored by our running **'MLFlow UI server'** running on **terminal 2**, and published on [http://localhost:5000](http://localhost:5000).

<img src='./examples/quickstart/img/mlflow_ui_default_runs_list.png' alt='' width='1000'>

### **2.3 The 'quickstart' example under Scenario 1**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

Move to **terminal 3**, activate the `mlflow` conda env, cd under `poc2/mlflow` folder and run `mlflow_tracking.py`:

```bash
$ conda activate mlflow
(mlflow)$
(mlflow)$ export MLFLOW_TRACKING_URI="./mlruns"
(mlflow)$ python ../examples/quickstart/mlflow_tracking.py
Current tracking uri: ./mlruns
2023/03/06 15:38:14 INFO mlflow.tracking.fluent: Experiment with name 'quickstar' does not exist. Creating a new experiment.
Current working directory: /home/gustavo/training/Training.MLOPs.MLFlow/poc2/mlflow
```

In this simple scenario, the MLFlow client uses the following interfaces to record MLFlow entities and artifacts:

- An instance of a `FileStore` (to save MLFlow entities)
- An instance of a `LocalArtifactRepository` (to store artifacts)

Now, our `poc2/mlflow/mlruns` has a new experiment `395173098808783198` and a new run `d918463610894225b2c5d3856ba06870`.

Move to the terminal 1 under `poc2` and this time run `tree mlflow`:

```bash
$ tree mlflow

mlflow
├── ...
└── mlruns
    ├── 0
    │   └── meta.yaml
    ├── 395173098808783198
    │   ├── d918463610894225b2c5d3856ba06870
    │   │   ├── artifacts
    │   │   │   └── test.txt
    │   │   ├── meta.yaml
    │   │   ├── metrics
    │   │   │   └── foo
    │   │   ├── params
    │   │   │   └── param1
    │   │   └── tags
    │   │       ├── mlflow.runName
    │   │       ├── mlflow.source.git.commit
    │   │       ├── mlflow.source.name
    │   │       ├── mlflow.source.type
    │   │       └── mlflow.user
    │   └── meta.yaml
    └── models
```

Have a look at the **'MLFlow UI server'** to see how it played out!

<img src='./examples/quickstart/img/mlflow_ui_quickstart_scenario1_runs_list.png' alt='' width='1000'>

<img src='./examples/quickstart/img/mlflow_ui_quickstart_scenario1_first_run_details.png' alt='' width='1000'>


## 3. Scenario 2: MLFlow Client tracking. No HTTP Tracking server. (`MLFLOW_TRACKING_URI="sqlite:///mlruns.db"`)
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

In this scenario:

- The **MLFlow client** directly interfaces with:
  - an instance of a `SQLAlchemyStore`.
      - **Backend store**: MLFlow entities are inserted in a (local) SQLite database file `mlruns.db`
  - an instance of `LocalArtifactRepository`.
      - **Artifact store**: artifacts are stored under the (local) `./mlruns` directory


<img src='./examples/quickstart/img/scenario_2.png' alt='' width='380'>

### **3.1 Set the MLFlow Client's 'Backend store' in a local SQLite database and 'Artifacts store' in a local folder**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

To set your backend and artifacts stores:

- Instrument your training code by using: `mlflow.set_tracking_uri("sqlite:///mlruns.db")`

 ```python
 import os
 from random import random, randint
 from mlflow import set_tracking_uri, get_tracking_uri, log_metric, log_param, log_artifacts

 if __name__ == "__main__":
     set_tracking_uri("sqlite:///mlruns.db")   # backend store: SQLite database local file ./mlruns.db
                                               # artifacts store: artifacts are stored under the local ./mlruns directory
 ...
 ```
- Alternativelly, set and export the environment variable: `MLFLOW_TRACKING_URI="sqlite:///mlruns.db"` where the training code is executed.

You specify a database-backed store as SQLAlchemy database URI. The database SQLAlchemy URI typically takes the format:

`<dialect>+<driver>://<username>:<password>@<host>:<port>/<database>`

- dialect: MLFlow supports the database dialects mysql, mssql, sqlite, and postgresql.
- driver: is optional. If you do not specify a driver, SQLAlchemy uses a dialect’s default driver.

More info at: https://mlflow.org/docs/latest/tracking.html#scenario-2-mlflow-on-localhost-with-sqlite


### **3.2 Launch the 'mlflow UI' server**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

We can launch locally the mlflow UI server with:

```bash
$ mlflow ui --backend-store-uri sqlite:///mlruns.db --port 5002
```

This launches an **'MLFlow UI server'** at http://127.0.0.1:5002 with the following **'MLFlow Client'** backend and artifact store configuration.

```bash
$ mlflow ui --backend-store-uri sqlite:///mflow.db --default-artifact-root ./mlruns --host 0.0.0.0 --port 5002
```

Open **terminal 2** and check if other `mlflow ui` process is still running under `poc2/mlflow`.

Stop that service (`Ctrl+c`) and run:

```bash
$ mlflow ui --backend-store-uri sqlite:///mflow.db --port 5002
...
...
```



Open our initial **terminal 1** under the poc2 and run `tree mkflow`:

```bash
$ tree mkflow

mlflow
├── ...
├── mflow.db    <- This SQLite database file is created
└── mlruns
    ├── 0
    │   └── meta.yaml
    ├── 251178759845618556
    │   ├── 776d05ad8fb2418a9eda06b3adaf27c2
    │   │   ├── artifacts
    │   │   │   └── test.txt
    │   │   ├── meta.yaml
    │   │   ├── metrics
    │   │   │   └── foo
    │   │   ├── params
    │   │   │   └── param1
    │   │   └── tags
    │   │       ├── mlflow.runName
    │   │       ├── mlflow.source.git.commit
    │   │       ├── mlflow.source.name
    │   │       ├── mlflow.source.type
    │   │       └── mlflow.user
    │   └── meta.yaml
    └── models
```

Observe how the `mflow.db` SQLite database file has been created under the `mlflow` folder. In this Scenario 2, this database is used directly by the **MLFlow Client**, throughout the`SQLAlchemyStore` interface.

### **3.3 The 'quickstart' example under Scenario 2**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

Move to **terminal 3**. The `mlflow` conda env should be still activated, and the working directory should be `poc2/mlflow`.

Under this folder run `mlflow_tracking.py` again, but this time change the `MLFLOW_TRACKING_URI ` as in the following code:

```bash
$ conda activate mlflow
(mlflow)$
(mlflow)$ export MLFLOW_TRACKING_URI="sqlite:///mflow.db"
(mlflow)$
(mlflow)$ python ../examples/quickstart/mlflow_tracking.py
Current tracking uri: sqlite:///mflow.db
2023/03/06 17:07:50 INFO mlflow.tracking.fluent: Experiment with name 'quickstar' does not exist. Creating a new experiment.
Current working directory: /home/gustavo/training/Training.MLOps.MLFlow/poc2/mlflow
Directory 'examples/quickstart/outputs' created
Artifacts in 'examples/quickstart/outputs' tracked!
Directory 'examples/quickstart/outputs' has been removed successfully
```

In this simple scenario, the **MLFlow Client** uses the following interfaces to record MLFlow entities and artifacts:

- An instance of a `SQLAlchemyStore` (to save MLFlow entities)
- An instance of a `LocalArtifactRepository` (to store artifacts)

Now, our `poc2/mlflow/mlruns` folder has a new experiment `1` and a new run `73b821edb9f54f82a72ec44fac9ff171`, containing the logged artifacts for that run.

Additionally, the `poc2/mlflow/mlruns.db` SQLite database file has been used to track MLFlow entities, including the parameters and metrics of that `73b821edb9f54f82a72ec44fac9ff171` run.

Move to **terminal 1** and run `tree mlflow` again:

```bash
$ tree mlflow

mlflow
├── Docker_PoCs
│   └── ...
├── Dockerfile
├── Dockerfile-dev
├── conda.yml
├── entrypoint-dev.sh
├── entrypoint.sh
├── examples
│   └── quickstart
├── mlruns
│   ├── 0
│   │   └── meta.yaml
│   ├── 1
│   │   └── 73b821edb9f54f82a72ec44fac9ff171
│   │       └── artifacts
│   │           └── test.txt
    ├── 395173098808783198
    │   ├── d918463610894225b2c5d3856ba06870
│   │   │   ├── artifacts
│   │   │   │   └── test.txt
│   │   │   ├── meta.yaml
│   │   │   ├── metrics
│   │   │   │   └── foo
│   │   │   ├── params
│   │   │   │   └── param1
│   │   │   └── tags
│   │   │       ├── mlflow.runName
│   │   │       ├── mlflow.source.git.commit
│   │   │       ├── mlflow.source.name
│   │   │       ├── mlflow.source.type
│   │   │       └── mlflow.user
│   │   └── meta.yaml
│   └── models
└── mlruns.db
```

Have a look at the **'MLFlow UI server'** to see how it played out!

<img src='./examples/quickstart/img/mlflow_ui_quickstart_scenario2_runs_list.png' alt='' width='1000'>

<img src='./examples/quickstart/img/mlflow_ui_quickstart_scenario2_first_run_details.png' alt='' width='1000'>

**Note:**

Because the **MLFlow Client** is now using the `SQLAlchemyStore` interface and SQLite as Backend store, all runs performed with `FileStore` in Scenario 1 are not available in our **MLFlow UI**. To recover those runs, relaunch the service on **terminal 2** with:

```bash
mlflow ui
```

or

```bash
mlflow server --backend-store-uri mlruns/ --default-artifact-root mlruns/ --host 0.0.0.0 --port 5000
```

## 4. Scenario 3: MLFlow Client + HTTP Tracking server ('MLFLOW_TRACKING_URI="http://localhost:5000"')
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

In this scenario:

- The **MLFlow client** directly interfaces with:
    - an instance of `LocalArtifactRepository`.
      - the **Artifact Store** is under `./mlruns/` folder), and
    - an instance of `RestStore` to reach the **MLFlow Tracking server**

- The **MLFlow Tracking server**:
    - interfaces with (depending on the specified configuration):
      -  an instance of `FileStore`:
          - the **Backend Store** is under `./mlruns/` folder (Scenario 3a), or
      -  an instance of `SQLAlchemyStore`:
          - the **Backend Store** is in `mlruns.db` SQLite database file (Scenario 3b)
    - artifact serving is disabled (by using `--no-serve-artifacts` option)

<img src='./examples/quickstart/img/scenario_3.png' alt='' width='520'>

### **4.1 Set HTTP Tracking server's 'Backend store' and the MLFlow Client's 'Artifacts store' locally**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

To set your backend and artifacts stores:

- First, tell the **MLFlow client** that will work together with an **MLFlow HTTP tracking server**:
  - Instrumenting the training code with: `mlflow.set_tracking_uri("http://my-tracking-server:5003")`
    ```python
    import os
    from random import random, randint
    from mlflow import set_tracking_uri, get_tracking_uri, log_metric, log_param, log_artifacts

    if __name__ == "__main__":
      set_tracking_uri("http://localhost:5003")            # Scenario 3
    ...
    ```
  - Or setting and exporting the environment variable: `MLFLOW_TRACKING_URI="http://localhost:5000"` where the training code is executed.

- Then, launch the **MLFlow HTTP tracking server** with:

  ```bash
  mlflow server \
  --backend-store-uri ./mlruns \                # backend store: local folder under ./mlruns (see flow: 1a --> 1b)
  --default-artifact-root ./mlruns \            # artifacts store: artifacts are stored under the same local ./mlruns directory
  --no-serve-artifacts \                        # the server doesn't manage the artifact store: log_artifact() http requests are sent to the client
  --host 0.0.0.0 --port 5003                    #                                               (see flow: 2a --> 2b --> 2c)
  ```

  or:

  ```bash
  mlflow server \
  --backend-store-uri sqlite:///mlruns.db \     # backend store: SQLite database local file ./mlruns.db
  --default-artifact-root ./mlruns \            # artifacts store: artifacts are stored under the local ./mlruns directory
  --no-serve-artifacts \
  --host 0.0.0.0 --port 5003
  ```

Notes:

- `--default-artifact-root` is required when backend store is not local file based and artifact serving is disabled.
- In the last case, the SQLite DB file is created for us.

More info at: https://mlflow.org/docs/latest/tracking.html#scenario-3-mlflow-on-localhost-with-tracking-server

#mlflow.set_tracking_uri("databricks://<profileName>")


### **4.2 Launch a new local MLFlow Tracking server**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

Open **terminal 2** and stop any service (`Ctrl+c`) running under `poc2/mlflow`.

Now run:


  ```bash
  $ mlflow server --backend-store-uri sqlite:///mflow.db --default-artifact-root ./mlruns --no-serve-artifacts --host 0.0.0.0 --port 5003

  2023/02/24 15:03:44 INFO mlflow.store.db.utils: Creating initial MLFlow database tables...
  2023/02/24 15:03:44 INFO mlflow.store.db.utils: Updating database tables
  INFO  [alembic.runtime.migration] Context impl SQLiteImpl.
  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
  INFO  [alembic.runtime.migration] Running upgrade  -> 451aebb31d03, add metric step
  INFO  [alembic.runtime.migration] Running upgrade 451aebb31d03 -> 90e64c465722, migrate user column to tags
  INFO  [alembic.runtime.migration] Running upgrade 90e64c465722 -> 181f10493468, allow nulls for metric values
  INFO  [alembic.runtime.migration] Running upgrade 181f10493468 -> df50e92ffc5e, Add Experiment Tags Table
  INFO  [alembic.runtime.migration] Running upgrade df50e92ffc5e -> 7ac759974ad8, Update run tags with larger limit
  INFO  [alembic.runtime.migration] Running upgrade 7ac759974ad8 -> 89d4b8295536, create latest metrics table
  INFO  [89d4b8295536_create_latest_metrics_table_py] Migration complete!
  INFO  [alembic.runtime.migration] Running upgrade 89d4b8295536 -> 2b4d017a5e9b, add model registry tables to db
  INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Adding registered_models and model_versions tables to database.
  INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Migration complete!
  INFO  [alembic.runtime.migration] Running upgrade 2b4d017a5e9b -> cfd24bdc0731, Update run status constraint with killed
  INFO  [alembic.runtime.migration] Running upgrade cfd24bdc0731 -> 0a8213491aaa, drop_duplicate_killed_constraint
  INFO  [alembic.runtime.migration] Running upgrade 0a8213491aaa -> 728d730b5ebd, add registered model tags table
  INFO  [alembic.runtime.migration] Running upgrade 728d730b5ebd -> 27a6a02d2cf1, add model version tags table
  INFO  [alembic.runtime.migration] Running upgrade 27a6a02d2cf1 -> 84291f40a231, add run_link to model_version
  INFO  [alembic.runtime.migration] Running upgrade 84291f40a231 -> a8c4a736bde6, allow nulls for run_id
  INFO  [alembic.runtime.migration] Running upgrade a8c4a736bde6 -> 39d1c3be5f05, add_is_nan_constraint_for_metrics_tables_if_necessary
  INFO  [alembic.runtime.migration] Running upgrade 39d1c3be5f05 -> c48cb773bb87, reset_default_value_for_is_nan_in_metrics_table_for_mysql
  INFO  [alembic.runtime.migration] Running upgrade c48cb773bb87 -> bd07f7e963c5, create index on run_uuid
  INFO  [alembic.runtime.migration] Running upgrade bd07f7e963c5 -> 0c779009ac13, add deleted_time field to runs table
  INFO  [alembic.runtime.migration] Running upgrade 0c779009ac13 -> cc1f77228345, change param value length to 500
  INFO  [alembic.runtime.migration] Running upgrade cc1f77228345 -> 97727af70f4d, Add creation_time and last_update_time to experiments table
  INFO  [alembic.runtime.migration] Context impl SQLiteImpl.
  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
  [2023-02-24 15:03:45 +0100] [29892] [INFO] Starting gunicorn 20.1.0
  [2023-02-24 15:03:45 +0100] [29892] [INFO] Listening at: http://0.0.0.0:5003 (29892)
  [2023-02-24 15:03:45 +0100] [29892] [INFO] Using worker: sync
  [2023-02-24 15:03:45 +0100] [29893] [INFO] Booting worker with pid: 29893
  [2023-02-24 15:03:45 +0100] [29909] [INFO] Booting worker with pid: 29909
  [2023-02-24 15:03:45 +0100] [29910] [INFO] Booting worker with pid: 29910
  [2023-02-24 15:03:45 +0100] [29911] [INFO] Booting worker with pid: 29911
  [2023-02-24 15:03:47 +0100] [29892] [INFO] Handling signal: winch
  ```


### **4.3 The 'quickstart' example under Scenario 3b**
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

Move to terminal 3. The mlflow conda env should be still activated, and the working directory should be poc2/mlflow.

Under this folder run mlflow_tracking.py again, but this time change the MLFLOW_TRACKING_URI as in the following code:

```bash
$ conda activate mlflow
(mlflow)$
(mlflow)$ export MLFLOW_TRACKING_URI="http://localhost:5003"
(mlflow)$
(mlflow)$ python ../examples/quickstart/mlflow_tracking.py
Current tracking uri: http://localhost:5003
Current working directory: /home/gustavo/training/Training.MLOps.MLFlow/poc2/mlflow
Directory 'examples/quickstart/outputs' created
Artifacts in 'examples/quickstart/outputs' tracked!
Directory 'examples/quickstart/outputs' has been removed successfully
```


## 5. Execute the 'Palmer pinguins' example under Scenario 3b
[Go to Index](#2-mlflow-backend-and-artifact-storage-scenarios-1-2-and-3)

Open the following notebook:

[1_Run_and_track_experiments.ipynb](./examples/palmer_pinguins/notebooks/1_Run_and_track_experiments.ipynb)

and execute it. You will have:

```bash
tree .
.
├── README.md
├── examples
│   ├── palmer_pinguins
│   │   ├── data
│   │   │   └── penguins_classification.csv
│   │   ├── notebooks
│   │   │   ├── 1_Run_and_track_experiments.ipynb
│   │   │   ├── 2_Deploy_and_manage.ipynb
│   │   │   └── 3_Tips_and_tricks.ipynb
│   │   └── resources
│   │       ├── culmen_depth.png
│   │       ├── mlflow_ui_pinguins_experiment_first_run_details.png
│   │       ├── mlflow_ui_pinguins_experiment_runs_list.png
│   │       ├── palmer_penguins.png
│   │       └── tracking_setup.png
│   └── quickstart
│       ├── mlflow_tracking.py
│       └── outputs
│           └── test.txt
├── mflow.db
└── mlruns
    ├── 1
    │   └── 2f4534550a1c41188a94dd99d7035923
    │       └── artifacts
    │           └── test.txt
    └── 2
        └── 0e316a57136a4e6d878ec53a7a78f18e
            └── artifacts
                └── 1_Run_and_track_experiments.ipynb
```

Have a look at the tracking UI to see how it played out!

<img src='./examples/palmer_pinguins/img/mlflow_ui_pinguins_experiment_runs_list_2.png' alt='' width='1000'>

<img src='./examples/palmer_pinguins/img/mlflow_ui_pinguins_experiment_first_run_details_2.png' alt='' width='1000'>
