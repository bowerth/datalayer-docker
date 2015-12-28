#!/bin/bash

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

source $ZEPPELIN_HOME/bin/datalayer-cli-colors.sh

$ZEPPELIN_HOME/bin/datalayer-echo-header.sh

/etc/init.d/ssh start > /dev/null

function print_info()
{
echo
echo -e $YELLOW"Go to "$BOLD"http://localhost:8080"$NOBOLD" and play with the Apache Zeppelin Notebook."$NOCOLOR
echo
echo -e $YELLOW"Go to "$BOLD"http://localhost:4040"$NOBOLD" to view Spark jobs."$NOCOLOR
echo
echo -e $YELLOW"Connect with "$BOLD"ssh root@localhost -p 2222"$NOBOLD$NOCOLOR
echo -e $YELLOW"             (password=datalayer)"$NOCOLOR
echo
echo -e $YELLOW"Type CTRL-C to terminate the process."$NOCOLOR
echo
}

echo

if [ "$DOCKER_ZEPPELIN_LOG_CONSOLE" == "false" ]
then
  $ZEPPELIN_HOME/bin/zeppelin.sh start "$@"
else
  $ZEPPELIN_HOME/bin/zeppelin-daemon.sh start "$@"
  print_info
  tail -f $ZEPPELIN_HOME/logs/zeppelin.log
fi

echo
echo
echo -e $YELLOW"Bye bye Zeppelin user... Hope to seen you back soon!"$NOCOLOR
echo
echo
