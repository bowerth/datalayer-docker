# Licensed to Datalayer (http://datalayer.io) under one or more
# contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. Datalayer licenses this file
# to you under the Apache License, Version 2.0 (the 
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM ubuntu:14.04

MAINTAINER Datalayer <docker@datalayer.io>

ENV PATH .:$PATH

RUN apt-get update

RUN apt-get install -y git wget unzip curl net-tools build-essential npm python python-setuptools python-dev python-numpy

# libfontconfig is needed for grunt phantomjs...
RUN apt-get install -y libfontconfig

# RUN apt-get clean
# RUN rm -rf /var/lib/apt/lists/*

### JAVA ###

ENV JAVA_HOME /usr/jdk1.8.0_31
ENV PATH $PATH:$JAVA_HOME/bin

RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/server-jre-8u31-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C /usr/

RUN ln -s $JAVA_HOME /usr/java
# RUN rm -rf $JAVA_HOME/man

RUN easy_install py4j

### USERS ###

RUN echo 'root:root' | chpasswd

RUN groupadd datalayer
RUN useradd -d /home/dataayer -m -s /bin/bash -g datalayer datalayer
RUN echo 'datalayer:datalayer' | chpasswd

### SSH ###

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN su datalayer -c "ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''"
RUN su datalayer -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
ADD resources/ssh_config /home/datalayer/.ssh/config

RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

RUN chown datalayer:datalayer /home/datalayer/.ssh/config
RUN chmod 600 /home/datalayer/.ssh/config

### MAVEN ###

ENV MAVEN_VERSION 3.3.1
ENV MAVEN_HOME /usr/apache-maven-$MAVEN_VERSION
ENV PATH $PATH:$MAVEN_HOME/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/
RUN ln -s $MAVEN_HOME /usr/maven

### ZEPPELIN ###

ENV ZEPPELIN_HOME         /opt/zeppelin
ENV ZEPPELIN_CONF_DIR     $ZEPPELIN_HOME/conf
ENV ZEPPELIN_NOTEBOOK_DIR $ZEPPELIN_HOME/notebook
ENV ZEPPELIN_PORT         8080

ENV PATH $ZEPPELIN_HOME/zeppelin-web/node:$PATH
ENV PATH $ZEPPELIN_HOME/zeppelin-web/node_modules/grunt-cli/bin:$PATH

RUN git config --global url."https://".insteadOf git://

RUN git clone https://github.com/apache/incubator-zeppelin.git $ZEPPELIN_HOME

COPY ./resources/datalayer-cli-colors.sh $ZEPPELIN_HOME/bin/datalayer-cli-colors.sh
COPY ./resources/datalayer-echo-header.sh $ZEPPELIN_HOME/bin/datalayer-echo-header.sh
COPY ./resources/datalayer-zeppelin.sh $ZEPPELIN_HOME/bin/datalayer-zeppelin.sh

WORKDIR $ZEPPELIN_HOME

ENV SCALA_BINARY_VERSION 2.10
ENV SCALA_VERSION $SCALA_BINARY_VERSION.4
ENV SPARK_PROFILE 1.5
ENV SPARK_VERSION 1.5.1
ENV HADOOP_PROFILE 2.6
ENV HADOOP_VERSION 2.7.1

# curl -sL --retry 3 \
#   "http://mirrors.ibiblio.org/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE.tgz" \
#   | gunzip \
#   | tar x -C /usr/
#   && ln -s /usr/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE /usr/spark \
#   && rm -rf /usr/spark/examples \
#   && rm /usr/spark/lib/spark-examples*.jar

RUN git pull

RUN mvn clean \
    install \
    -pl '!flink,!geode,!ignite,!phoenix,!postgresql,!tajo' \
    -Phadoop-$HADOOP_PROFILE \
    -Dhadoop.version=$HADOOP_VERSION \
    -Pspark-$SPARK_PROFILE \
    -Dspark.version=$SPARK_VERSION \
    -Ppyspark \
    -Dscala.version=$SCALA_VERSION \
    -Dscala.binary.version=$SCALA_BINARY_VERSION \
    -Dmaven.findbugs.enable=false \
    -Drat.skip=true \
    -Dcheckstyle.skip=true \
    -DskipTests \
    "$@"

COPY ./resources/zeppelin-env.sh $ZEPPELIN_HOME/conf/zeppelin-env.sh

# RUN rm -rf /root/.m2
# RUN rm -rf /root/.npm

CMD "bin/datalayer-zeppelin.sh"
