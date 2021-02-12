#!/bin/bash

# Copyright 2021 Google Inc.
#
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



export INSTANCE_NAME="notebook-instance-1o"
export VM_IMAGE_PROJECT="deeplearning-platform-release"
export VM_IMAGE_FAMILY="common-cpu-notebooks"
export MACHINE_TYPE="n1-standard-1"
export LOCATION="us-central1-b"

function create_notebook() {
echo '-----------------------------------------'
echo '| Creating notebook instance             |'
echo '-----------------------------------------'


gcloud beta notebooks instances create $INSTANCE_NAME \
  --vm-image-project=$VM_IMAGE_PROJECT \
  --vm-image-family=$VM_IMAGE_FAMILY \
  --machine-type=$MACHINE_TYPE --location=$LOCATION
}

function stop_notebook() {

echo '-----------------------------------------'
echo '| Stop notebook instance                 |'
echo '-----------------------------------------'

gcloud beta notebooks instances stop $INSTANCE_NAME --location=$LOCATION
}

function start_notebook() {
echo '-----------------------------------------'
echo '| Start notebook instance                |'
echo '-----------------------------------------'

gcloud beta notebooks instances start $INSTANCE_NAME --location=$LOCATION
}

function describe_notebook() {
echo '-----------------------------------------'
echo '| Describe notebook instance             |'
echo '-----------------------------------------'

  gcloud notebooks instances describe $INSTANCE_NAME  --location=$LOCATION
}

function delete_notebook() {
echo '-----------------------------------------'
echo '| Delete notebook instance               |'
echo '-----------------------------------------'

  gcloud beta notebooks instances delete $INSTANCE_NAME  --location=$LOCATION

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
       describe_notebook
       ;;
    help)
       print_help
       ;;
    *)
       echo "Usage: $0 {create|start|stop|status|delete|help}"
esac

exit 0
