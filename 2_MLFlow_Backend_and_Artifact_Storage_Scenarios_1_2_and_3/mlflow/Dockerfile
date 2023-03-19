FROM python:3.10-slim

RUN apt-get update && apt-get -y upgrade \
    && pip install --upgrade pip \
    && pip --version

WORKDIR /mlflow/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && rm requirements.txt

EXPOSE 5000

CMD mlflow server --backend-store-uri ${BACKEND_STORE_URI} --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} --host 0.0.0.0 --port 5000

# CMD mlflow server --backend-store-uri ${BACKEND_STORE_URI} --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} --host 0.0.0.0 --port 5000


# ======================================================================================================================================
# VERBOSE Image build:
# ======================================================================================================================================

# Build the image with:

# $ docker build --progress plain --no-cache -t mlflow_tracker_slim .

# Logged info:

# #1 [internal] load build definition from Dockerfile
# #1 sha256:8f098877449ec2c4295f6bd228976778c48e29ed4c5ada94c674ebc3ecfeb607
# #1 transferring dockerfile: 15.84kB done
# #1 DONE 0.0s

# #2 [internal] load .dockerignore
# #2 sha256:37ac75188823e855fd5d1ca191d1ee172e66c5fdca17c2c68a7a40753e4b7282
# #2 transferring context: 35B done
# #2 DONE 0.0s

# #3 [internal] load metadata for docker.io/library/python:3-slim
# #3 sha256:1d53a8326d1210addccb4bc5ed043a5dc9dc3d4d221b85e1b898fd379832ee7b
# #3 DONE 0.9s

# #4 [1/4] FROM docker.io/library/python:3-slim@sha256:d0e839882b87135b355361efeb9e9030c9d2a808da06434f4c99eb4009c15e64
# #4 sha256:e1e3bac94aebe564bdaa8885ee0fa29cdeb36115e2ef8dfd6805d7489bd1b99d
# #4 DONE 0.0s

# #5 [2/4] WORKDIR /mlflow/
# #5 sha256:9ac2ac10c2126bbcc1d104277d601f2454dc03267736e0b1904432c56abf63a0
# #5 CACHED

# #6 [internal] load build context
# #6 sha256:0e55a650f68d1cbe55df2aa52708791482413912bb539cfb4c65bc55c690cc23
# #6 transferring context: 37B done
# #6 DONE 0.0s

# #7 [3/4] COPY requirements.txt .
# #7 sha256:a4353387a5060ef846a7dcb4f9638a24ad566b44feb66f7029cae892e3e6ab0d
# #7 DONE 0.1s

# #8 [4/4] RUN pip install --no-cache-dir -r requirements.txt     && rm requirements.txt
# #8 sha256:8c28f61d19ebbab736a6be4784e6a03a58f8cf1ecd6b1613e7792a9848ffee35
# #8 1.960 Collecting mlflow==1.20.0
# #8 2.018   Downloading mlflow-1.20.0-py3-none-any.whl (14.6 MB)
# #8 3.674      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 14.6/14.6 MB 10.8 MB/s eta 0:00:00
# #8 3.737 Collecting click>=7.0
# #8 3.745   Downloading click-8.1.3-py3-none-any.whl (96 kB)
# #8 3.753      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 96.6/96.6 kB 14.1 MB/s eta 0:00:00
# #8 3.781 Collecting cloudpickle
# #8 3.808   Downloading cloudpickle-2.2.1-py3-none-any.whl (25 kB)
# #8 3.837 Collecting databricks-cli>=0.8.7
# #8 3.847   Downloading databricks-cli-0.17.4.tar.gz (82 kB)
# #8 3.858      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 82.3/82.3 kB 8.8 MB/s eta 0:00:00
# #8 3.904   Preparing metadata (setup.py): started
# #8 4.508   Preparing metadata (setup.py): finished with status 'done'
# #8 4.526 Collecting entrypoints
# #8 4.537   Downloading entrypoints-0.4-py3-none-any.whl (5.3 kB)
# #8 4.579 Collecting gitpython>=2.1.0
# #8 4.588   Downloading GitPython-3.1.31-py3-none-any.whl (184 kB)
# #8 4.613      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 184.3/184.3 kB 7.9 MB/s eta 0:00:00
# #8 4.665 Collecting pyyaml>=5.1
# #8 4.686   Downloading PyYAML-6.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (757 kB)
# #8 4.760      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 757.9/757.9 kB 10.4 MB/s eta 0:00:00
# #8 4.991 Collecting protobuf>=3.7.0
# #8 5.008   Downloading protobuf-4.22.0-cp37-abi3-manylinux2014_x86_64.whl (302 kB)
# #8 5.039      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 302.4/302.4 kB 10.2 MB/s eta 0:00:00
# #8 5.096 Collecting pytz
# #8 5.110   Downloading pytz-2022.7.1-py2.py3-none-any.whl (499 kB)
# #8 5.147      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 499.4/499.4 kB 14.5 MB/s eta 0:00:00
# #8 5.197 Collecting requests>=2.17.3
# #8 5.207   Downloading requests-2.28.2-py3-none-any.whl (62 kB)
# #8 5.211      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.8/62.8 kB 263.1 MB/s eta 0:00:00
# #8 5.236 Collecting packaging
# #8 5.246   Downloading packaging-23.0-py3-none-any.whl (42 kB)
# #8 5.251      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 42.7/42.7 kB 14.4 MB/s eta 0:00:00
# #8 5.295 Collecting importlib-metadata>=3.7.0
# #8 5.304   Downloading importlib_metadata-6.0.0-py3-none-any.whl (21 kB)
# #8 5.338 Collecting alembic<=1.4.1
# #8 5.350   Downloading alembic-1.4.1.tar.gz (1.1 MB)
# #8 5.444      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.1/1.1 MB 11.7 MB/s eta 0:00:00
# #8 5.507   Preparing metadata (setup.py): started
# #8 5.733   Preparing metadata (setup.py): finished with status 'done'
# #8 5.762 Collecting docker>=4.0.0
# #8 5.775   Downloading docker-6.0.1-py3-none-any.whl (147 kB)
# #8 5.790      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 147.5/147.5 kB 10.7 MB/s eta 0:00:00
# #8 5.812 Collecting Flask
# #8 5.832   Downloading Flask-2.2.3-py3-none-any.whl (101 kB)
# #8 5.842      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.8/101.8 kB 14.0 MB/s eta 0:00:00
# #8 6.072 Collecting numpy
# #8 6.091   Downloading numpy-1.24.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (17.3 MB)
# #8 7.664      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 17.3/17.3 MB 10.7 MB/s eta 0:00:00
# #8 7.845 Collecting pandas
# #8 7.855   Downloading pandas-1.5.3-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (12.0 MB)
# #8 8.945      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 12.0/12.0 MB 11.0 MB/s eta 0:00:00
# #8 8.981 Collecting prometheus-flask-exporter
# #8 8.989   Downloading prometheus_flask_exporter-0.22.3-py3-none-any.whl (18 kB)
# #8 9.010 Collecting querystring-parser
# #8 9.025   Downloading querystring_parser-1.2.4-py2.py3-none-any.whl (7.9 kB)
# #8 9.055 Collecting sqlparse>=0.3.1
# #8 9.064   Downloading sqlparse-0.4.3-py3-none-any.whl (42 kB)
# #8 9.069      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 42.8/42.8 kB 8.1 MB/s eta 0:00:00
# #8 9.348 Collecting sqlalchemy
# #8 9.358   Downloading SQLAlchemy-2.0.5.post1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (2.8 MB)
# #8 9.591      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.8/2.8 MB 12.0 MB/s eta 0:00:00
# #8 9.629 Collecting gunicorn
# #8 9.636   Downloading gunicorn-20.1.0-py3-none-any.whl (79 kB)
# #8 9.642      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 79.5/79.5 kB 18.4 MB/s eta 0:00:00
# #8 9.674 Collecting Mako
# #8 9.683   Downloading Mako-1.2.4-py3-none-any.whl (78 kB)
# #8 9.689      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 78.7/78.7 kB 16.8 MB/s eta 0:00:00
# #8 9.703 Collecting python-editor>=0.3
# #8 9.710   Downloading python_editor-1.0.4-py3-none-any.whl (4.9 kB)
# #8 9.729 Collecting python-dateutil
# #8 9.738   Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
# #8 9.769      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 247.7/247.7 kB 8.3 MB/s eta 0:00:00
# #8 9.799 Collecting pyjwt>=1.7.0
# #8 9.807   Downloading PyJWT-2.6.0-py3-none-any.whl (20 kB)
# #8 9.827 Collecting oauthlib>=3.1.0
# #8 9.837   Downloading oauthlib-3.2.2-py3-none-any.whl (151 kB)
# #8 9.850      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 151.7/151.7 kB 12.5 MB/s eta 0:00:00
# #8 9.867 Collecting tabulate>=0.7.7
# #8 9.875   Downloading tabulate-0.9.0-py3-none-any.whl (35 kB)
# #8 9.894 Collecting six>=1.10.0
# #8 9.902   Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
# #8 9.958 Collecting urllib3>=1.26.0
# #8 9.969   Downloading urllib3-1.26.14-py2.py3-none-any.whl (140 kB)
# #8 9.979      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 140.6/140.6 kB 17.3 MB/s eta 0:00:00
# #8 10.01 Collecting websocket-client>=0.32.0
# #8 10.02   Downloading websocket_client-1.5.1-py3-none-any.whl (55 kB)
# #8 10.02      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 55.9/55.9 kB 41.0 MB/s eta 0:00:00
# #8 10.04 Collecting gitdb<5,>=4.0.1
# #8 10.05   Downloading gitdb-4.0.10-py3-none-any.whl (62 kB)
# #8 10.06      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.7/62.7 kB 29.9 MB/s eta 0:00:00
# #8 10.10 Collecting zipp>=0.5
# #8 10.11   Downloading zipp-3.15.0-py3-none-any.whl (6.8 kB)
# #8 10.19 Collecting charset-normalizer<4,>=2
# #8 10.20   Downloading charset_normalizer-3.1.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (197 kB)
# #8 10.23      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 197.3/197.3 kB 8.1 MB/s eta 0:00:00
# #8 10.25 Collecting idna<4,>=2.5
# #8 10.26   Downloading idna-3.4-py3-none-any.whl (61 kB)
# #8 10.27      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.5/61.5 kB 11.8 MB/s eta 0:00:00
# #8 10.30 Collecting certifi>=2017.4.17
# #8 10.31   Downloading certifi-2022.12.7-py3-none-any.whl (155 kB)
# #8 10.32      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 155.3/155.3 kB 11.3 MB/s eta 0:00:00
# #8 10.39 Collecting typing-extensions>=4.2.0
# #8 10.40   Downloading typing_extensions-4.5.0-py3-none-any.whl (27 kB)
# #8 10.55 Collecting greenlet!=0.4.17
# #8 10.56   Downloading greenlet-2.0.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (618 kB)
# #8 10.62      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 618.8/618.8 kB 11.2 MB/s eta 0:00:00
# #8 10.66 Collecting Werkzeug>=2.2.2
# #8 10.68   Downloading Werkzeug-2.2.3-py3-none-any.whl (233 kB)
# #8 10.70      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 233.6/233.6 kB 11.2 MB/s eta 0:00:00
# #8 10.72 Collecting Jinja2>=3.0
# #8 10.73   Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
# #8 10.75      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 10.9 MB/s eta 0:00:00
# #8 10.76 Collecting itsdangerous>=2.0
# #8 10.77   Downloading itsdangerous-2.1.2-py3-none-any.whl (15 kB)
# #8 10.78 Requirement already satisfied: setuptools>=3.0 in /usr/local/lib/python3.11/site-packages (from gunicorn->mlflow==1.20.0->-r requirements.txt (line 1)) (65.5.1)
# #8 10.82 Collecting prometheus-client
# #8 10.83   Downloading prometheus_client-0.16.0-py3-none-any.whl (122 kB)
# #8 10.85      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 122.5/122.5 kB 10.2 MB/s eta 0:00:00
# #8 10.87 Collecting smmap<6,>=3.0.1
# #8 10.88   Downloading smmap-5.0.0-py3-none-any.whl (24 kB)
# #8 10.96 Collecting MarkupSafe>=2.0
# #8 10.96   Downloading MarkupSafe-2.1.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (27 kB)
# #8 11.08 Building wheels for collected packages: alembic, databricks-cli
# #8 11.09   Building wheel for alembic (setup.py): started
# #8 11.55   Building wheel for alembic (setup.py): finished with status 'done'
# #8 11.55   Created wheel for alembic: filename=alembic-1.4.1-py2.py3-none-any.whl size=158152 sha256=2bd7bedac2e329c512785a48089bf25f451b6b455cc5e11c8ece807a66c89968
# #8 11.55   Stored in directory: /tmp/pip-ephem-wheel-cache-gnbmh5hp/wheels/d3/e4/da/1b54a3ec9ea0685701f3ba10fff2913127cab61b414e73e4fb
# #8 11.56   Building wheel for databricks-cli (setup.py): started
# #8 11.83   Building wheel for databricks-cli (setup.py): finished with status 'done'
# #8 11.83   Created wheel for databricks-cli: filename=databricks_cli-0.17.4-py3-none-any.whl size=142875 sha256=d0647f44652cc9161d3231cafa99ba4936a6468590931f695629652a4ff6e593
# #8 11.83   Stored in directory: /tmp/pip-ephem-wheel-cache-gnbmh5hp/wheels/ad/1d/0b/60e79d339878cd7e2a2b2869e412abf7045947bc89b607b576
# #8 11.83 Successfully built alembic databricks-cli
# #8 12.06 Installing collected packages: pytz, python-editor, zipp, websocket-client, urllib3, typing-extensions, tabulate, sqlparse, smmap, six, pyyaml, pyjwt, protobuf, prometheus-client, packaging, oauthlib, numpy, MarkupSafe, itsdangerous, idna, gunicorn, greenlet, entrypoints, cloudpickle, click, charset-normalizer, certifi, Werkzeug, sqlalchemy, requests, querystring-parser, python-dateutil, Mako, Jinja2, importlib-metadata, gitdb, pandas, gitpython, Flask, docker, databricks-cli, alembic, prometheus-flask-exporter, mlflow
# #8 20.98 Successfully installed Flask-2.2.3 Jinja2-3.1.2 Mako-1.2.4 MarkupSafe-2.1.2 Werkzeug-2.2.3 alembic-1.4.1 certifi-2022.12.7 charset-normalizer-3.1.0 click-8.1.3 cloudpickle-2.2.1 databricks-cli-0.17.4 docker-6.0.1 entrypoints-0.4 gitdb-4.0.10 gitpython-3.1.31 greenlet-2.0.2 gunicorn-20.1.0 idna-3.4 importlib-metadata-6.0.0 itsdangerous-2.1.2 mlflow-1.20.0 numpy-1.24.2 oauthlib-3.2.2 packaging-23.0 pandas-1.5.3 prometheus-client-0.16.0 prometheus-flask-exporter-0.22.3 protobuf-4.22.0 pyjwt-2.6.0 python-dateutil-2.8.2 python-editor-1.0.4 pytz-2022.7.1 pyyaml-6.0 querystring-parser-1.2.4 requests-2.28.2 six-1.16.0 smmap-5.0.0 sqlalchemy-2.0.5.post1 sqlparse-0.4.3 tabulate-0.9.0 typing-extensions-4.5.0 urllib3-1.26.14 websocket-client-1.5.1 zipp-3.15.0
# #8 20.98 WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
# #8 21.08
# #8 21.08 [notice] A new release of pip available: 22.3.1 -> 23.0.1
# #8 21.08 [notice] To update, run: pip install --upgrade pip
# #8 DONE 21.7s

# #9 exporting to image
# #9 sha256:e8c613e07b0b7ff33893b694f7759a10d42e180f2b4dc349fb57dc6b71dcab00
# #9 exporting layers
# #9 exporting layers 1.6s done
# #9 writing image sha256:72d2baee9b64e28238b02eb42b1b831563e0acbb039755df2d08292be8457a35 done
# #9 naming to docker.io/library/mlflow_tracker_slim done
# #9 DONE 1.6s

# Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them