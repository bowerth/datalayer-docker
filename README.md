[![Apache Zeppelin](http://datalayer.io/ext/images/logo-zeppelin-small.png)](http://zeppelin.incubator.apache.org)

[![Docker](http://datalayer.io/ext/images/docker-logo-small.png)](https://www.docker.com/)

[![Datalayer](http://datalayer.io/ext/images/logo_horizontal_072ppi.png)](http://datalayer.io)

# Zeppelin Docker

## Run

Get the Docker image with `docker pull datalayer/zeppelin` (it might take a while to download) and launch with `./zeppelin-docker-start`.

## Configuration

Set environement variable to change behavior:

+ DOCKER_SPARK_MASTER = MASTER for Spark (default is `local[*]`).
+ DOCKER_ZEPPELIN_NOTEBOOK_DIR = Folder where the notes reside  (default is `/notebook`).
+ DOCKER_ZEPPELIN_PORT = The HTTP port (default is `8080`).
+ DOCKER_HADOOP_CONF_DIR = The folder for the Hadoop configuration file (default is `/etc/hadoop/conf`).
+ DOCKER_ZEPPELIN_LOG_CONSOLE = Run in attached mode with a tail of the log file (default is `true`).

Example: `DOCKER_ZEPPELIN_PORT=8081 ./zeppelin-docker-start`

## Build

Build your own docker image with `./zeppelin-docker-build`.

# Licensed under GNU General Public License

Copyright (c) 2015 Datalayer (http://datalayer.io)

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
