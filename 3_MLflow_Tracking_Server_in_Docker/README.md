# 3. Move your MLflow Tracking server to Docker
[Go to Root Index](../README.md)

- [1. What are the Benefits of Dockerizing an MLflow Tracking Server?](./README.md#1-what-are-the-benefits-of-dockerizing-an-mlflow-tracking-server)
- [2. Building a basic Docker image for MLflow](#2-building-a-basic-docker-image-for-mlflow)
- [3. Using MariaDB as Tracking Backend Storage](#3-using-mariadb-as-tracking-backend-storage)
- [4. Creating the Docker stack for MLflow](#4-creating-the-docker-stack-for-mlflow)
- [5. Dockerized Scenario 3b: MLflow Client + Dockerized HTTP Tracking server ('MLFLOW_TRACKING_URI="http://localhost:5005"'](#5-dockerized-scenario-3b-mlflow-client--dockerized-http-tracking-server-mlflow_tracking_urihttplocalhost5005)
    - [5.1 Set HTTP Tracking server's 'Backend store' and the MLflow Client's 'Artifacts store'](#51-set-http-tracking-servers-backend-store-and-the-mlflow-clients-artifacts-store)
    - [5.2 Launch a new Dockerized MLflow Tracking server (Scenario 3b)](#52-launch-a-new-dockerized-mlflow-tracking-server-scenario-3b)
    - [5.3 The 'quickstart' example under Scenario 3b](#53-the-quickstart-example-under-scenario-3b)
- [6. Building a non-root Docker image for MLflow and installing depencies with conda](#6-building-a-non-root-docker-image-for-mlflow-and-installing-depencies-with-conda)
- [7. Summary](./README.md#7-summary)

You can access the article code on the following GitHub repository:

[https://github.com/ghernantes/Training.MLOps.MLFlow/blob/main/3_MLflow_Tracking_Server_in_Docker](https://github.com/ghernantes/Training.MLOps.MLFlow/blob/main/2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3)

<img src='./examples/quickstart/img/Mr_robot_presenting_the_basic_scenarios_of_MLflow.png' alt='' width='800'>

## 1. What are the Benefits of Dockerizing an MLflow Tracking Server?
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

Docker offers a range of benefits that are well-known. Let's take a quick look at the advantages of dockerizing an MLflow tracking server:

- **Portability**: containers can run on different operating systems and environments, making it easy to deploy the MLflow tracking server in any environment that supports Docker.
- **Isolation**: containers provide an isolated environment for the MLflow tracking server, ensuring that it runs in a controlled environment without any conflicts with other applications or services running on the same host.
- **Consistency**: containers provide a consistent environment for running the MLflow tracking server, regardless of the underlying host operating system or environment. This ensures that the MLflow tracking server runs consistently across different environments.
- **Scalability**: containers can be easily scaled up or down based on the workload demands, making it easy to handle increased traffic or workload.
- **Easy updates**: docker containers can be easily updated to the latest version of MLflow or other dependencies without affecting the underlying host system.
- **Reproducibility**: containers allow you to easily reproduce the environment in which the MLflow tracking server was running, making it easy to debug or troubleshoot issues.

Overall, Dockerizing an MLflow tracking server can simplify deployment, improve scalability, and provide a consistent and isolated environment for running the server.



## 2. Building a basic Docker image for MLflow
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

This section proposes a `Dockerfile` that can be used as a starting point for building a basic Docker image for MLflow:

```Dockerfile
FROM python:3.10-slim

RUN apt-get update && apt-get -y upgrade \
    && pip install --upgrade pip \
    && pip --version

RUN apt-get update && apt-get install -y procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /mlflow/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && rm requirements.txt

EXPOSE 5000

CMD mlflow server --backend-store-uri ${BACKEND_STORE_URI} \
                  --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} \
                  --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} \
                  --no-serve-artifacts \
                  --host 0.0.0.0 --port 5000
```

Use official base images whenever possible, as they are well-maintained and typically have smaller image sizes. The Dockerfile begins by using a slim version of Python 3.10 as the base image. Slim versions are stripped-down versions that contain only the essential components needed to run Python 3.10. This results in image sizes that are even smaller, which in turn consume fewer resources (CPU, memory, and disk space). Additionally, slim versions have a reduced attack surface, making them less vulnerable to security threats. All of these benefits lead to faster image build times, quicker deployments, and improved portability across different environments due to fewer dependencies and compatibility issues.

It is generally a good idea to update all packages of the Linux distribution used as a base image when writing a Dockerfile. This helps ensure that the image is built with the latest security patches and bug fixes. However, it is important to consider the implications of updating all packages. For example, updating certain packages could introduce compatibility issues with the application being built, or could result in the image being larger in size than necessary. Additionally, updating packages can increase the build time for the image. Thus, it is important to find a balance between updating packages and maintaining image size and compatibility. One way to ensure this is to thoroughly test the image by running multiple training experiments to confirm the expected behavior of your tacking server before tagging the image it as a stable version.

The package list is updated, and all installed packages are upgraded, which were present in the slim version. The `pip` package manager is then installed, followed by the installation of the `procps` package that provides utilities for monitoring system resources. Lastly, the package list files are removed to save disk space.

To improve clarity, two `RUN` commands are used here. However, it is important to keep in mind that minimizing the number of layers in your Docker image is a good practice that can help reduce both build times and image size.

The working directory inside the container is set to `/mlflow/`, and the `requirements.txt` file is copied from the current directory to `/mlflow/`.

Next, all Python packages listed in `requirements.txt` are installed using `pip install`. Packages specified in `requirements.txt` are:

```text
mlflow==2.2.1
pymysql
```

To avoid caching pip packages, the `--no-cache-dir` flag is used. Finally, the `requirements.txt` file is removed to save disk space.

The container's port `5000` is then exposed to the host.

Lastly, the command to be executed when the container starts is specified with `CMD`. This starts the MLflow server using the specified command-line options and environment variables (`BACKEND_STORE_URI`, `DEFAULT_ARTIFACT_ROOT`, and `DEFAULT_ARTIFACTS_DESTINATION`). The server listens on all network interfaces (`0.0.0.0`) on port `5000` and does not serve artifacts.

To build the image, you can use:

```bash
$ docker build -t mlflow_tracker_slim .

[+] Building 1.5s (11/11) FINISHED
 => [internal] load build definition from Dockerfile                                                                       0.0s
 => => transferring dockerfile: 27.25kB                                                                                    0.0s
 => [internal] load .dockerignore                                                                                          0.0s
 => => transferring context: 171B                                                                                          0.0s
 => [internal] load metadata for docker.io/library/python:3.10-slim                                                        1.3s
 => [1/6] FROM docker.io/library/python:3.10-slim@sha256:7b0a5cefbcdd085faa21533c21549e55a7e66f5aed40f8d1f4de13a017e352cd  0.0s
 => [internal] load build context                                                                                          0.0s
 => => transferring context: 64B                                                                                           0.0s
 => CACHED [2/6] RUN apt-get update && apt-get -y upgrade     && pip install --upgrade pip     && pip --version            0.0s
 => CACHED [3/6] RUN apt-get update && apt-get install -y procps     && rm -rf /var/lib/apt/lists/*                        0.0s
 => CACHED [4/6] WORKDIR /mlflow/                                                                                          0.0s
 => CACHED [5/6] COPY requirements.txt .                                                                                   0.0s
 => CACHED [6/6] RUN pip install --no-cache-dir -r requirements.txt     && rm requirements.txt                             0.0s
 => exporting to image                                                                                                     0.0s
 => => exporting layers                                                                                                    0.0s
 => => writing image sha256:ed76b0b423ec158937a32de523ce2392eb155283116a39d8f45607f56aa479d4                               0.0s
 => => naming to docker.io/library/mlflow_tracker_slim                                                                     0.0s
```

To obtain more information about the building process and to ensure that cached layers are not used, I typically include the `--progress plain` and `--no-cache options` respectively:

```bash
$ docker build --progress plain --no-cache -t mlflow_tracker_slim .
```

Find the complete log of the previous command at the end of the [`Dockerfile`](./mlflow/Dockerfile)

## 3. Using MariaDB as Tracking Backend Storage
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

In MLflow, `SQLAlchemyStore` is a class that provides an implementation of `AbstractStore`, an abstract base class for storing and managing artifacts and metadata produced during the machine learning lifecycle. The `SQLAlchemyStore` class is used to store tracking metadata in a SQL database using the **SQLAlchemy library**, which allows it to work with a variety of relational databases, including **`SQLite`** and **`MariaDB`/`MySQL`**.

When using `SQLAlchemyStore`, MLflow automatically creates and manages the necessary database schema to store metadata and artifacts, making it easy to use with minimal configuration. It also supports transactional guarantees and concurrent access to metadata, ensuring consistency and reliability of data stored in the database.

In previous issues, we have used `SQLite` to implement **Sncearios 2 and 3b**. However, `SQLite` may not be the best option in many cases. SQLite is a lightweight, file-based database management system, whereas MariaDB is a robust, scalable, and open-source relational database management system.

Here is a comparison table between SQLite and MariaDB as tracking backend storage in MLflow:

| Feature     | SQLite	                                                              | MariaDB              |
|---          |---                                                                    |---                   |
| Scalability	| Limited	                                                              | Highly scalable |
| Concurrency/Reliability |	Limited, may lead to data corruption in high concurrency environments	| Optimized for high concurrency |
| Performance	| Good for small to medium sized projects	                              | Optimized for larger projects and complex queries |
| Security	  | Basic security features	                                              | Advanced security features |
| Maintenance and Support	| Requires little maintenance, easy to set up	              | Requires more maintenance, good community support |
| Cost	      | Free and open source	                                                | Free and open source, enterprise version available with additional features and support |


Some key differences between the two options when used as tracking backend storage in MLflow, are:

- **Scalability**: SQLite is not well-suited for distributed environments and may not scale well in such cases. MariaDB, on the other hand, is designed to scale horizontally and can handle large datasets across multiple nodes.
- **Concurrency/Reliability**: SQLite is a file-based system, which means that it is susceptible to data loss or corruption if the file becomes corrupted or damaged, specially in high concurrency environments. MariaDB, being a relational database management system, provides more robust data protection mechanisms, such as replication and backup.
- **Performance**: SQLite can handle small to medium datasets with ease, but it may not scale well for large datasets or workloads with high concurrency. On the other hand, MariaDB can handle larger datasets and high concurrency workloads more efficiently.
- **Security**: Both SQLite and MariaDB provide basic security mechanisms such as password protection and access control. However, MariaDB provides more advanced security features, such as data encryption, secure network protocols, and auditing capabilities.
- **Flexibility**: SQLite is a good option for small to medium-sized projects that do not require high performance, scalability, or advanced features. MariaDB, on the other hand, is more flexible and can be customized to meet the specific needs of the project.

It is important to note that the choice between SQLite and MariaDB as the tracking backend storage in MLflow ultimately depends on the specific needs of the project and the resources available. SQLite is a good choice for small to medium-sized projects with modest performance and scalability requirements, while MariaDB is a better option for larger projects that require high performance, scalability, and advanced features such as replication, backup, and security.

To conclude this section, it's worth considering **MyphpAdmin** as an additional component to the stack of apps that could be dockerized along with MLflow o top of MariaDB. MyphpAdmin is a widely used web-based application that is often paired with MariaDB. It is designed to manage and administer MySQL or MariaDB databases through a graphical user interface. With MyphpAdmin, users can perform a range of database-related tasks, such as creating and deleting databases, managing tables and fields, executing SQL queries, and importing and exporting data. Within the scope of MLflow, this tool can be utilized to easily navigate and browse all the accumulated experiment data and perform SQL queries on the tracking database.

## 4. Creating the Docker stack for MLflow
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

The provided Docker Compose file defines the setup for a stack consisting of three services: `mysql`, `phpmyadmin`, and `mlflow`.

- The **`mysql`** service: uses the MariaDB 10.3 image and defines a container name and hostname using environment variables. It also specifies a password file for the root user and mlflow user, both of which are stored as secrets. The service is exposed through two ports, one for MySQL and one for the MySQL admin interface. The database data is stored in a volume mapped to `/var/lib/mysql`.
- The **`phpmyadmin`** service: uses the latest version of the phpMyAdmin image and depends on the `mysql` service. It also defines a container name and hostname using an environment variable, and exposes a port for the phpMyAdmin web interface. The service sets the `PMA_HOST` environment variable to the name of the `mysql` service and specifies the password file for the root user.
- The **`mlflow`** service: builds a custom image from a Dockerfile located in the `./mlflow` directory. It also specifies a container name and hostname using an environment variable, and depends on the `mysql` service. The service is exposed through a port, and the `./mlflow` directory is mounted as a volume to get access to stored MLflow artifacts. The service also specifies a custom command to be executed on container startup using the `entrypoint-pip-dev.sh` script.

The contents of the `docker-compose.yml` file are:

```yaml
version: '3.9'

services:

    mysql:
        image: mariadb:10.3
        container_name: mlflow_mysql_${MYSQL_PORT1}
        hostname: mlflow_mysql_${MYSQL_PORT1}
        #restart: unless-stopped
        env_file:
            - .env                               # Default '--env-file' option: $ docker-compose up -d
        ports:
            - ${MYSQL_PORT1}:3306
            - ${MYSQL_PORT2}:33060
        environment:
            - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/password1
            - MYSQL_DATABASE=${MYSQL_DATABASE}
            - MYSQL_USER=${MYSQL_USER}
            - MYSQL_PASSWORD_FILE=/run/secrets/password2
        secrets:
            - password1
            - password2
        volumes:
            - database_volume:/var/lib/mysql

    phpmyadmin:
        image: phpmyadmin:latest
        container_name: mlflow_phpmyadmin_${PHPMYADMIN_PORT}
        hostname: mlflow_phpmyadmin_${PHPMYADMIN_PORT}
        #restart: unless-stopped
        depends_on:
            - mysql
        env_file:
            - .env                               # Default '--env-file' option: $ docker-compose up -d
        environment:
            PMA_HOST: mysql
            MYSQL_ROOT_PASSWORD_FILE: /run/secrets/password1
        secrets:
            - password1
        ports:
            - ${PHPMYADMIN_PORT}:80

    mlflow:
        build:
          context: ./mlflow
          dockerfile: Dockerfile                 # to build a root image with a system pip install of mlflow
          #dockerfile: Dockerfile-conda          # to build a non-root image with a tailored conda env for mlflow
        image: mlflow_tracker_slim
        container_name: mlflow_tracker_${MLFLOW_PORT}
        hostname: mlflow_phpmyadmin_${MLFLOW_PORT}
        #restart: unless-stopped
        depends_on:
            - mysql
        env_file:
            - .env                               # Default '--env-file' option: $ docker-compose up -d
            - .secrets/env-secrets               # Requires '--env-file' option: $ docker-compose --env-file .env-secrets up -d
        ports:
            - ${MLFLOW_PORT}:5000
        volumes:
            # Artifact store locally available through folder mapping:
            - ./mlflow:/mlflow
        #command: ./entrypoint.sh                # replaces the CMD line in Dockerfile
        command: ./entrypoint-pip-dev.sh         # only for the image built with Dockerfile
        #command: ./entrypoint-conda-dev.sh      # only for the image built with Dockerfile-conda

volumes:
    database_volume:

secrets:                                         # All secrets are stored in the container under: /run/secrets/
    password1:                                   # In this case case we use file secrets. External secrets require Swarm ()
        file: ./.secrets/mysql-root-password.txt
    password2:
        file: ./.secrets/mysql-mlflowuser-password.txt
```

You can retrieve additional information about the running `mlflow` service by optionally configuring the following Bash shell script `entrypoint-pip-dev.sh` as a custom `command`. If you don't need this info, just comment the custom `command` in the previous `docker-compose.yml` file.

The `entrypoint-pip-dev.sh` script code is as follows:

```shell
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

# NOTE: 'mysql' is the service name given to db in the docker-compose.yml file
```

You can see an example of all the logged info that this script can gather at the end of the file [`./mlflow/entrypoint-pip-dev.sh`](./mlflow/entrypoint-pip-dev.sh)

To deploy and remove the stack, use the script files `stack_deploy.sh`:

```shell
#!/bin/sh -eu

set -a
. .env
. .secrets/env-secrets

docker compose up -d
```

and `stack_remove.sh`:

```shell
docker compose down
```

There are two distinct environment variable files available: `.env` and `.secrets\env-secrets`. To bring up the application stack, we can utilize the `stack_deploy.sh` script to load as many environment files as required. The script takes care of loading and exporting all the necessary values to define the environment variables used in the ` docker-compose.yml` file through variable substitution.

Launch a fresh **mlflow server container stack** by executing:

```bash
$ source ./stack_deploy

[+] Running 5/5
 ⠿ Network 3_mlflow_tracking_server_in_docker_default           Created   0.1s
 ⠿ Volume "3_mlflow_tracking_server_in_docker_database_volume"  Created   0.0s
 ⠿ Container mlflow_mysql_3305                                  Started   1.2s
 ⠿ Container mlflow_tracker_5005                                Started   1.8s
 ⠿ Container mlflow_phpmyadmin_8085                             Started   1.9s
```

You can **inspect the state of the stack resources** (containers, volume and network) every second by running:

```bash
$ watch -n 1 ./show_all.sh

Every 1.0s: ./show_all.sh
--> Containers: --------------------------------------------------------------------------------
CONTAINER ID   IMAGE                COMMAND                  CREATED          STATUS         PORTS                        NAMES
6af3ca4fd85f   phpmyadmin:latest    "/docker-entrypoint.…"   38 seconds ago   Up 36 seconds  0.0.0.0:8085->80/tcp         mlflow_phpmyadmin_8085
ea1876e483f8   mlflow_tracker_slim  "./entrypoint-pip-de…"   38 seconds ago   Up 36 seconds  0.0.0.0:5005->5000/tcp       mlflow_tracker_5005
bae76e9417c5   mariadb:10.3         "docker-entrypoint.s…"   38 seconds ago   Up 37 seconds  0.0.0.0:3305->3306/tcp
                                                                                             , 0.0.0.0:33050->33060/tcp   mlflow_mysql_3305
--> Networks: ----------------------------------------------------------------------------------
NETWORK ID     NAME                                          DRIVER    SCOPE
83d41bbecb3d   3_mlflow_tracking_server_in_docker_default    bridge    local
6b95831ec140   bridge                                        bridge    local
ce981cd1c025   host                                          host      local
wbkb4vd1c5c5   ingress                                       overlay   swarm
09bdac50a384   none                                          null      local

--> Volumes: -----------------------------------------------------------------------------------
DRIVER    VOLUME NAME
local     3_mlflow_tracking_server_in_docker_database_volume
```

Finally, you can **remove the stack** with (except the volume):

```bash
$ source ./stack_remove

[+] Running 4/4
 ⠿ Container mlflow_phpmyadmin_8085                         Removed    1.5s
 ⠿ Container mlflow_tracker_5005                            Removed   10.5s
 ⠿ Container mlflow_mysql_3305                              Removed    2.6s
 ⠿ Network 3_mlflow_tracking_server_in_docker_default       Removed    0.3s
```

## 5. Dockerized Scenario 3b: MLflow Client + Dockerized HTTP Tracking server ('MLFLOW_TRACKING_URI="http://localhost:5005"')
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

In this scenario:

- The **MLflow client** directly interfaces with:
    - an instance of `LocalArtifactRepository`.
      - the **Artifact Store** is under `./mlruns/` folder), and
    - an instance of `RestStore` to reach the **MLflow Tracking server**

- The **Dockerized MLflow Tracking server**:
    - interfaces with (depending on the specified configuration):
      -  an instance of `SQLAlchemyStore`:
          - the **Backend Store** is in a MariaDB database (Scenario 3b)
    - artifact serving is disabled (by using `--no-serve-artifacts` option)

In this article/lab, you can practice the 3b basic scenario explained in the previous issue, but dockerized. To do that, create your own `project/poc` folder, and `cd` into it. I recommend that you make a copy of the [3_MLflow_Tracking_Server_in_Docker repository folder](https://github.com/ghernantes/Training.MLOps.MLFlow/tree/main/3_MLflow_Tracking_Server_in_Docker) and follow along with the article's hands-on exercises. For brevity, I will refer to the copied folder as **`lab3`**.

Open three different terminals under `lab3`:

- Terminal 1: to inspect folder contents
- Terminal 2: to run the mlflow server docker stack
- Terminal 3: to run experiments

Let's inspect `lab3` folder. On **terminal 1** under `lab3`, run `tree .`:

```bash
$ tree .
.
├── .secrets
│   ├── env-secrets
│   ├── mysql-mlflowuser-password.txt
│   └── mysql-root-password.txt
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
│   ├── .dockerignore
│   ├── conda.yml
│   ├── Dockerfile
│   ├── Dockerfile-conda
│   ├── entrypoint-conda-dev.sh
│   ├── entrypoint-pip-dev.sh
│   ├── entrypoint.sh
│   └── requirements.txt
├── .env
├── .gitignore
├── docker-compose.yml
├── README.md
├── show_all.sh
├── stack_deploy.sh
└── stack_remove.sh
```

We have the same two examples as before:

- **Quickstart**: a very simple ML modular example.
- **Palmer Pinguins**: an ML notebook example.


### **5.1 Set HTTP Tracking server's 'Backend store' and the MLflow Client's 'Artifacts store'**
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

To set your backend and artifacts stores:

- First, tell the **MLflow client** that will work together with an **MLflow HTTP tracking server**:
  - Instrumenting the training code with: `mlflow.set_tracking_uri("http://my-tracking-server:5005")`
    ```python
    import os
    from random import random, randint
    from mlflow import set_tracking_uri, get_tracking_uri, log_metric, log_param, log_artifacts

    if __name__ == "__main__":
      set_tracking_uri("http://localhost:5005")            # Scenario 3
    ...
    ```
  - Or setting and exporting the environment variable: `MLFLOW_TRACKING_URI="http://localhost:5005"` where the training code is executed.

- Then, launch the **MLflow HTTP tracking server** with:

  ```bash
  $ source ./stack_deploy
  ```

### **5.2 Launch a new Dockerized MLflow Tracking server (Scenario 3b)**
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

Open **terminal 2** and run:

```bash
$ source ./stack_deploy

[+] Running 5/5
 ⠿ Network 3_mlflow_tracking_server_in_docker_default           Created   0.1s
 ⠿ Volume "3_mlflow_tracking_server_in_docker_database_volume"  Created   0.0s
 ⠿ Container mlflow_mysql_3305                                  Started   1.2s
 ⠿ Container mlflow_tracker_5005                                Started   1.8s
 ⠿ Container mlflow_phpmyadmin_8085                             Started   1.9s
```

NOTE: If the volume `3_mlflow_tracking_server_in_docker_database_volume` is still there, it will be reused. If not, a new volume is created and the process db file creation and db contents migration is executed again.

### **5.3 The 'quickstart' example under Scenario 3b**
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

Move to **terminal 3**. The mlflow conda env should be still activated, and the working directory should be `lab3/mlflow`.

Under this folder run `mlflow_tracking.py` again, but this time change the `MLFLOW_TRACKING_URI` as in the following code:

```bash
$ conda activate mlflow
(mlflow)$
(mlflow)$ export MLFLOW_TRACKING_URI="http://localhost:5005"
(mlflow)$ export
(mlflow)$
(mlflow)$ python ../examples/quickstart/mlflow_tracking.py
#  python my_mlflow_client.py --default-artifact-root /client/path/to/artifact/store
(mlflow)$ python examples/quickstart/mlflow_tracking.py --default-artifact-root /home/gustavo/training/GitHub/Training.MLOps.MLFlow/3_MLflow_Tracking_Server_in_Docker/mlflow/mlruns
Current tracking uri: http://localhost:5005
Current working directory: /home/gustavo/training/GitHub/Training.MLOps.MLFlow/lab3/mlflow
Temporal directory 'examples/quickstart/outputs' created
Artifacts in 'examples/quickstart/outputs' tracked!
Temporal directory 'examples/quickstart/outputs' has been removed successfully
```

Have a look at the **'MLflow UI server'** to see how it played out!

<img src='./examples/quickstart/img/mlflow_ui_quickstart_scenario3_runs_list.png' alt='' width='1000'>

<img src='./examples/quickstart/img/mlflow_ui_quickstart_scenario3_first_run_details.png' alt='' width='1000'>

Once again, we have managed to track parameters, metrics and a dummy artifact 'test.txt'.


## 6. Building a non-root Docker image for MLflow and installing depencies with conda
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)



## 7. Summary
[Go to Index](#3-move-your-mlflow-tracking-server-to-docker)

