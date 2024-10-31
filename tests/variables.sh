# Copyright 2022 Northern.tech AS
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

export TEST_NAME=mender-helm-test
export SEAWEEDFS_ACCESS_KEY_ID=$(kubectl get secret seaweedfs-s3-secret -o jsonpath='{.data.admin_access_key_id}' |base64 -d)
export SEAWEEDFS_SECRET_ACCESS_KEY=$(kubectl  get secret seaweedfs-s3-secret -o jsonpath='{.data.admin_secret_access_key}' |base64 -d)
export STORAGE_ENDPOINT="http://seaweedfs-s3:8333"
export MENDER_HELM_CHART_VERSION=`cat ./mender/Chart.yaml | grep ^version: | awk '{print($NF);}' | sed -e 's/"//g'`
