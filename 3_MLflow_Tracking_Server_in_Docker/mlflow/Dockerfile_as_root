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

CMD mlflow server --backend-store-uri ${BACKEND_STORE_URI} --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} --artifacts-destination ${DEFAULT_ARTIFACTS_DESTINATION} --no-serve-artifacts --host 0.0.0.0 --port 5000


# ======================================================================================================================================
# VERBOSE Image build:
# ======================================================================================================================================

# Build the image with:

# $ docker build --progress plain --no-cache -t mlflow_tracker_slim .

# Logged info:
# #1 [internal] load build definition from Dockerfile
# #1 sha256:6bd89f66aca3999c44d75e204ec59a95514edc8a2002743dea561b2aed25da92
# #1 transferring dockerfile: 38B done
# #1 DONE 0.0s

# #2 [internal] load .dockerignore
# #2 sha256:afeaff6c61a9651ff78821449af8fc59049a4852cc5dd985ca01661723b978da
# #2 transferring context: 35B done
# #2 DONE 0.0s

# #3 [internal] load metadata for docker.io/library/python:3.10-slim
# #3 sha256:b8cce7183299ea8471dad4044ce489ad9730ef208466a01382bd3a85a0492215
# #3 DONE 0.5s

# #4 [1/6] FROM docker.io/library/python:3.10-slim@sha256:7b0a5cefbcdd085faa21533c21549e55a7e66f5aed40f8d1f4de13a017e352cd
# #4 sha256:3cf59a99c4595deb0a6ac22ffe47f994a753ae4eb206482ee918e1e89f008545
# #4 CACHED

# #8 [internal] load build context
# #8 sha256:e585b197eb620de888fbe31c0dcf6135d6ebca2901191ffffaaaf55945d5947f
# #8 transferring context: 37B done
# #8 DONE 0.0s

# #5 [2/6] RUN apt-get update && apt-get -y upgrade     && pip install --upgrade pip     && pip --version
# #5 sha256:ee326e143ec81e4f7025634419c33dcc99cdf12628189df109674795020eb0d7
# #5 0.415 Get:1 http://deb.debian.org/debian bullseye InRelease [116 kB]
# #5 0.442 Get:2 http://deb.debian.org/debian-security bullseye-security InRelease [48.4 kB]
# #5 0.679 Get:3 http://deb.debian.org/debian bullseye-updates InRelease [44.1 kB]
# #5 0.688 Get:4 http://deb.debian.org/debian bullseye/main amd64 Packages [8183 kB]
# #5 1.341 Get:5 http://deb.debian.org/debian-security bullseye-security/main amd64 Packages [236 kB]
# #5 1.363 Get:6 http://deb.debian.org/debian bullseye-updates/main amd64 Packages [14.6 kB]
# #5 2.208 Fetched 8642 kB in 2s (4754 kB/s)
# #5 2.208 Reading package lists...
# #5 2.544 Reading package lists...
# #5 2.846 Building dependency tree...
# #5 2.923 Reading state information...
# #5 2.935 Calculating upgrade...
# #5 3.071 The following packages will be upgraded:
# #5 3.071   tzdata
# #5 3.099 1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
# #5 3.099 Need to get 286 kB of archives.
# #5 3.099 After this operation, 20.5 kB of additional disk space will be used.
# #5 3.099 Get:1 http://deb.debian.org/debian bullseye-updates/main amd64 tzdata all 2021a-1+deb11u9 [286 kB]
# #5 3.245 debconf: delaying package configuration, since apt-utils is not installed
# #5 3.274 Fetched 286 kB in 0s (4726 kB/s)
# (Reading database ... 7031 files and directories currently installed.)
# #5 3.333 Preparing to unpack .../tzdata_2021a-1+deb11u9_all.deb ...
# #5 3.361 Unpacking tzdata (2021a-1+deb11u9) over (2021a-1+deb11u8) ...
# #5 6.159 Setting up tzdata (2021a-1+deb11u9) ...
# #5 6.213 debconf: unable to initialize frontend: Dialog
# #5 6.213 debconf: (TERM is not set, so the dialog frontend is not usable.)
# #5 6.213 debconf: falling back to frontend: Readline
# #5 6.213 debconf: unable to initialize frontend: Readline
# #5 6.213 debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.32.1 /usr/local/share/perl/5.32.1 /usr/lib/x86_64-linux-gnu/perl5/5.32 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.32 /usr/share/perl/5.32 /usr/local/lib/site_perl) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
# #5 6.213 debconf: falling back to frontend: Teletype
# #5 6.243
# #5 6.243 Current default time zone: 'Etc/UTC'
# #5 6.244 Local time is now:      Sun Mar 26 11:28:28 UTC 2023.
# #5 6.244 Universal Time is now:  Sun Mar 26 11:28:28 UTC 2023.
# #5 6.244 Run 'dpkg-reconfigure tzdata' if you wish to change it.
# #5 6.244
# #5 7.394 Requirement already satisfied: pip in /usr/local/lib/python3.10/site-packages (22.3.1)
# #5 7.538 Collecting pip
# #5 7.581   Downloading pip-23.0.1-py3-none-any.whl (2.1 MB)
# #5 7.781      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.1/2.1 MB 10.5 MB/s eta 0:00:00
# #5 7.830 Installing collected packages: pip
# #5 7.830   Attempting uninstall: pip
# #5 7.831     Found existing installation: pip 22.3.1
# #5 7.898     Uninstalling pip-22.3.1:
# #5 8.032       Successfully uninstalled pip-22.3.1
# #5 8.891 Successfully installed pip-23.0.1
# #5 8.891 WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
# #5 9.263 pip 23.0.1 from /usr/local/lib/python3.10/site-packages/pip (python 3.10)
# #5 DONE 9.4s

# #6 [3/6] RUN apt-get update && apt-get install -y procps     && rm -rf /var/lib/apt/lists/*
# #6 sha256:f85b9777f5c79b62f73815a47d1ffc804a11dbcae588afc83ba4c32618e71526
# #6 0.614 Hit:1 http://deb.debian.org/debian bullseye InRelease
# #6 0.614 Hit:2 http://deb.debian.org/debian-security bullseye-security InRelease
# #6 0.616 Hit:3 http://deb.debian.org/debian bullseye-updates InRelease
# #6 0.817 Reading package lists...
# #6 1.114 Reading package lists...
# #6 1.486 Building dependency tree...
# #6 1.583 Reading state information...
# #6 1.664 The following additional packages will be installed:
# #6 1.664   libgpm2 libncurses6 libprocps8 psmisc
# #6 1.665 Suggested packages:
# #6 1.665   gpm
# #6 1.696 The following NEW packages will be installed:
# #6 1.696   libgpm2 libncurses6 libprocps8 procps psmisc
# #6 1.720 0 upgraded, 5 newly installed, 0 to remove and 0 not upgraded.
# #6 1.720 Need to get 902 kB of archives.
# #6 1.720 After this operation, 3044 kB of additional disk space will be used.
# #6 1.720 Get:1 http://deb.debian.org/debian bullseye/main amd64 libncurses6 amd64 6.2+20201114-2 [102 kB]
# #6 1.743 Get:2 http://deb.debian.org/debian bullseye/main amd64 libprocps8 amd64 2:3.3.17-5 [63.9 kB]
# #6 1.749 Get:3 http://deb.debian.org/debian bullseye/main amd64 procps amd64 2:3.3.17-5 [502 kB]
# #6 1.786 Get:4 http://deb.debian.org/debian bullseye/main amd64 libgpm2 amd64 1.20.7-8 [35.6 kB]
# #6 1.788 Get:5 http://deb.debian.org/debian bullseye/main amd64 psmisc amd64 23.4-2 [198 kB]
# #6 1.873 debconf: delaying package configuration, since apt-utils is not installed
# #6 1.894 Fetched 902 kB in 0s (8592 kB/s)
# #6 1.917 Selecting previously unselected package libncurses6:amd64.
# (Reading database ... 7034 files and directories currently installed.)
# #6 1.921 Preparing to unpack .../libncurses6_6.2+20201114-2_amd64.deb ...
# #6 1.928 Unpacking libncurses6:amd64 (6.2+20201114-2) ...
# #6 1.962 Selecting previously unselected package libprocps8:amd64.
# #6 1.963 Preparing to unpack .../libprocps8_2%3a3.3.17-5_amd64.deb ...
# #6 1.966 Unpacking libprocps8:amd64 (2:3.3.17-5) ...
# #6 2.001 Selecting previously unselected package procps.
# #6 2.002 Preparing to unpack .../procps_2%3a3.3.17-5_amd64.deb ...
# #6 2.008 Unpacking procps (2:3.3.17-5) ...
# #6 2.072 Selecting previously unselected package libgpm2:amd64.
# #6 2.073 Preparing to unpack .../libgpm2_1.20.7-8_amd64.deb ...
# #6 2.078 Unpacking libgpm2:amd64 (1.20.7-8) ...
# #6 2.103 Selecting previously unselected package psmisc.
# #6 2.104 Preparing to unpack .../psmisc_23.4-2_amd64.deb ...
# #6 2.107 Unpacking psmisc (23.4-2) ...
# #6 2.155 Setting up libgpm2:amd64 (1.20.7-8) ...
# #6 2.165 Setting up psmisc (23.4-2) ...
# #6 2.176 Setting up libncurses6:amd64 (6.2+20201114-2) ...
# #6 2.186 Setting up libprocps8:amd64 (2:3.3.17-5) ...
# #6 2.196 Setting up procps (2:3.3.17-5) ...
# #6 2.227 Processing triggers for libc-bin (2.31-13+deb11u5) ...
# #6 DONE 2.3s

# #7 [4/6] WORKDIR /mlflow/
# #7 sha256:05c8ad7b6a5fe5f7a6962058db5d3acca765b9e414b9bf4c15ad15e655027dda
# #7 DONE 0.0s

# #9 [5/6] COPY requirements.txt .
# #9 sha256:9d713a9270aac218aa4816972d7ef114748d0ea6596d60d7d2b9ecc84051b80f
# #9 DONE 0.0s

# #10 [6/6] RUN pip install --no-cache-dir -r requirements.txt     && rm requirements.txt
# #10 sha256:48c952ad0702651910de126938fad6e509246e117b70fba0a8d6425b611901cd
# #10 0.770 Collecting mlflow==2.2.1
# #10 0.811   Downloading mlflow-2.2.1-py3-none-any.whl (17.6 MB)
# #10 2.181      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 17.6/17.6 MB 13.0 MB/s eta 0:00:00
# #10 2.221 Collecting pymysql
# #10 2.232   Downloading PyMySQL-1.0.2-py3-none-any.whl (43 kB)
# #10 2.235      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 43.8/43.8 kB 72.1 MB/s eta 0:00:00
# #10 2.280 Collecting entrypoints<1
# #10 2.289   Downloading entrypoints-0.4-py3-none-any.whl (5.3 kB)
# #10 2.382 Collecting pyarrow<12,>=4.0.0
# #10 2.395   Downloading pyarrow-11.0.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (34.9 MB)
# #10 5.105      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 34.9/34.9 MB 13.2 MB/s eta 0:00:00
# #10 5.372 Collecting protobuf<5,>=3.12.0
# #10 5.392   Downloading protobuf-4.22.1-cp37-abi3-manylinux2014_x86_64.whl (302 kB)
# #10 5.418      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 302.4/302.4 kB 13.0 MB/s eta 0:00:00
# #10 5.812 Collecting sqlalchemy<3,>=1.4.0
# #10 5.823   Downloading SQLAlchemy-2.0.7-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (2.7 MB)
# #10 6.031      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.7/2.7 MB 13.2 MB/s eta 0:00:00
# #10 6.081 Collecting gitpython<4,>=2.1.0
# #10 6.092   Downloading GitPython-3.1.31-py3-none-any.whl (184 kB)
# #10 6.105      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 184.3/184.3 kB 16.6 MB/s eta 0:00:00
# #10 6.132 Collecting gunicorn<21
# #10 6.146   Downloading gunicorn-20.1.0-py3-none-any.whl (79 kB)
# #10 6.154      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 79.5/79.5 kB 12.7 MB/s eta 0:00:00
# #10 6.177 Collecting cloudpickle<3
# #10 6.189   Downloading cloudpickle-2.2.1-py3-none-any.whl (25 kB)
# #10 6.477 Collecting numpy<2
# #10 6.488   Downloading numpy-1.24.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (17.3 MB)
# #10 7.820      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 17.3/17.3 MB 13.2 MB/s eta 0:00:00
# #10 7.893 Collecting pyyaml<7,>=5.1
# #10 7.903   Downloading PyYAML-6.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (682 kB)
# #10 7.956      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 682.2/682.2 kB 13.3 MB/s eta 0:00:00
# #10 7.982 Collecting databricks-cli<1,>=0.8.7
# #10 7.992   Downloading databricks-cli-0.17.6.tar.gz (82 kB)
# #10 7.999      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 82.7/82.7 kB 14.6 MB/s eta 0:00:00
# #10 8.020   Preparing metadata (setup.py): started
# #10 8.422   Preparing metadata (setup.py): finished with status 'done'
# #10 8.604 Collecting matplotlib<4
# #10 8.615   Downloading matplotlib-3.7.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (11.6 MB)
# #10 9.509      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 11.6/11.6 MB 13.0 MB/s eta 0:00:00
# #10 9.574 Collecting requests<3,>=2.17.3
# #10 9.583   Downloading requests-2.28.2-py3-none-any.whl (62 kB)
# #10 9.589      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.8/62.8 kB 20.8 MB/s eta 0:00:00
# #10 9.631 Collecting shap<1,>=0.40
# #10 9.643   Downloading shap-0.41.0-cp310-cp310-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (572 kB)
# #10 9.688      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 572.6/572.6 kB 13.3 MB/s eta 0:00:00
# #10 9.810 Collecting scikit-learn<2
# #10 9.838   Downloading scikit_learn-1.2.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (9.6 MB)
# #10 10.54      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 9.6/9.6 MB 13.3 MB/s eta 0:00:00
# #10 10.59 Collecting docker<7,>=4.0.0
# #10 10.60   Downloading docker-6.0.1-py3-none-any.whl (147 kB)
# #10 10.61      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 147.5/147.5 kB 16.7 MB/s eta 0:00:00
# #10 10.80 Collecting scipy<2
# #10 10.81   Downloading scipy-1.10.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (34.4 MB)
# #10 13.66      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 34.4/34.4 MB 13.0 MB/s eta 0:00:00
# #10 13.76 Collecting pytz<2023
# #10 13.77   Downloading pytz-2022.7.1-py2.py3-none-any.whl (499 kB)
# #10 13.81      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 499.4/499.4 kB 12.7 MB/s eta 0:00:00
# #10 13.84 Collecting Jinja2<4,>=2.11
# #10 13.85   Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
# #10 13.86      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 16.3 MB/s eta 0:00:00
# #10 13.89 Collecting markdown<4,>=3.3
# #10 13.90   Downloading Markdown-3.4.3-py3-none-any.whl (93 kB)
# #10 13.91      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 93.9/93.9 kB 16.6 MB/s eta 0:00:00
# #10 14.08 Collecting pandas<3
# #10 14.09   Downloading pandas-1.5.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (12.1 MB)
# #10 15.03      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 12.1/12.1 MB 12.9 MB/s eta 0:00:00
# #10 15.07 Collecting querystring-parser<2
# #10 15.08   Downloading querystring_parser-1.2.4-py2.py3-none-any.whl (7.9 kB)
# #10 15.11 Collecting packaging<24
# #10 15.12   Downloading packaging-23.0-py3-none-any.whl (42 kB)
# #10 15.12      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 42.7/42.7 kB 30.1 MB/s eta 0:00:00
# #10 15.15 Collecting sqlparse<1,>=0.4.0
# #10 15.16   Downloading sqlparse-0.4.3-py3-none-any.whl (42 kB)
# #10 15.16      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 42.8/42.8 kB 277.6 MB/s eta 0:00:00
# #10 15.22 Collecting importlib-metadata!=4.7.0,<7,>=3.7.0
# #10 15.23   Downloading importlib_metadata-6.1.0-py3-none-any.whl (21 kB)
# #10 15.27 Collecting alembic<2
# #10 15.28   Downloading alembic-1.10.2-py3-none-any.whl (212 kB)
# #10 15.30      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 212.2/212.2 kB 14.8 MB/s eta 0:00:00
# #10 15.33 Collecting Flask<3
# #10 15.34   Downloading Flask-2.2.3-py3-none-any.whl (101 kB)
# #10 15.35      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.8/101.8 kB 17.3 MB/s eta 0:00:00
# #10 15.41 Collecting click<9,>=7.0
# #10 15.42   Downloading click-8.1.3-py3-none-any.whl (96 kB)
# #10 15.43      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 96.6/96.6 kB 13.2 MB/s eta 0:00:00
# #10 15.46 Collecting Mako
# #10 15.47   Downloading Mako-1.2.4-py3-none-any.whl (78 kB)
# #10 15.48      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 78.7/78.7 kB 14.3 MB/s eta 0:00:00
# #10 15.52 Collecting typing-extensions>=4
# #10 15.53   Downloading typing_extensions-4.5.0-py3-none-any.whl (27 kB)
# #10 15.59 Collecting pyjwt>=1.7.0
# #10 15.60   Downloading PyJWT-2.6.0-py3-none-any.whl (20 kB)
# #10 15.62 Collecting oauthlib>=3.1.0
# #10 15.63   Downloading oauthlib-3.2.2-py3-none-any.whl (151 kB)
# #10 15.65      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 151.7/151.7 kB 13.0 MB/s eta 0:00:00
# #10 15.67 Collecting tabulate>=0.7.7
# #10 15.68   Downloading tabulate-0.9.0-py3-none-any.whl (35 kB)
# #10 15.71 Collecting six>=1.10.0
# #10 15.72   Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
# #10 15.77 Collecting urllib3>=1.26.0
# #10 15.78   Downloading urllib3-1.26.15-py2.py3-none-any.whl (140 kB)
# #10 15.80      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 140.9/140.9 kB 16.0 MB/s eta 0:00:00
# #10 15.83 Collecting websocket-client>=0.32.0
# #10 15.84   Downloading websocket_client-1.5.1-py3-none-any.whl (55 kB)
# #10 15.84      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 55.9/55.9 kB 15.9 MB/s eta 0:00:00
# #10 15.88 Collecting itsdangerous>=2.0
# #10 15.88   Downloading itsdangerous-2.1.2-py3-none-any.whl (15 kB)
# #10 15.93 Collecting Werkzeug>=2.2.2
# #10 15.94   Downloading Werkzeug-2.2.3-py3-none-any.whl (233 kB)
# #10 15.96      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 233.6/233.6 kB 13.2 MB/s eta 0:00:00
# #10 15.98 Collecting gitdb<5,>=4.0.1
# #10 15.99   Downloading gitdb-4.0.10-py3-none-any.whl (62 kB)
# #10 15.99      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.7/62.7 kB 35.8 MB/s eta 0:00:00
# #10 16.00 Requirement already satisfied: setuptools>=3.0 in /usr/local/lib/python3.10/site-packages (from gunicorn<21->mlflow==2.2.1->-r requirements.txt (line 1)) (65.5.1)
# #10 16.05 Collecting zipp>=0.5
# #10 16.06   Downloading zipp-3.15.0-py3-none-any.whl (6.8 kB)
# #10 16.13 Collecting MarkupSafe>=2.0
# #10 16.15   Downloading MarkupSafe-2.1.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
# #10 16.18 Collecting cycler>=0.10
# #10 16.19   Downloading cycler-0.11.0-py3-none-any.whl (6.4 kB)
# #10 16.29 Collecting fonttools>=4.22.0
# #10 16.30   Downloading fonttools-4.39.2-py3-none-any.whl (1.0 MB)
# #10 16.39      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.0/1.0 MB 11.8 MB/s eta 0:00:00
# #10 16.43 Collecting python-dateutil>=2.7
# #10 16.45   Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
# #10 16.47      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 247.7/247.7 kB 14.6 MB/s eta 0:00:00
# #10 16.72 Collecting pillow>=6.2.0
# #10 16.73   Downloading Pillow-9.4.0-cp310-cp310-manylinux_2_28_x86_64.whl (3.4 MB)
# #10 16.99      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 3.4/3.4 MB 13.1 MB/s eta 0:00:00
# #10 17.03 Collecting pyparsing>=2.3.1
# #10 17.04   Downloading pyparsing-3.0.9-py3-none-any.whl (98 kB)
# #10 17.05      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 98.3/98.3 kB 15.2 MB/s eta 0:00:00
# #10 17.12 Collecting kiwisolver>=1.0.1
# #10 17.13   Downloading kiwisolver-1.4.4-cp310-cp310-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (1.6 MB)
# #10 17.26      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.6/1.6 MB 13.1 MB/s eta 0:00:00
# #10 17.35 Collecting contourpy>=1.0.1
# #10 17.36   Downloading contourpy-1.0.7-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (300 kB)
# #10 17.39      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 300.3/300.3 kB 12.0 MB/s eta 0:00:00
# #10 17.53 Collecting idna<4,>=2.5
# #10 17.54   Downloading idna-3.4-py3-none-any.whl (61 kB)
# #10 17.55      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.5/61.5 kB 13.0 MB/s eta 0:00:00
# #10 17.60 Collecting certifi>=2017.4.17
# #10 17.62   Downloading certifi-2022.12.7-py3-none-any.whl (155 kB)
# #10 17.63      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 155.3/155.3 kB 17.9 MB/s eta 0:00:00
# #10 17.72 Collecting charset-normalizer<4,>=2
# #10 17.73   Downloading charset_normalizer-3.1.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (199 kB)
# #10 17.75      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 199.3/199.3 kB 12.8 MB/s eta 0:00:00
# #10 17.81 Collecting threadpoolctl>=2.0.0
# #10 17.82   Downloading threadpoolctl-3.1.0-py3-none-any.whl (14 kB)
# #10 17.85 Collecting joblib>=1.1.1
# #10 17.87   Downloading joblib-1.2.0-py3-none-any.whl (297 kB)
# #10 17.89      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 298.0/298.0 kB 12.8 MB/s eta 0:00:00
# #10 18.01 Collecting tqdm>4.25.0
# #10 18.02   Downloading tqdm-4.65.0-py3-none-any.whl (77 kB)
# #10 18.03      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 77.1/77.1 kB 14.3 MB/s eta 0:00:00
# #10 18.05 Collecting slicer==0.0.7
# #10 18.05   Downloading slicer-0.0.7-py3-none-any.whl (14 kB)
# #10 18.20 Collecting numba
# #10 18.21   Downloading numba-0.56.4-cp310-cp310-manylinux2014_x86_64.manylinux_2_17_x86_64.whl (3.5 MB)
# #10 18.48      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 3.5/3.5 MB 13.1 MB/s eta 0:00:00
# #10 18.71 Collecting greenlet!=0.4.17
# #10 18.72   Downloading greenlet-2.0.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (613 kB)
# #10 18.78      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 613.7/613.7 kB 10.5 MB/s eta 0:00:00
# #10 18.88 Collecting smmap<6,>=3.0.1
# #10 18.89   Downloading smmap-5.0.0-py3-none-any.whl (24 kB)
# #10 19.15 Collecting llvmlite<0.40,>=0.39.0dev0
# #10 19.16   Downloading llvmlite-0.39.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (34.6 MB)
# #10 21.99      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 34.6/34.6 MB 10.9 MB/s eta 0:00:00
# #10 22.04 Collecting numpy<2
# #10 22.05   Downloading numpy-1.23.5-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (17.1 MB)
# #10 23.38      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 17.1/17.1 MB 12.8 MB/s eta 0:00:00
# #10 23.46 Building wheels for collected packages: databricks-cli
# #10 23.46   Building wheel for databricks-cli (setup.py): started
# #10 23.86   Building wheel for databricks-cli (setup.py): finished with status 'done'
# #10 23.86   Created wheel for databricks-cli: filename=databricks_cli-0.17.6-py3-none-any.whl size=143221 sha256=7e2c3b813c9be8275aab380b704f67f14cbffe43f8673b05cdf0a36a91d3a1f9
# #10 23.86   Stored in directory: /tmp/pip-ephem-wheel-cache-5qcnu0mj/wheels/7b/85/a1/37b9b24f55c1da8ea4795765de41713b8a2cccad89c866e26b
# #10 23.87 Successfully built databricks-cli
# #10 24.23 Installing collected packages: pytz, zipp, websocket-client, urllib3, typing-extensions, tqdm, threadpoolctl, tabulate, sqlparse, smmap, slicer, six, pyyaml, pyparsing, pymysql, pyjwt, protobuf, pillow, packaging, oauthlib, numpy, MarkupSafe, markdown, llvmlite, kiwisolver, joblib, itsdangerous, idna, gunicorn, greenlet, fonttools, entrypoints, cycler, cloudpickle, click, charset-normalizer, certifi, Werkzeug, sqlalchemy, scipy, requests, querystring-parser, python-dateutil, pyarrow, numba, Mako, Jinja2, importlib-metadata, gitdb, contourpy, scikit-learn, pandas, matplotlib, gitpython, Flask, docker, databricks-cli, alembic, shap, mlflow
# #10 42.34 Successfully installed Flask-2.2.3 Jinja2-3.1.2 Mako-1.2.4 MarkupSafe-2.1.2 Werkzeug-2.2.3 alembic-1.10.2 certifi-2022.12.7 charset-normalizer-3.1.0 click-8.1.3 cloudpickle-2.2.1 contourpy-1.0.7 cycler-0.11.0 databricks-cli-0.17.6 docker-6.0.1 entrypoints-0.4 fonttools-4.39.2 gitdb-4.0.10 gitpython-3.1.31 greenlet-2.0.2 gunicorn-20.1.0 idna-3.4 importlib-metadata-6.1.0 itsdangerous-2.1.2 joblib-1.2.0 kiwisolver-1.4.4 llvmlite-0.39.1 markdown-3.4.3 matplotlib-3.7.1 mlflow-2.2.1 numba-0.56.4 numpy-1.23.5 oauthlib-3.2.2 packaging-23.0 pandas-1.5.3 pillow-9.4.0 protobuf-4.22.1 pyarrow-11.0.0 pyjwt-2.6.0 pymysql-1.0.2 pyparsing-3.0.9 python-dateutil-2.8.2 pytz-2022.7.1 pyyaml-6.0 querystring-parser-1.2.4 requests-2.28.2 scikit-learn-1.2.2 scipy-1.10.1 shap-0.41.0 six-1.16.0 slicer-0.0.7 smmap-5.0.0 sqlalchemy-2.0.7 sqlparse-0.4.3 tabulate-0.9.0 threadpoolctl-3.1.0 tqdm-4.65.0 typing-extensions-4.5.0 urllib3-1.26.15 websocket-client-1.5.1 zipp-3.15.0
# #10 42.34 WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
# #10 DONE 43.4s

# #11 exporting to image
# #11 sha256:e8c613e07b0b7ff33893b694f7759a10d42e180f2b4dc349fb57dc6b71dcab00
# #11 exporting layers
# #11 exporting layers 3.4s done
# #11 writing image sha256:5e5b8af6dae6f2477da7a8eda7032af161d8b13ba6193a1cb293ce252cfd1750 done
# #11 naming to docker.io/library/mlflow_tracker_slim done
# #11 DONE 3.5s