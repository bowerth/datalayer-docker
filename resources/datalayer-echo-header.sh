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

source datalayer-cli-colors

echo -e "$GREEN$BOLD"
echo -e " Welcome to Datalayer, your easy path to Big Data Science."
echo -e "             ___       __       __                 "
echo -e "   _______  / _ \___ _/ /____ _/ /__ ___ _____ ____"
echo -e "  _______  / // / _ \`/ __/ _ \`/ / _ \`/ // / -_) __/"
echo -e " _______  /____/\_,_/\__/\_,_/_/\_,_/\_, /\__/_/   "
echo -e "                                    /___/          "
echo -e ""
echo -e " http://datalayer.io    @datalayerio"
echo -e " docker@datalayer.io"$NOBOLD$NOCOLOR
echo -e ""

if [ "$1" == "-v" ]
then
  datalayer-echo-platform
  exit 0
fi

if [ "$1" == "version" ]
then
  datalayer-echo-platform
  exit 0
fi

if [ "$1" == "help" ]
then
  datalayer-echo-help
  exit 0
fi
