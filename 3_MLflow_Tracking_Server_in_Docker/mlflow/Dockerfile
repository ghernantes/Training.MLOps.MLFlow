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

EXPOSE 5000

CMD mlflow server --backend-store-uri ${BACKEND_STORE_URI} --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} --no-serve-artifacts --host 0.0.0.0 --port 5000


# ======================================================================================================================================
# VERBOSE Image build:
# ======================================================================================================================================

# Build the image with:

# $ docker build --progress plain --no-cache -t mlflow_tracker_slim .

# Logged info:
# #1 [internal] load build definition from Dockerfile
# #1 sha256:a613a0417c8e731bd2e740362aa69d5ec69db3fedbf760be91c0794cf6ffa7da
# #1 transferring dockerfile: 27.65kB done
# #1 DONE 0.0s

# #2 [internal] load .dockerignore
# #2 sha256:6d00a060a34722a059fc14fc3034ac026d132687639fa644c83dc1e79e4f937b
# #2 transferring context: 35B done
# #2 DONE 0.0s

# #3 [internal] load metadata for docker.io/library/python:3.10-slim
# #3 sha256:b8cce7183299ea8471dad4044ce489ad9730ef208466a01382bd3a85a0492215
# #3 DONE 0.5s

# #4 [1/7] FROM docker.io/library/python:3.10-slim@sha256:7b0a5cefbcdd085faa21533c21549e55a7e66f5aed40f8d1f4de13a017e352cd
# #4 sha256:3cf59a99c4595deb0a6ac22ffe47f994a753ae4eb206482ee918e1e89f008545
# #4 CACHED

# #9 [internal] load build context
# #9 sha256:1b6498e4a65032137b527eb179e91dc3c0aad65f578e11a4eafbe9fa5d06a5b2
# #9 transferring context: 37B done
# #9 DONE 0.0s

# #5 [2/7] RUN apt-get update && apt-get -y upgrade     && pip install --upgrade pip     && pip --version
# #5 sha256:ee326e143ec81e4f7025634419c33dcc99cdf12628189df109674795020eb0d7
# #5 0.500 Get:1 http://deb.debian.org/debian bullseye InRelease [116 kB]
# #5 0.531 Get:2 http://deb.debian.org/debian-security bullseye-security InRelease [48.4 kB]
# #5 0.548 Get:3 http://deb.debian.org/debian bullseye-updates InRelease [44.1 kB]
# #5 0.596 Get:4 http://deb.debian.org/debian bullseye/main amd64 Packages [8183 kB]
# #5 1.302 Get:5 http://deb.debian.org/debian-security bullseye-security/main amd64 Packages [236 kB]
# #5 1.325 Get:6 http://deb.debian.org/debian bullseye-updates/main amd64 Packages [14.6 kB]
# #5 2.102 Fetched 8642 kB in 2s (5174 kB/s)
# #5 2.102 Reading package lists...
# #5 2.457 Reading package lists...
# #5 2.803 Building dependency tree...
# #5 2.879 Reading state information...
# #5 2.890 Calculating upgrade...
# #5 2.983 The following packages will be upgraded:
# #5 2.983   tzdata
# #5 3.017 1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
# #5 3.017 Need to get 286 kB of archives.
# #5 3.017 After this operation, 20.5 kB of additional disk space will be used.
# #5 3.017 Get:1 http://deb.debian.org/debian bullseye-updates/main amd64 tzdata all 2021a-1+deb11u9 [286 kB]
# #5 3.141 debconf: delaying package configuration, since apt-utils is not installed
# #5 3.167 Fetched 286 kB in 0s (3919 kB/s)
# (Reading database ... 7031 files and directories currently installed.)
# #5 3.226 Preparing to unpack .../tzdata_2021a-1+deb11u9_all.deb ...
# #5 3.256 Unpacking tzdata (2021a-1+deb11u9) over (2021a-1+deb11u8) ...
# #5 9.444 Setting up tzdata (2021a-1+deb11u9) ...
# #5 9.504 debconf: unable to initialize frontend: Dialog
# #5 9.504 debconf: (TERM is not set, so the dialog frontend is not usable.)
# #5 9.504 debconf: falling back to frontend: Readline
# #5 9.504 debconf: unable to initialize frontend: Readline
# #5 9.504 debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.32.1 /usr/local/share/perl/5.32.1 /usr/lib/x86_64-linux-gnu/perl5/5.32 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.32 /usr/share/perl/5.32 /usr/local/lib/site_perl) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
# #5 9.504 debconf: falling back to frontend: Teletype
# #5 9.531
# #5 9.531 Current default time zone: 'Etc/UTC'
# #5 9.532 Local time is now:      Fri Mar 31 19:36:27 UTC 2023.
# #5 9.532 Universal Time is now:  Fri Mar 31 19:36:27 UTC 2023.
# #5 9.532 Run 'dpkg-reconfigure tzdata' if you wish to change it.
# #5 9.532
# #5 10.66 Requirement already satisfied: pip in /usr/local/lib/python3.10/site-packages (22.3.1)
# #5 10.85 Collecting pip
# #5 10.90   Downloading pip-23.0.1-py3-none-any.whl (2.1 MB)
# #5 11.13      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.1/2.1 MB 9.1 MB/s eta 0:00:00
# #5 11.19 Installing collected packages: pip
# #5 11.19   Attempting uninstall: pip
# #5 11.19     Found existing installation: pip 22.3.1
# #5 11.26     Uninstalling pip-22.3.1:
# #5 11.40       Successfully uninstalled pip-22.3.1
# #5 12.24 Successfully installed pip-23.0.1
# #5 12.24 WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
# #5 12.62 pip 23.0.1 from /usr/local/lib/python3.10/site-packages/pip (python 3.10)
# #5 DONE 13.3s

# #6 [3/7] RUN apt-get update && apt-get install -y procps     && rm -rf /var/lib/apt/lists/*
# #6 sha256:f85b9777f5c79b62f73815a47d1ffc804a11dbcae588afc83ba4c32618e71526
# #6 0.637 Hit:1 http://deb.debian.org/debian bullseye InRelease
# #6 0.637 Hit:2 http://deb.debian.org/debian-security bullseye-security InRelease
# #6 0.639 Hit:3 http://deb.debian.org/debian bullseye-updates InRelease
# #6 0.824 Reading package lists...
# #6 1.124 Reading package lists...
# #6 1.423 Building dependency tree...
# #6 1.499 Reading state information...
# #6 1.580 The following additional packages will be installed:
# #6 1.580   libgpm2 libncurses6 libprocps8 psmisc
# #6 1.581 Suggested packages:
# #6 1.581   gpm
# #6 1.609 The following NEW packages will be installed:
# #6 1.610   libgpm2 libncurses6 libprocps8 procps psmisc
# #6 1.644 0 upgraded, 5 newly installed, 0 to remove and 0 not upgraded.
# #6 1.644 Need to get 902 kB of archives.
# #6 1.644 After this operation, 3044 kB of additional disk space will be used.
# #6 1.644 Get:1 http://deb.debian.org/debian bullseye/main amd64 libncurses6 amd64 6.2+20201114-2 [102 kB]
# #6 1.671 Get:2 http://deb.debian.org/debian bullseye/main amd64 libprocps8 amd64 2:3.3.17-5 [63.9 kB]
# #6 1.677 Get:3 http://deb.debian.org/debian bullseye/main amd64 procps amd64 2:3.3.17-5 [502 kB]
# #6 1.720 Get:4 http://deb.debian.org/debian bullseye/main amd64 libgpm2 amd64 1.20.7-8 [35.6 kB]
# #6 1.723 Get:5 http://deb.debian.org/debian bullseye/main amd64 psmisc amd64 23.4-2 [198 kB]
# #6 1.832 debconf: delaying package configuration, since apt-utils is not installed
# #6 1.888 Fetched 902 kB in 0s (7061 kB/s)
# #6 1.958 Selecting previously unselected package libncurses6:amd64.
# (Reading database ... 7034 files and directories currently installed.)
# #6 1.964 Preparing to unpack .../libncurses6_6.2+20201114-2_amd64.deb ...
# #6 1.998 Unpacking libncurses6:amd64 (6.2+20201114-2) ...
# #6 2.122 Selecting previously unselected package libprocps8:amd64.
# #6 2.122 Preparing to unpack .../libprocps8_2%3a3.3.17-5_amd64.deb ...
# #6 2.158 Unpacking libprocps8:amd64 (2:3.3.17-5) ...
# #6 2.329 Selecting previously unselected package procps.
# #6 2.330 Preparing to unpack .../procps_2%3a3.3.17-5_amd64.deb ...
# #6 2.370 Unpacking procps (2:3.3.17-5) ...
# #6 2.549 Selecting previously unselected package libgpm2:amd64.
# #6 2.549 Preparing to unpack .../libgpm2_1.20.7-8_amd64.deb ...
# #6 2.573 Unpacking libgpm2:amd64 (1.20.7-8) ...
# #6 2.724 Selecting previously unselected package psmisc.
# #6 2.725 Preparing to unpack .../psmisc_23.4-2_amd64.deb ...
# #6 2.744 Unpacking psmisc (23.4-2) ...
# #6 2.904 Setting up libgpm2:amd64 (1.20.7-8) ...
# #6 2.966 Setting up psmisc (23.4-2) ...
# #6 3.028 Setting up libncurses6:amd64 (6.2+20201114-2) ...
# #6 3.085 Setting up libprocps8:amd64 (2:3.3.17-5) ...
# #6 3.151 Setting up procps (2:3.3.17-5) ...
# #6 3.269 Processing triggers for libc-bin (2.31-13+deb11u5) ...
# #6 DONE 3.6s

# #7 [4/7] RUN groupadd mlflow && useradd --create-home -g mlflow mlflowuser
# #7 sha256:5931941aa2d6e2d228fba88ca51c8e3c1a70cd5e44639c87597a99dcfbbb3f3d
# #7 DONE 1.3s

# #8 [5/7] WORKDIR /home/mlflowuser/mlflow/
# #8 sha256:2ced2e7bab16208e5b8b03b8f8ee59f662a5dd9bf047f7b80ac9a29e71254bb5
# #8 DONE 0.4s

# #10 [6/7] COPY requirements.txt .
# #10 sha256:3571c612d6848187874c75aa0f77bbe3f4702372e8213390f089e9a3bc2943d1
# #10 DONE 0.2s

# #11 [7/7] RUN pip install --no-cache-dir -r requirements.txt
# #11 sha256:26ecb7043c95e54215680040a95d58edf31dbe2ce2559d0ef2e2e560c6048aaa
# #11 0.662 Defaulting to user installation because normal site-packages is not writeable
# #11 0.820 Collecting mlflow==2.2.1
# #11 0.869   Downloading mlflow-2.2.1-py3-none-any.whl (17.6 MB)
# #11 2.323      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 17.6/17.6 MB 12.2 MB/s eta 0:00:00
# #11 2.371 Collecting pymysql
# #11 2.381   Downloading PyMySQL-1.0.3-py3-none-any.whl (43 kB)
# #11 2.384      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 43.7/43.7 kB 28.5 MB/s eta 0:00:00
# #11 2.667 Collecting numpy<2
# #11 2.680   Downloading numpy-1.24.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (17.3 MB)
# #11 4.060      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 17.3/17.3 MB 13.0 MB/s eta 0:00:00
# #11 4.325 Collecting protobuf<5,>=3.12.0
# #11 4.342   Downloading protobuf-4.22.1-cp37-abi3-manylinux2014_x86_64.whl (302 kB)
# #11 4.369      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 302.4/302.4 kB 11.8 MB/s eta 0:00:00
# #11 4.563 Collecting matplotlib<4
# #11 4.573   Downloading matplotlib-3.7.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (11.6 MB)
# #11 5.487      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 11.6/11.6 MB 12.8 MB/s eta 0:00:00
# #11 5.704 Collecting pandas<3
# #11 5.718   Downloading pandas-1.5.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (12.1 MB)
# #11 6.781      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 12.1/12.1 MB 11.6 MB/s eta 0:00:00
# #11 6.817 Collecting querystring-parser<2
# #11 6.829   Downloading querystring_parser-1.2.4-py2.py3-none-any.whl (7.9 kB)
# #11 6.873 Collecting alembic<2
# #11 6.888   Downloading alembic-1.10.2-py3-none-any.whl (212 kB)
# #11 6.906      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 212.2/212.2 kB 12.6 MB/s eta 0:00:00
# #11 6.937 Collecting markdown<4,>=3.3
# #11 6.952   Downloading Markdown-3.4.3-py3-none-any.whl (93 kB)
# #11 6.959      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 93.9/93.9 kB 17.3 MB/s eta 0:00:00
# #11 6.994 Collecting Flask<3
# #11 7.024   Downloading Flask-2.2.3-py3-none-any.whl (101 kB)
# #11 7.041      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.8/101.8 kB 8.8 MB/s eta 0:00:00
# #11 7.077 Collecting databricks-cli<1,>=0.8.7
# #11 7.189   Downloading databricks-cli-0.17.6.tar.gz (82 kB)
# #11 7.201      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 82.7/82.7 kB 8.7 MB/s eta 0:00:00
# #11 7.237   Preparing metadata (setup.py): started
# #11 7.590   Preparing metadata (setup.py): finished with status 'done'
# #11 7.651 Collecting gitpython<4,>=2.1.0
# #11 7.664   Downloading GitPython-3.1.31-py3-none-any.whl (184 kB)
# #11 7.679      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 184.3/184.3 kB 13.9 MB/s eta 0:00:00
# #11 7.722 Collecting click<9,>=7.0
# #11 7.733   Downloading click-8.1.3-py3-none-any.whl (96 kB)
# #11 7.743      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 96.6/96.6 kB 11.0 MB/s eta 0:00:00
# #11 7.815 Collecting importlib-metadata!=4.7.0,<7,>=3.7.0
# #11 7.829   Downloading importlib_metadata-6.1.0-py3-none-any.whl (21 kB)
# #11 7.887 Collecting pyyaml<7,>=5.1
# #11 7.901   Downloading PyYAML-6.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (682 kB)
# #11 7.956      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 682.2/682.2 kB 12.9 MB/s eta 0:00:00
# #11 8.010 Collecting requests<3,>=2.17.3
# #11 8.023   Downloading requests-2.28.2-py3-none-any.whl (62 kB)
# #11 8.027      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.8/62.8 kB 28.5 MB/s eta 0:00:00
# #11 8.069 Collecting packaging<24
# #11 8.079   Downloading packaging-23.0-py3-none-any.whl (42 kB)
# #11 8.083      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 42.7/42.7 kB 25.2 MB/s eta 0:00:00
# #11 8.115 Collecting gunicorn<21
# #11 8.124   Downloading gunicorn-20.1.0-py3-none-any.whl (79 kB)
# #11 8.133      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 79.5/79.5 kB 10.2 MB/s eta 0:00:00
# #11 8.154 Collecting sqlparse<1,>=0.4.0
# #11 8.169   Downloading sqlparse-0.4.3-py3-none-any.whl (42 kB)
# #11 8.177      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 42.8/42.8 kB 13.0 MB/s eta 0:00:00
# #11 8.269 Collecting pytz<2023
# #11 8.285   Downloading pytz-2022.7.1-py2.py3-none-any.whl (499 kB)
# #11 8.331      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 499.4/499.4 kB 11.2 MB/s eta 0:00:00
# #11 8.376 Collecting docker<7,>=4.0.0
# #11 8.389   Downloading docker-6.0.1-py3-none-any.whl (147 kB)
# #11 8.401      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 147.5/147.5 kB 13.9 MB/s eta 0:00:00
# #11 8.552 Collecting scipy<2
# #11 8.569   Downloading scipy-1.10.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (34.4 MB)
# #11 11.39      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 34.4/34.4 MB 12.5 MB/s eta 0:00:00
# #11 11.54 Collecting pyarrow<12,>=4.0.0
# #11 11.55   Downloading pyarrow-11.0.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (34.9 MB)
# #11 14.34      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 34.9/34.9 MB 12.8 MB/s eta 0:00:00
# #11 14.44 Collecting Jinja2<4,>=2.11
# #11 14.45   Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
# #11 14.46      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 15.9 MB/s eta 0:00:00
# #11 14.82 Collecting sqlalchemy<3,>=1.4.0
# #11 14.83   Downloading SQLAlchemy-2.0.8-py3-none-any.whl (1.8 MB)
# #11 14.98      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.8/1.8 MB 12.1 MB/s eta 0:00:00
# #11 15.00 Collecting entrypoints<1
# #11 15.02   Downloading entrypoints-0.4-py3-none-any.whl (5.3 kB)
# #11 15.06 Collecting shap<1,>=0.40
# #11 15.09   Downloading shap-0.41.0-cp310-cp310-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (572 kB)
# #11 15.14      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 572.6/572.6 kB 11.6 MB/s eta 0:00:00
# #11 15.26 Collecting scikit-learn<2
# #11 15.28   Downloading scikit_learn-1.2.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (9.6 MB)
# #11 16.05      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 9.6/9.6 MB 12.6 MB/s eta 0:00:00
# #11 16.08 Collecting cloudpickle<3
# #11 16.10   Downloading cloudpickle-2.2.1-py3-none-any.whl (25 kB)
# #11 16.20 Collecting Mako
# #11 16.23   Downloading Mako-1.2.4-py3-none-any.whl (78 kB)
# #11 16.24      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 78.7/78.7 kB 19.2 MB/s eta 0:00:00
# #11 16.27 Collecting typing-extensions>=4
# #11 16.28   Downloading typing_extensions-4.5.0-py3-none-any.whl (27 kB)
# #11 16.35 Collecting pyjwt>=1.7.0
# #11 16.36   Downloading PyJWT-2.6.0-py3-none-any.whl (20 kB)
# #11 16.39 Collecting oauthlib>=3.1.0
# #11 16.40   Downloading oauthlib-3.2.2-py3-none-any.whl (151 kB)
# #11 16.42      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 151.7/151.7 kB 10.5 MB/s eta 0:00:00
# #11 16.45 Collecting tabulate>=0.7.7
# #11 16.47   Downloading tabulate-0.9.0-py3-none-any.whl (35 kB)
# #11 16.51 Collecting six>=1.10.0
# #11 16.52   Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
# #11 16.58 Collecting websocket-client>=0.32.0
# #11 16.59   Downloading websocket_client-1.5.1-py3-none-any.whl (55 kB)
# #11 16.60      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 55.9/55.9 kB 42.4 MB/s eta 0:00:00
# #11 16.64 Collecting urllib3>=1.26.0
# #11 16.66   Downloading urllib3-1.26.15-py2.py3-none-any.whl (140 kB)
# #11 16.67      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 140.9/140.9 kB 13.8 MB/s eta 0:00:00
# #11 16.72 Collecting Werkzeug>=2.2.2
# #11 16.74   Downloading Werkzeug-2.2.3-py3-none-any.whl (233 kB)
# #11 16.76      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 233.6/233.6 kB 12.0 MB/s eta 0:00:00
# #11 16.79 Collecting itsdangerous>=2.0
# #11 16.81   Downloading itsdangerous-2.1.2-py3-none-any.whl (15 kB)
# #11 16.83 Collecting gitdb<5,>=4.0.1
# #11 16.84   Downloading gitdb-4.0.10-py3-none-any.whl (62 kB)
# #11 16.85      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.7/62.7 kB 18.5 MB/s eta 0:00:00
# #11 16.86 Requirement already satisfied: setuptools>=3.0 in /usr/local/lib/python3.10/site-packages (from gunicorn<21->mlflow==2.2.1->-r requirements.txt (line 1)) (65.5.1)
# #11 16.92 Collecting zipp>=0.5
# #11 16.94   Downloading zipp-3.15.0-py3-none-any.whl (6.8 kB)
# #11 17.00 Collecting MarkupSafe>=2.0
# #11 17.02   Downloading MarkupSafe-2.1.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
# #11 17.12 Collecting contourpy>=1.0.1
# #11 17.14   Downloading contourpy-1.0.7-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (300 kB)
# #11 17.17      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 300.3/300.3 kB 11.7 MB/s eta 0:00:00
# #11 17.18 Collecting cycler>=0.10
# #11 17.19   Downloading cycler-0.11.0-py3-none-any.whl (6.4 kB)
# #11 17.26 Collecting fonttools>=4.22.0
# #11 17.28   Downloading fonttools-4.39.3-py3-none-any.whl (1.0 MB)
# #11 17.36      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.0/1.0 MB 12.6 MB/s eta 0:00:00
# #11 17.39 Collecting python-dateutil>=2.7
# #11 17.40   Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
# #11 17.42      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 247.7/247.7 kB 14.1 MB/s eta 0:00:00
# #11 17.49 Collecting kiwisolver>=1.0.1
# #11 17.56   Downloading kiwisolver-1.4.4-cp310-cp310-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (1.6 MB)
# #11 17.71      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.6/1.6 MB 11.0 MB/s eta 0:00:00
# #11 17.98 Collecting pillow>=6.2.0
# #11 18.00   Downloading Pillow-9.4.0-cp310-cp310-manylinux_2_28_x86_64.whl (3.4 MB)
# #11 18.27      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 3.4/3.4 MB 12.5 MB/s eta 0:00:00
# #11 18.32 Collecting pyparsing>=2.3.1
# #11 18.34   Downloading pyparsing-3.0.9-py3-none-any.whl (98 kB)
# #11 18.35      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 98.3/98.3 kB 13.0 MB/s eta 0:00:00
# #11 18.46 Collecting idna<4,>=2.5
# #11 18.47   Downloading idna-3.4-py3-none-any.whl (61 kB)
# #11 18.48      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.5/61.5 kB 11.8 MB/s eta 0:00:00
# #11 18.57 Collecting charset-normalizer<4,>=2
# #11 18.58   Downloading charset_normalizer-3.1.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (199 kB)
# #11 18.60      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 199.3/199.3 kB 11.9 MB/s eta 0:00:00
# #11 18.63 Collecting certifi>=2017.4.17
# #11 18.65   Downloading certifi-2022.12.7-py3-none-any.whl (155 kB)
# #11 18.66      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 155.3/155.3 kB 13.5 MB/s eta 0:00:00
# #11 18.73 Collecting joblib>=1.1.1
# #11 18.75   Downloading joblib-1.2.0-py3-none-any.whl (297 kB)
# #11 18.77      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 298.0/298.0 kB 11.8 MB/s eta 0:00:00
# #11 18.81 Collecting threadpoolctl>=2.0.0
# #11 18.84   Downloading threadpoolctl-3.1.0-py3-none-any.whl (14 kB)
# #11 18.96 Collecting tqdm>4.25.0
# #11 18.97   Downloading tqdm-4.65.0-py3-none-any.whl (77 kB)
# #11 18.98      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 77.1/77.1 kB 14.9 MB/s eta 0:00:00
# #11 19.12 Collecting numba
# #11 19.14   Downloading numba-0.56.4-cp310-cp310-manylinux2014_x86_64.manylinux_2_17_x86_64.whl (3.5 MB)
# #11 19.43      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 3.5/3.5 MB 12.3 MB/s eta 0:00:00
# #11 19.46 Collecting slicer==0.0.7
# #11 19.47   Downloading slicer-0.0.7-py3-none-any.whl (14 kB)
# #11 19.67 Collecting greenlet!=0.4.17
# #11 19.69   Downloading greenlet-2.0.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (613 kB)
# #11 19.74      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 613.7/613.7 kB 12.7 MB/s eta 0:00:00
# #11 19.84 Collecting smmap<6,>=3.0.1
# #11 19.85   Downloading smmap-5.0.0-py3-none-any.whl (24 kB)
# #11 20.04 Collecting numpy<2
# #11 20.08   Downloading numpy-1.23.5-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (17.1 MB)
# #11 21.46      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 17.1/17.1 MB 12.5 MB/s eta 0:00:00
# #11 21.59 Collecting llvmlite<0.40,>=0.39.0dev0
# #11 21.60   Downloading llvmlite-0.39.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (34.6 MB)
# #11 24.38      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 34.6/34.6 MB 12.7 MB/s eta 0:00:00
# #11 24.47 Building wheels for collected packages: databricks-cli
# #11 24.47   Building wheel for databricks-cli (setup.py): started
# #11 24.97   Building wheel for databricks-cli (setup.py): finished with status 'done'
# #11 24.97   Created wheel for databricks-cli: filename=databricks_cli-0.17.6-py3-none-any.whl size=143221 sha256=66bb62b746d07abc543d99455662dda0779a5ef7155fa280e6130fa2ef0011cd
# #11 24.97   Stored in directory: /tmp/pip-ephem-wheel-cache-do4rxir2/wheels/7b/85/a1/37b9b24f55c1da8ea4795765de41713b8a2cccad89c866e26b
# #11 24.97 Successfully built databricks-cli
# #11 25.34 Installing collected packages: pytz, zipp, websocket-client, urllib3, typing-extensions, tqdm, threadpoolctl, tabulate, sqlparse, smmap, slicer, six, pyyaml, pyparsing, pymysql, pyjwt, protobuf, pillow, packaging, oauthlib, numpy, MarkupSafe, markdown, llvmlite, kiwisolver, joblib, itsdangerous, idna, gunicorn, greenlet, fonttools, entrypoints, cycler, cloudpickle, click, charset-normalizer, certifi, Werkzeug, sqlalchemy, scipy, requests, querystring-parser, python-dateutil, pyarrow, numba, Mako, Jinja2, importlib-metadata, gitdb, contourpy, scikit-learn, pandas, matplotlib, gitpython, Flask, docker, databricks-cli, alembic, shap, mlflow
# #11 49.49 Successfully installed Flask-2.2.3 Jinja2-3.1.2 Mako-1.2.4 MarkupSafe-2.1.2 Werkzeug-2.2.3 alembic-1.10.2 certifi-2022.12.7 charset-normalizer-3.1.0 click-8.1.3 cloudpickle-2.2.1 contourpy-1.0.7 cycler-0.11.0 databricks-cli-0.17.6 docker-6.0.1 entrypoints-0.4 fonttools-4.39.3 gitdb-4.0.10 gitpython-3.1.31 greenlet-2.0.2 gunicorn-20.1.0 idna-3.4 importlib-metadata-6.1.0 itsdangerous-2.1.2 joblib-1.2.0 kiwisolver-1.4.4 llvmlite-0.39.1 markdown-3.4.3 matplotlib-3.7.1 mlflow-2.2.1 numba-0.56.4 numpy-1.23.5 oauthlib-3.2.2 packaging-23.0 pandas-1.5.3 pillow-9.4.0 protobuf-4.22.1 pyarrow-11.0.0 pyjwt-2.6.0 pymysql-1.0.3 pyparsing-3.0.9 python-dateutil-2.8.2 pytz-2022.7.1 pyyaml-6.0 querystring-parser-1.2.4 requests-2.28.2 scikit-learn-1.2.2 scipy-1.10.1 shap-0.41.0 six-1.16.0 slicer-0.0.7 smmap-5.0.0 sqlalchemy-2.0.8 sqlparse-0.4.3 tabulate-0.9.0 threadpoolctl-3.1.0 tqdm-4.65.0 typing-extensions-4.5.0 urllib3-1.26.15 websocket-client-1.5.1 zipp-3.15.0
# #11 DONE 58.5s

# #12 exporting to image
# #12 sha256:e8c613e07b0b7ff33893b694f7759a10d42e180f2b4dc349fb57dc6b71dcab00
# #12 exporting layers
# #12 exporting layers 3.5s done
# #12 writing image sha256:f6b23317c10ecd601c64e950c2b0aea191c14535e426c9aeea86d2e0623bb8ca
# #12 writing image sha256:f6b23317c10ecd601c64e950c2b0aea191c14535e426c9aeea86d2e0623bb8ca 0.0s done
# #12 naming to docker.io/library/mlflow_tracker_slim done
# #12 DONE 3.6s