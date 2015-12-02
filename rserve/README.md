[![Apache Zeppelin](http://datalayer.io/ext/images/logo-zeppelin-small.png)](http://zeppelin.incubator.apache.org)

[![Docker](http://datalayer.io/ext/images/docker-logo-small.png)](https://www.docker.com/)

[![Datalayer](http://datalayer.io/ext/images/logo_horizontal_072ppi.png)](http://datalayer.io)

[![R](http://datalayer.io/ext/images/logo-R-200.png)](http://cran.r-project.org)

# Zeppelin R Docker Image (based on Rserve)

## Get the image from the Docker Repository

In order to get the image, you can run with the appropriate rights:

`docker pull datalayer/zeppelin-rserve`

Run the Zeppelin notebook with:

`docker run -it -p 2222:22 -p 8080:8080 -p 4040:4040 datalayer/zeppelin-rserve`

and go to [http://localhost:8080](http://localhost:8080).

Read more on the online [Datalayer Docker Registry](https://hub.docker.com/u/datalayer/zeppelin-rserve).

## Build and Run

Build the Docker image with `zeppelin-docker-build` and run with `zeppelin-docker-start`.

## Configuration

Configure with environment variables:

+ DOCKER_SPARK_MASTER = MASTER for Spark (default is `local[*]`).
+ DOCKER_ZEPPELIN_NOTEBOOK_DIR = Folder where the notes reside  (default is `/notebook`).
+ DOCKER_ZEPPELIN_PORT = The HTTP port (default is `8080`).
+ DOCKER_HADOOP_CONF_DIR = The folder for the Hadoop configuration file (default is `/etc/hadoop/conf`).
+ DOCKER_ZEPPELIN_LOG_CONSOLE = Run in attached mode with a tail of the log file (default is `true`).

Example: `DOCKER_ZEPPELIN_PORT=8081 ./zeppelin-docker-start`

PS: If you need to change the Hadoop configuration, you will have to rebuild the Docker image.

## R Libraries

The Docker image comes with the following R libraries

+ knitr
+ glmnet
+ pROC
+ data.table
+ caret
+ sqldf
+ wordcloud
+ devtools
+ rscala

If you want to install additional libraries (for example ff, a memory-efficient storage of large data on disk and fast access functions)

Option 1

Type `%r install.packages("ff", repos = "http://cran.us.r-project.org")` in a parapgraph of the notebook and run the paragraph.


Option 2: Run from the shell (password in `datalayer`).

```
ssh root@localhost -p 2222 """R --no-save <<RSCRIPT
install.packages(\"ff\", repos = \"http://cran.us.r-project.org\")
RSCRIPT"""
```

Once done, `%r library(ff)` is working in the notebook.

# Licensed under GNU General Public License

Due to Rserve license, this project is licesened under GPL.

Copyright (c) 2016 Datalayer (http://datalayer.io)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
