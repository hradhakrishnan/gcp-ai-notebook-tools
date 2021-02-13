#!/bin/bash

# @hariprasad
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#   ___  _____   _   _       _       _                 _
#  / _ \|_   _| | \ | |     | |     | |               | |
# / /_\ \ | |   |  \| | ___ | |_ ___| |__   ___   ___ | | __
# |  _  | | |   | . ` |/ _ \| __/ _ \ '_ \ / _ \ / _ \| |/ /
# | | | |_| |_  | |\  | (_) | ||  __/ |_) | (_) | (_) |   <
# \_| |_/\___/  \_| \_/\___/ \__\___|_.__/ \___/ \___/|_|\_\



export INSTANCE_NAME="notebook-instance-1"
export VM_IMAGE_PROJECT="deeplearning-platform-release"
export VM_IMAGE_FAMILY="common-cpu-notebooks"
export MACHINE_TYPE="n1-standard-1"
export LOCATION="us-central1-b"

function create_notebook() {
  banner
  echo ''
  echo ''
  echo '-----------------------------------------'
  echo '| Creating notebook instance             |'
  echo '-----------------------------------------'
  echo ''
  echo '----- logging using account--------------'
  gcloud info --format='value(config.account)'
  echo '-----------------------------------------'

  gcloud beta notebooks instances create $INSTANCE_NAME \
  --vm-image-project=$VM_IMAGE_PROJECT \
  --vm-image-family=$VM_IMAGE_FAMILY \
  --machine-type=$MACHINE_TYPE --location=$LOCATION

  status
}

function stop_notebook() {
  echo '-----------------------------------------'
  echo '|     Stopping notebook instance         |'
  echo '-----------------------------------------'
  gcloud beta notebooks instances stop $INSTANCE_NAME --location=$LOCATION --format='flattened()'
  status
}

function start_notebook() {
  banner
  echo ''
  echo ''
  echo '-----------------------------------------'
  echo '|    Starting notebook instance          |'
  echo '-----------------------------------------'
  gcloud beta notebooks instances start $INSTANCE_NAME --location=$LOCATION --format='flattened()'
  status
}

function status() {
  echo '-----------------------------------------'
  echo '|    Notebook instance Status            |'
  echo '-----------------------------------------'
  gcloud notebooks instances describe $INSTANCE_NAME  --location=$LOCATION --format='table[box,title=\_______O_______/](state:label=notebook_status,machineType.scope(machineTypes),metadata.framework:label=framework,createTime.date('%Y-%m-%d'):label=created)'
  get_url
}

function describe_notebook() {
  echo '-----------------------------------------'
  echo '      Notebook instance Description      |'
  echo '-----------------------------------------'
  gcloud notebooks instances describe $INSTANCE_NAME  --location=$LOCATION --format='flattened()'

}

function get_url() {
  echo '-----------------------------------------'
  echo '|      Jupyter notebook url              |'
  echo '-----------------------------------------'

  proxyUri=$(gcloud notebooks instances describe $INSTANCE_NAME  --location=$LOCATION --format='value(proxyUri)')
  if [ -z "$proxyUri" ]
  then
    echo ''
    echo " *** No active notebook url found  ***"
    echo ''
  else
    echo ''
    echo "https://$proxyUri"
    echo ''
  fi
}

function delete_notebook() {
  echo '-----------------------------------------'
  echo '|      Deleting notebook instance        |'
  echo '-----------------------------------------'
  gcloud beta notebooks instances delete $INSTANCE_NAME  --location=$LOCATION --format='flattened()'
}

function print_help() {
  echo '-------------------------------------------------'
  echo '| Script for launching notebook instance on GCP  |'
  echo '-------------------------------------------------'

  echo "configure environmental variables on the script"
  echo ""
  echo "-INSTANCE_NAME                                notebook instance name"
  echo "-VM_IMAGE_PROJECT                             Use this VM image name to find the image."
  echo "-VM_IMAGE_FAMILY                              common-cpu-notebooks"
  echo "-MACHINE_TYPE                                 The Compute Engine machine type of this instance."
  echo "-LOCATION                                     Google Cloud location of this environment "
}

function banner() {
  echo '  ___  _____   _   _       _       _                 _    '
  echo ' / _ \|_   _| | \ | |     | |     | |               | |   '
  echo '/ /_\ \ | |   |  \| | ___ | |_ ___| |__   ___   ___ | | __'
  echo '|  _  | | |   | .   |/ _ \| __/ _ \  _ \ / _ \ / _ \| |/ /'
  echo '| | | |_| |_  | |\  | (_) | ||  __/ |_) | (_) | (_) |   < '
  echo '\_| |_/\___/  \_| \_/\___/ \__\___|_.__/ \___/ \___/|_|\_\'
}

case "$1" in
    create)
       create_notebook
       ;;
    start)
       start_notebook
       ;;
    stop)
       stop_notebook
       ;;
    delete)
       delete_notebook
       ;;
    status)
       status
       ;;
    describe)
       describe_notebook
       ;;
    url)
       get_url
       ;;
    help)
       print_help
       ;;
    *)
       echo "Usage: $0 {create | start | stop | status | url | delete | describe | help}"
esac

exit 0
