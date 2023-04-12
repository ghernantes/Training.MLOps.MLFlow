# 3. Move your MLflow Tracking server to Docker
[Go to Root Index](../README.md)

- [1. Introduction](./README.md#1-introduction)
    - [1.1 What is Scenario 3b](./README.md#11-what-is-scenario-3b)
    - [1.2 What are the Benefits of Dockerizing an MLflow Tracking Server?](./README.md#12-what-are-the-benefits-of-dockerizing-an-mlflow-tracking-server)
- [2. Building a basic Docker image for MLflow](./README.md#2-building-a-docker-image-for-mlflow)
    - [2.1 A basic Docker image: `Dockerfile-as-root`](./README.md#21-a-basic-docker-image-dockerfile-as-root)
    - [2.2 A better Docker image: `Dockerfile-as-user`](./README.md#22-a-better-docker-image-dockerfile-as-user)
    - [2.3 An alternative Docker image: `Dockerfile-conda`](./README.md#23-an-alternative-docker-image-dockerfile-conda)
- [3. Using MariaDB as Tracking Backend Storage](./README.md#3-using-mariadb-as-tracking-backend-storage)
- [4. A Docker stack for MLflow](./README.md#4-a-docker-stack-for-mlflow)
- [5. Dockerized Scenario 3b: MLflow Client + Dockerized HTTP Tracking server ('MLFLOW_TRACKING_URI="http://localhost:5005"'](./README.md#5-dockerized-scenario-3b-mlflow-client--dockerized-http-tracking-server-mlflow_tracking_urihttplocalhost5005)
    - [5.1 Set HTTP Tracking server's 'Backend store' and the MLflow Client's 'Artifacts store'](./README.md#51-set-http-tracking-servers-backend-store-and-the-mlflow-clients-artifacts-store)
    - [5.2 Launch a new Dockerized MLflow Tracking server (Scenario 3b)](./README.md#52-launch-a-new-dockerized-mlflow-tracking-server-scenario-3b)
    - [5.3 The 'quickstart' example under Scenario 3b](./README.md#53-the-quickstart-example-under-scenario-3b)
- [6. How MLflow records the path to the artifact store for each experiment](./README.md#6-how-mlflow-records-the-path-to-the-artifact-store-for-each-experiment)
- [7. Summary](./README.md#7-summary)

You can access the article code on the following GitHub repository:

[https://github.com/ghernantes/Training.MLOps.MLFlow/blob/main/3_MLflow_Tracking_Server_in_Docker](https://github.com/ghernantes/Training.MLOps.MLFlow/blob/main/2_MLFlow_Backend_and_Artifact_Storage_Scenarios_1_2_and_3)

<img src='./examples/quickstart/img/Minibot_loading_a_new_model.png' alt='' width='800'>
<p> Minibot loading a new model. Another Stable Diffusion digital art.</p>

## 1. Introduction.

### **1.1 What is Scenario 3b**
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

In this article, I will show how to easily **dockerize the tracking server and database for MLflow**:

<img src='./examples/quickstart/img/scenario_3b.png' alt='' width='600'>

It's worth noting that this **is not an MLflow official scenario**. I refer to it as "Scenario 3b," and while it's not part of the official documentation, **I find it useful and often use it in my local training sessions**. It is an intermediate step towards an "Scenario 4" implementation where all artifacts are stored in an Azure Blob Storage, which I will cover in the next article.

In this scenario, as I will explain later, it's important to use the same path for **Artifact Storage** in both the container and locally, and to [Bind mount](https://docs.docker.com/storage/bind-mounts/) them so that the server can find the stored artifacts in the same path as the client.

If you prefer not to or cannot use any remote storage for your artifacts, but still want to take advantage of a dockerized tracking server, then this could be the perfect solution for you.

### **1.2 What are the Benefits of Dockerizing an MLflow Tracking Server?**
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

Docker offers a range of benefits that are well-known. Let's take a quick look at the advantages of dockerizing an MLflow tracking server:

- **Portability**: containers can run on different operating systems and environments, making it easy to deploy the MLflow tracking server in any environment that supports Docker.
- **Isolation**: containers provide an isolated environment for the MLflow tracking server, ensuring that it runs in a controlled environment without any conflicts with other applications or services running on the same host.
- **Consistency**: containers provide a consistent environment for running the MLflow tracking server, regardless of the underlying host operating system or environment. This ensures that the MLflow tracking server runs consistently across different environments.
- **Scalability**: containers can be easily scaled up or down based on the workload demands, making it easy to handle increased traffic or workload.
- **Easy updates**: docker containers can be easily updated to the latest version of MLflow or other dependencies without affecting the underlying host system.
- **Reproducibility**: containers allow you to easily reproduce the environment in which the MLflow tracking server was running, making it easy to debug or troubleshoot issues.

Overall, Dockerizing an MLflow tracking server can simplify deployment, improve scalability, and provide a consistent and isolated environment for running the server.


## 2. Building a Docker image for MLflow

### **2.1 A basic Docker image: `Dockerfile-as-root`**
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

This is a `Dockerfile` that can be used as a starting point for building a basic Docker image for MLflow:

```Dockerfile
# Good practice: Use official base images
#
FROM python:3.10-slim

# Good practice: upgrade distro packages (with last security patches).
#
RUN apt-get update && apt-get -y upgrade \
    && pip install --upgrade pip \
    && pip --version

RUN apt-get update && apt-get install -y procps \
    && rm -rf /var/lib/apt/lists/*

# Install mlflow dependencies:
#
WORKDIR /mlflow/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && rm requirements.txt

# Expose mlflow ports
#
EXPOSE 5000

# Launch the mlflow server
#
CMD mlflow server --backend-store-uri ${BACKEND_STORE_URI} \
                  --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} \
                  --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} \
                  --no-serve-artifacts \
                  --host 0.0.0.0 --port 5000
```

Some good practices implemented in this `Dockerfile` are the following. Use official base images whenever possible, as they are well-maintained and typically have smaller image sizes. The Dockerfile begins by using a slim version of Python 3.10 as the base image. Slim versions are stripped-down versions that contain only the essential components needed to run Python 3.10. This results in image sizes that are even smaller, which in turn consume fewer resources (CPU, memory, and disk space). Additionally, slim versions have a reduced attack surface, making them less vulnerable to security threats. All of these benefits lead to faster image build times, quicker deployments, and improved portability across different environments due to fewer dependencies and compatibility issues.

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
$ docker build -f Dockerfile-as-root -t mlflow_tracker_slim_as_root .

[+] Building 1.2s (11/11) FINISHED
 => [internal] load build definition from Dockerfile-as-root                                                                0.0s
 => => transferring dockerfile: 27.11kB                                                                                     0.0s
 => [internal] load .dockerignore                                                                                           0.1s
 => => transferring context: 35B                                                                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.10-slim                                                         1.0s
 => [1/6] FROM docker.io/library/python:3.10-slim@sha256:7b0a5cefbcdd085faa21533c21549e55a7e66f5aed40f8d1f4de13a017e352cd   0.0s
 => [internal] load build context                                                                                           0.0s
 => => transferring context: 37B                                                                                            0.0s
 => CACHED [2/6] RUN apt-get update && apt-get -y upgrade     && pip install --upgrade pip     && pip --version             0.0s
 => CACHED [3/6] RUN apt-get update && apt-get install -y procps     && rm -rf /var/lib/apt/lists/*                         0.0s
 => CACHED [4/6] WORKDIR /mlflow/                                                                                           0.0s
 => CACHED [5/6] COPY requirements.txt .                                                                                    0.0s
 => CACHED [6/6] RUN pip install --no-cache-dir -r requirements.txt     && rm requirements.txt                              0.0s
 => exporting to image                                                                                                      0.0s
 => => exporting layers                                                                                                     0.0s
 => => writing image sha256:c80c138b84b83b811a413a62aa846bd14e9698346289e486b023227bcb0b94dc                                0.0s
 => => naming to docker.io/library/mlflow_tracker_slim_as_root
```

To obtain more information about the building process and to ensure that cached layers are not used, I typically include the `--progress plain` and `--no-cache options` respectively:

```bash
$ docker build -f Dockerfile-as-root --progress plain --no-cache -t mlflow_tracker_slim_as_root .
```

Find the complete log of this `docker build` at the end of the [`Dockerfile-as-root`](./mlflow/Dockerfile-as-root) file.

### **2.2 A better Docker image: `Dockerfile-as-user`**
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

In this updated version, the MLflow server will not operate under the root user within the container. Instead, it will run as a custom user.

```Dockerfile
# Good practice: Use official base images
#
FROM python:3.10-slim

# Good practice: upgrade distro packages (with last security patches).
#
RUN apt-get update && apt-get -y upgrade \
    && pip install --upgrade pip \
    && pip --version

RUN apt-get update && apt-get install -y procps \
    && rm -rf /var/lib/apt/lists/*

# Good practice: don't run things in containers as root.
#
RUN groupadd mlflow && useradd --create-home -g mlflow gustavo
ENV PATH /home/gustavo/.local/bin:${PATH}

# Good practice: install the app under the appuser home folder:
#
WORKDIR /home/gustavo/mlflow/

# From now on, this process is owned by gustavo:
#
USER gustavo

# Install mlflow dependencies:
#
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Expose mlflow ports
#
EXPOSE 5000

CMD mlflow server --backend-store-uri ${BACKEND_STORE_URI} --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} --no-serve-artifacts --host 0.0.0.0 --port 5000
```

In this second version, **the container will not run the mlflow server as root**. When a process runs as the root user, it has the highest level of access and permissions within the container, which means that it can potentially perform dangerous operations or modify important files and directories. If a container is compromised, an attacker can use the root-level access to execute malicious code or modify the container's filesystem. This can lead to a variety of security vulnerabilities, including data breaches, system compromise, and the unauthorized access of resources.

To mitigate these risks, it's recommended to run processes within Docker containers as non-root users with limited permissions. This way, even if an attacker gains access to the container, they will have limited privileges and will not be able to perform critical operations or modify important files.

In addition, running processes as non-root users can also help with container isolation and prevent issues with conflicting file ownership and permissions between the host and container filesystems.

To build the image, you can use:

```bash
$ docker build -f Dockerfile-as-gustavo -t mlflow_tracker_slim_as_gustavo .

[+] Building 1.3s (12/12) FINISHED
 => [internal] load build definition from Dockerfile-as-gustavo                                                                0.0s
 => => transferring dockerfile: 27.82kB                                                                                        0.0s
 => [internal] load .dockerignore                                                                                              0.0s
 => => transferring context: 35B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/python:3.10-slim                                                            1.1s
 => [1/7] FROM docker.io/library/python:3.10-slim@sha256:7b0a5cefbcdd085faa21533c21549e55a7e66f5aed40f8d1f4de13a017e352cd      0.0s
 => [internal] load build context                                                                                              0.0s
 => => transferring context: 37B                                                                                               0.0s
 => CACHED [2/7] RUN apt-get update && apt-get -y upgrade     && pip install --upgrade pip     && pip --version                0.0s
 => CACHED [3/7] RUN apt-get update && apt-get install -y procps     && rm -rf /var/lib/apt/lists/*                            0.0s
 => CACHED [4/7] RUN groupadd mlflow && useradd --create-home -g mlflow gustavo                                                0.0s
 => CACHED [5/7] WORKDIR /home/gustavo/mlflow/                                                                                 0.0s
 => CACHED [6/7] COPY requirements.txt .                                                                                       0.0s
 => CACHED [7/7] RUN pip install --no-cache-dir -r requirements.txt                                                            0.0s
 => exporting to image                                                                                                         0.1s
 => => exporting layers                                                                                                        0.0s
 => => writing image sha256:e161ebd3ee28bee7f46840859960b9b249786bbaaf809fa6614f08d72c173fa2                                   0.0s
 => => naming to docker.io/library/mlflow_tracker_slim_as_gustavo
```

I typically include the `--progress plain` and `--no-cache options`:

```bash
$ docker build -f Dockerfile-as-gustavo --progress plain --no-cache -t mlflow_tracker_slim_as_gustavo .
```

Find the complete log of this `docker build` at the end of the [`Dockerfile-as-gustavo`](./mlflow/Dockerfile-as-gustavo) file.

As you can see, **we've opted for a specific username in the container instead of a generic `mlflowuser`**. It's important to note that **this new user must have the same name as the user on your Linux host who will be responsible for storing the artifacts**. This way, we'll be able to replicate the folder structure within the container that you (as the Linux user) typically use to store artifacts on your account locally. We'll delve into the reasons for this decision at a later point.

### **2.3 An alternative Docker image: `Dockerfile-conda`**
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

Using `conda` can be a great option for managing and deploying machine learning workflows. But be aware that the use of conda to package Python apps in Docker is a matter of debate and depends on the specific requirements of the application and its deployment environment.

On one hand, conda can be a useful tool for managing Python dependencies and creating self-contained environments that can be easily packaged and deployed. When building a Docker image, using conda to create a virtual environment with the necessary dependencies can simplify the process of setting up the application and reduce the risk of dependency conflicts.

One specific advantage of using Docker for MLflow is that it provides a level of abstraction between the application and the underlying system, which **can help with portability and reproducibility**. By packaging the MLflow server and its dependencies within a Docker container, you can ensure that the same software is running regardless of the host operating system or deployment environment.

However, there are also some drawbacks to using conda within Docker containers. The biggest issue is that **conda packages can be quite large and can increase the size of the Docker image**, which can **slow down the deployment process**, **consume more disk space**, and **increase the surface attack**.

Our `mlflow_tracker_conda` docker image weighs `2.47GB`:

```bash
$ docker images
REPOSITORY                        TAG      IMAGE ID        CREATED              SIZE
mlflow_tracker_conda              latest   c97543ad42fb    10 minutes ago       2.47GB
mlflow_tracker_slim_as_gustavo    latest   44bdb3cf61f6    About an hour ago    870MB
mlflow_tracker_slim_as_root       latest   c80c138b84b8    2 hours ago          872MB
```

Overall, **deploying MLflow servers in Docker using conda can be a powerful and flexible option for managing machine learning workflows**. However, it's important to carefully consider the specific needs of the application and the deployment environment, and to ensure that the Docker container is properly configured and secured to avoid any potential security issues or performance bottlenecks. To reduce the surface attack, consider alternative approaches such as using pip to manage dependencies or using a lightweight base image to reduce the size of the Docker image, as proposed before. The specific needs of the application and its deployment environment should be taken into account when making this decision.

```bash
# Good practice: Use official base images
#
FROM continuumio/miniconda3:latest

# Good practice: upgrade distro packages (with last security patches).
#
RUN apt-get update && apt-get -y upgrade \
    && conda update -n base -c defaults conda \
    && conda --version \
    && conda info

# Good practice: don't run things in containers as root.
#
RUN groupadd mlflow && useradd --create-home -g mlflow gustavo
ENV PATH /home/gustavo/.local/bin:${PATH}

# Good practice: install the app under the appuser home folder:
#
WORKDIR /home/gustavo

# Copy the code to run when container is started
#
COPY ./entrypoint.sh .
RUN chown gustavo ./entrypoint.sh \
    && chmod u+x ./entrypoint.sh

# From now on, this process is owned by gustavo:
#
USER gustavo

# Create the environment:
#
COPY ./conda.yml .
RUN conda env create -f conda.yml

# We need to 'conda run' activating the env 'mlflow_env' before calling '/bin/bash ./entrypoint.sh':
#
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "mlflow_env", "/bin/bash", "./entrypoint-conda-dev.sh"]

```

And this is the used [`conda.yml`](./mlflow/conda.yml) file:

```yaml
name: mlflow_env
channels:
  - conda-forge
dependencies:
  - python=3.10.9
  - pip<=22.3.1
  - pip:
    - mlflow<3,>=2.1
    - pymysql
```

To build the image, you can use:

```bash
$ docker build -f Dockerfile-conda -t mlflow_tracker_conda .

[+] Building 154.7s (13/13) FINISHED
 => [internal] load build definition from Dockerfile-conda                                                                                             0.0s
 => => transferring dockerfile: 32.50kB                                                                                                                0.0s
 => [internal] load .dockerignore                                                                                                                      0.1s
 => => transferring context: 35B                                                                                                                       0.0s
 => [internal] load metadata for docker.io/continuumio/miniconda3:latest                                                                               1.3s
 => [internal] load build context                                                                                                                      0.0s
 => => transferring context: 999B                                                                                                                      0.0s
 => [1/8] FROM docker.io/continuumio/miniconda3:latest@sha256:10b38c9a8a51692838ce4517e8c74515499b68d58c8a2000d8a9df7f0f08fc5e                         0.0s
 => CACHED [2/8] RUN apt-get update && apt-get -y upgrade     && conda update -n base -c defaults conda     && conda --version     && conda info       0.0s
 => [3/8] RUN groupadd mlflow && useradd --create-home -g mlflow gustavo                                                                               0.7s
 => [4/8] WORKDIR /home/gustavo                                                                                                                        0.1s
 => [5/8] COPY ./entrypoint.sh .                                                                                                                       0.1s
 => [6/8] RUN chown gustavo ./entrypoint.sh     && chmod u+x ./entrypoint.sh                                                                           0.5s
 => [7/8] COPY ./conda.yml .                                                                                                                           0.1s
 => [8/8] RUN conda env create -f conda.yml                                                                                                          141.1s
 => exporting to image                                                                                                                                10.5s
 => => exporting layers                                                                                                                               10.4s
 => => writing image sha256:89ede2af3927b29636fcf15c0482f1e75298e13ed31c47ea4ed95caec4a3381f                                                           0.0s
 => => naming to docker.io/library/mlflow_tracker_conda                                                                                                0.0s
```

To obtain more information about the building process and to ensure that cached layers are not used, I typically include the `--progress plain` and `--no-cache options` respectively:

```bash
$ docker build -f Dockerfile-conda --progress plain --no-cache -t mlflow_tracker_conda .
```

Find the complete log of this `docker build` at the end of the [`Dockerfile-conda`](./mlflow/Dockerfile-conda) file.

## 3. Using MariaDB as Tracking Backend Storage
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

In MLflow, `SQLAlchemyStore` is a class that provides an implementation of `AbstractStore`, an abstract base class for storing and managing artifacts and metadata produced during the machine learning lifecycle. The `SQLAlchemyStore` class is used to store tracking metadata in a SQL database using the **SQLAlchemy library**, which allows it to work with a variety of relational databases, including **`SQLite`** and **`MariaDB`/`MySQL`**.

When using `SQLAlchemyStore`, MLflow automatically creates and manages the necessary database schema to store metadata and artifacts, making it easy to use with minimal configuration. It also supports transactional guarantees and concurrent access to metadata, ensuring consistency and reliability of data stored in the database.

In previous issues, we have used `SQLite` to implement **Scnearios 2 and 3**. However, **`SQLite` may not be a viable option**. It's easy to be tempted to use the tools that are used in the examples of the documentation of many products, MLflow in our case. Typically, these tools are showcased to promote simplicity and clarity in demonstrating how to integrate them with the main product. However, it's important to note that these tools **may not always be the most optimal choice in real-world development environments and especially not in production settings**.

If you're new to the world of databases, here's a quick comparison between SQLite and MariaDB for you. However, **if you're already familiar with these databases, feel free to skip this section**.

SQLite is a lightweight, file-based database management system, whereas MariaDB is a robust, scalable, and open-source relational database management system.

Here is a comparison table between SQLite and MariaDB as tracking backend storage in MLflow:

| Feature     | SQLite	                                                              | MariaDB/MySQL              |
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

## 4. A Docker stack for MLflow
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

The following Docker Compose file defines the setup for a stack consisting of three services: `mysql`, `phpmyadmin`, and `mlflow`.

- The **`mysql`** service: uses the MariaDB 10.3 image and defines a container name and hostname using environment variables. It also specifies a password file for the root user and mlflow user, both of which are stored as secrets. The service is exposed through two ports, one for MySQL and one for the MySQL admin interface. The database data is stored in a volume mapped to `/var/lib/mysql`.
- The **`phpmyadmin`** service: uses the latest version of the phpMyAdmin image and depends on the `mysql` service. It also defines a container name and hostname using an environment variable, and exposes a port for the phpMyAdmin web interface. The service sets the `PMA_HOST` environment variable to the name of the `mysql` service and specifies the password file for the root user.
- The **`mlflow`** service: builds a custom image from a Dockerfile located in the `./mlflow` directory. It also specifies a container name and hostname using an environment variable, and depends on the `mysql` service. The service is exposed through a port, and the `/home/gustavo/mlflow` directory is mounted as a [bind mount](https://docs.docker.com/storage/bind-mounts/) to get access to all locally stored MLflow artifacts. The service also specifies a custom command to be executed on container startup using the `entrypoint-pip-dev.sh` script.

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
          #dockerfile: Dockerfile-as-root        # to build a root image with a system pip install of mlflow.
          dockerfile: Dockerfile-as-gustavo      # to build a non-root image with a system pip install of mlflow
          #dockerfile: Dockerfile-conda          # to build a non-root image with a tailored conda env for mlflow
        #image: mlflow_tracker_slim_as_root      # This image does NOT provide Artifact management.
        image: mlflow_tracker_slim_as_gustavo
        #image: mlflow_tracker_conda             # This image may be unnecessarily large.
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
            - /home/gustavo/mlflow:/home/gustavo/mlflow                                                  # --> Replicate folder structure in the host and in the container
                                                                                                         #     and map those two folders to have a working Artifact Storage.
            # - /home/gustavo/training/GitHub/Training.MLOps.MLFlow/lab/mlflow:/home/mlflowuser/mlflow/    --> This will NOT work
        #command: ./entrypoint.sh                # replaces the CMD line in Dockerfile
        command: ./entrypoint-pip-dev.sh         # only for the image built with Dockerfile-as-root or Dockerfile-as-gustavo
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
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

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

In this article/lab, you can practice the dockerized 3b basic scenario explained in this issue. To do that, create your own `project/poc` folder, and `cd` into it. I recommend that you make a copy of the [3_MLflow_Tracking_Server_in_Docker repository folder](https://github.com/ghernantes/Training.MLOps.MLFlow/tree/main/3_MLflow_Tracking_Server_in_Docker) and follow along with the article's hands-on exercises. For brevity, I will refer to the copied folder as **`lab3`**.

Open three different terminals under `lab3`:

- Terminal 1: to inspect folder contents
- Terminal 2: to run the mlflow server docker stack
- Terminal 3: to run experiments

Let's inspect `lab3` folder. On **terminal 1** under `lab3`, run `tree .`:

```bash
$ tree -a .
.
├── .env
├── .gitignore
├── .secrets
│   ├── env-secrets
│   ├── mysql-mlflowuser-password.txt
│   └── mysql-root-password.txt
├── README.md
├── docker-compose.yml
├── examples
│   ├── palmer_pinguins
│   │   ├── .gitignore
│   │   ├── data
│   │   │   └── penguins_classification.csv
│   │   ├── img
│   │   │   ├── ...
│   │   └── notebooks
│   │       └── 1_Run_and_track_experiments.ipynb
│   └── quickstart
│       ├── img
│       │   ├── ...
│       ├── mlflow_tracking.py
│       └── utils
│           ├── __init__.py
│           ├── __pycache__
│           │   ├── __init__.cpython-310.pyc
│           │   └── process_info.cpython-310.pyc
│           └── process_info.py
├── mlflow
│   ├── .dockerignore
│   ├── Dockerfile-as-gustavo
│   ├── Dockerfile-as-root
│   ├── Dockerfile-conda
│   ├── conda.yml
│   ├── entrypoint-conda-dev.sh
│   ├── entrypoint-pip-dev.sh
│   ├── entrypoint.sh
│   └── requirements.txt
├── show_all.sh
├── stack_deploy.sh
└── stack_remove.sh

11 directories, 60 files
```

We have the same two examples as before:

- **Quickstart**: a very simple ML modular example.
- **Palmer Pinguins**: an ML notebook example.


### **5.1 Set HTTP Tracking server's 'Backend store' and the MLflow Client's 'Artifacts store'**
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

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
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

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
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

Move to **terminal 3**. The `mlflow` conda env should be activated, and the working directory should be `lab3`.

Under this folder run `mlflow_tracking.py` again, but this time change the `MLFLOW_TRACKING_URI` as in the following code:

```bash
$ conda activate mlflow
(mlflow)$
(mlflow)$ export MLFLOW_TRACKING_URI="http://localhost:5005"
(mlflow)$
(mlflow)$ python ./examples/quickstart/mlflow_tracking.py
Process ID: 8118
Process Name: python
Process Status: R (running)
Process UID: 1000
Process Owner: gustavo
Current tracking uri: http://localhost:5005
INFO mlflow.tracking.fluent: Experiment with name 'quickstart' does not exist. Creating a new experiment.
Current artifact store uri: file:///home/gustavo/mlflow/mlruns/1
Current working directory: /home/gustavo/training/GitHub/Training.MLOps.MLFlow/lab3
Temporal directory '/home/gustavo/training/GitHub/Training.MLOps.MLFlow/lab3/examples/quickstart/outputs' created
Tracked artifacts in temp 'examples/quickstart/outputs' folder!
Artifacts full path: file:///home/gustavo/mlflow/mlruns/1/69ca60ea050d4f3481eac66e4a48fbf2/artifacts
Temporal directory '/home/gustavo/training/GitHub/Training.MLOps.MLFlow/lab3/examples/quickstart/outputs' has been removed successfully
```

Have a look at the **'MLflow UI server'** to see how it played out!

<img src='./examples/quickstart/img/mlflow_ui_quickstart_scenario3b_runs_list.png' alt='' width='1000'>

Once again, we have managed to track parameters, metrics and a dummy artifact 'test.txt':

<img src='./examples/quickstart/img/mlflow_ui_quickstart_scenario3b_first_run_details.png' alt='' width='1000'>

## 6. How MLflow records the path to the artifact store for each experiment
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

MLflow records an URI to the artifact store for each experiment by creating an artifact repository for each run, and storing the URI to the repository in the MLflow server. 

See the column `artifact_location` in the `experiments` table in the MLflow server database:

<img src='./examples/quickstart/img/quickstart_experiment_artifacts_location.png' alt='' width='1000'>

When an artifact is logged using MLflow, it is saved by the client in the artifact repository associated with the current run. The URI to the artifact store is specified by setting the `DEFAULT_ARTIFACT_ROOT` server environment variable, or by passing the `--default-artifact-root` flag to the mlflow server command, and the client gets that URI by asking the server. The client knows what tracking server to ask thanks to the `MLFLOW_TRACKING_URI` client's environment variable.

In our Scenario 3b, once the client has been instructed to use the MLflow HTTP tracking server, it will ask the server for the URI to the artifact store. The server will respond with the URI to the artifact store that was recorded in the experiment properties in the server database. This URI is the one that was set by the `--default-artifact-root` flag when the server was launched.

Then, the client tracks the artifacts for the current run locally in the `mlruns` folder:

```bash
$ tree /home/gustavo/mlflow/mlruns

/home/gustavo/mlflow/mlruns
└── 1
    └── 69ca60ea050d4f3481eac66e4a48fbf2
        └── artifacts
            └── test.txt
```

and the server will record the URI to the artifact store for this particular run in the database:

<img src='./examples/quickstart/img/quickstart_first_run_artifacts_location.png' alt='' width='1000'>

The ability to record the URI to the artifact store for each experiment is important in scenarios where the tracking server and client are running on different machines, as it allows both, the client and the server, to locate and retrieve artifacts associated with a particular experiment.

If the kind of URI to the artifact store **is a folder path**, and client and server are in two different machines, **then we are dealing with paths in two different file systems**. When the server reports to the client its path to the artifact store (as it was recorded in the experiment properties in the server database), it can potentially report an invalid path for the client and it can cause issues with accessing the artifacts. This is the case for our client and server in Scenario 3b, and possibly the reason why this is not an official scenario.

**The good news is that you can easily overcome these potential issues**. You just need to ensure that the client and server are both directed to the same artifacts folder by forcing them to use the **exact same artifacts folder path route** and - thanks to Docker - by **bind mounting this two folders**. Note that you will only need set the environment variable for the artifact store path on the server. The only way the client will correctly get that folder path by asking the server.  

In our example we have used a single route `/home/gustavo/mlflow` in both, the client and the dockerized server, and then bind mounted this two folders in the `docker-compose.yml` file:

```yaml
version: '3.9'
services:
    mysql:
        ...
    phpmyadmin:
        ...
    mlflow:
        ...
        volumes:
            - /home/gustavo/mlflow:/home/gustavo/mlflow
```

A more general solution to address this scenario is **to use a shared network file system**, such as NFS, or a distributed file system like Hadoop Distributed File System (HDFS) or GlusterFS. By doing so, you eliminate the need for paths on different file systems, as now both the client and server would be using the same shared file system. This ensures that the artifact store is easily accessible by both the client and server, without any issues related to different file systems.

Additionally, **you can also configure MLflow to use a cloud-based storage solution like Azure Blob Storage or Amazon S3**, which would eliminate the need for coordinating file systems as we have shown here.

## 7. Summary
[Go to Index](./README.md#3-move-your-mlflow-tracking-server-to-docker)

In this article, we've explored the Scenario 3b, a use case for MLflow in which the tracking server and client are potentially running on different machines, with the server in a docker host. We've shown how to build a basic Docker image for MLflow, as well as a better Docker image that runs as a non-root user and an alternative Docker image that uses Conda. We've also demonstrated how to use MariaDB/MySQL as a tracking backend storage and how to create a Docker stack for MLflow. We've covered how to run Scenario 3b by setting the HTTP tracking server's backend store and the MLflow client's artifacts store, launched a new Dockerized MLflow tracking server, and used the 'quickstart' example. Finally, we've discussed how MLflow records the path to the artifact store for each experiment and why that's important in Scenario 3b.

Stay tuned for the next issue where we will discuss how to migrate your Artifact Store to an emulated Azure Blob Storage running locally and to a real one in the cloud.