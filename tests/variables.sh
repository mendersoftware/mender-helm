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
export MINIO_accessKey=AKIAIOSFODNN7EXAMPLE
export MINIO_secretKey=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export MENDER_HELM_CHART_VERSION=`cat ./mender/Chart.yaml | grep ^version: | awk '{print($NF);}' | sed -e 's/"//g'`

