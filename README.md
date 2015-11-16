[![Apache Zeppelin](http://datalayer.io/ext/images/logo-zeppelin-small.png)](http://zeppelin.incubator.apache.org)

[![Docker](http://datalayer.io/ext/images/docker-logo-small.png)](https://www.docker.com/)

[![Datalayer](http://datalayer.io/ext/images/logo_horizontal_072ppi.png)](http://datalayer.io)

# Zeppelin Docker

## Run

Get the Docker image with `docker pull datalayer/zeppelin` (it might take a while to download) and launch with `./zeppelin-docker-start`.

## Configuration

Configure with environment variables:

+ DOCKER_SPARK_MASTER = MASTER for Spark (default is `local[*]`).
+ DOCKER_ZEPPELIN_NOTEBOOK_DIR = Folder where the notes reside  (default is `/notebook`).
+ DOCKER_ZEPPELIN_PORT = The HTTP port (default is `8080`).
+ DOCKER_HADOOP_CONF_DIR = The folder for the Hadoop configuration file (default is `/etc/hadoop/conf`).
+ DOCKER_ZEPPELIN_LOG_CONSOLE = Run in attached mode with a tail of the log file (default is `true`).

Example: `DOCKER_ZEPPELIN_PORT=8081 ./zeppelin-docker-start`

PS: If you need to change the Hadoop configuration, you will have to rebuild the Docker image.

## Build

Build your own docker image with `./zeppelin-docker-build`.

# License

Copyright 2015 Datalayer http://datalayer.io

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
