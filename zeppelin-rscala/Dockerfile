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

### ENV ###

ENV PATH .:$PATH

RUN apt-get update

RUN apt-get install -y vim git wget unzip curl  \
  net-tools build-essential npm python python-setuptools \
  python-dev python-numpy openssh-server sysstat

# libfontconfig is needed for grunt phantomjs...
RUN apt-get install -y libfontconfig

ENV ZEPPELIN_REPO_URL        https://github.com/datalayer/zeppelin-R.git
ENV ZEPPELIN_REPO_BRANCH     rscala
ENV ZEPPELIN_HOME            /opt/zeppelin
ENV ZEPPELIN_CONF_DIR        $ZEPPELIN_HOME/conf
ENV ZEPPELIN_NOTEBOOK_DIR    $ZEPPELIN_HOME/notebook
ENV ZEPPELIN_PORT            8080
ENV SCALA_BINARY_VERSION     2.10
ENV SCALA_VERSION            $SCALA_BINARY_VERSION.4
ENV SPARK_PROFILE            1.5
ENV SPARK_VERSION            1.5.1
ENV HADOOP_PROFILE           2.6
ENV HADOOP_VERSION           2.7.1

### SSH ###

RUN mkdir /var/run/sshd
RUN echo 'root:datalayer' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN groupadd datalayer
RUN useradd -d /home/dataayer -m -s /bin/bash -g datalayer datalayer
RUN echo 'datalayer:datalayer' | chpasswd

### JAVA ###

RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/server-jre-8u31-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C /opt/
ENV JAVA_HOME /opt/jdk1.8.0_31
RUN ln -s $JAVA_HOME /opt/java
ENV PATH $PATH:$JAVA_HOME/bin

### PYTHON ###

RUN apt-get install -y python-pip python-matplotlib python-pandas ipython python-nose
# RUN apt-get install -y scipy
RUN easy_install py4j pandas pattern pandasql sympy

### MAVEN ###

ENV MAVEN_VERSION 3.3.1
ENV MAVEN_HOME /opt/apache-maven-$MAVEN_VERSION
ENV PATH $PATH:$MAVEN_HOME/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  | gunzip \
  | tar x -C /opt/
RUN ln -s $MAVEN_HOME /opt/maven

### SCALA ###

WORKDIR /opt
RUN curl http://www.scala-lang.org/files/archive/scala-2.10.4.tgz -o scala-2.10.4.tgz
RUN tar xvfz scala-2.10.4.tgz
RUN rm scala-2.10.4.tgz

ENV SCALA_HOME /opt/scala-2.10.4
ENV PATH $SCALA_HOME/bin:$PATH

### R ###

RUN apt-get install -y r-base r-cran-ggplot2 r-base-dev

RUN curl https://cran.r-project.org/src/contrib/Archive/rscala/rscala_1.0.6.tar.gz -o /opt/rscala_1.0.6.tar.gz
RUN R CMD INSTALL /opt/rscala_1.0.6.tar.gz
COPY resources/install-R-packages.R /opt/install-R-packages.R
RUN R CMD BATCH /opt/install-R-packages.R /opt/install-R-packages.R.out

### SPARK ###

WORKDIR /opt

RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE.tgz" \
  | gunzip \
  | tar x -C /opt/
#  && ln -s /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE /opt/spark
#  && rm -rf /opt/spark/examples \
#  && rm /opt/spark/lib/spark-examples*.jar

RUN mv /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE /opt/spark

ENV SPARK_HOME /opt/spark

# RUN curl http://apache.belnet.be/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz -o spark-1.5.2-bin-hadoop2.6.tgz
# RUN tar xvfz spark-1.5.2-bin-hadoop2.6.tgz

### ZEPPELIN ###

ENV PATH $ZEPPELIN_HOME/zeppelin-web/node:$PATH
ENV PATH $ZEPPELIN_HOME/zeppelin-web/node_modules/grunt-cli/bin:$PATH

RUN git config --global url."https://".insteadOf git://

RUN git clone $ZEPPELIN_REPO_URL $ZEPPELIN_HOME

WORKDIR $ZEPPELIN_HOME

RUN git checkout $ZEPPELIN_REPO_BRANCH

RUN mvn clean \
  install \
  -pl '!flink,!ignite,!phoenix,!postgresql,!tajo,!hive,!cassandra,!lens,!kylin' \
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
  -DskipTests

# Temporary fix to deal with conflicting akka provided jackson jars.
# RUN rm zeppelin-server/target/lib/jackson-*
# RUN rm zeppelin-zengine/target/lib/jackson-*

COPY ./resources/datalayer-cli-colors.sh $ZEPPELIN_HOME/bin/datalayer-cli-colors.sh
COPY ./resources/datalayer-echo-header.sh $ZEPPELIN_HOME/bin/datalayer-echo-header.sh
COPY ./resources/datalayer-zeppelin.sh $ZEPPELIN_HOME/bin/datalayer-zeppelin.sh
COPY ./resources/log4j.properties $ZEPPELIN_HOME/conf/log4j.properties
COPY ./resources/zeppelin-env.sh $ZEPPELIN_HOME/conf/zeppelin-env.sh

ENV PATH $ZEPPELIN_HOME/bin:$PATH

RUN mkdir /opt/zeppelin/logs
RUN mkdir /opt/zeppelin/run

### WEBAPP ###

COPY ./webapp $ZEPPELIN_HOME/zeppelin-web/dist/

### NOTEBOOK ###

RUN mkdir /notebook
ADD notebook/tutorial /notebook/tutorial
ADD notebook/r-tutorial /notebook/r-tutorial

# Don't add interpreter.json @see https://github.com/datalayer/zeppelin-docker/issues/1
# COPY ./resources/interpreter.json $ZEPPELIN_HOME/conf/interpreter.json

### DATASET ###

# RUN mkdir /dataset
# ADD dataset /dataset

### HADOOP ###

RUN mkdir -p /etc/hadoop/conf
ADD resources/hadoop /etc/hadoop/conf

### CLEAN ###

RUN rm -rf /root/.m2
RUN rm -rf /root/.npm
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

### INTERFACE ###

EXPOSE 22
EXPOSE 4040
EXPOSE 8080

ENTRYPOINT ["/opt/zeppelin/bin/datalayer-zeppelin.sh"]
