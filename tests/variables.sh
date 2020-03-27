
export TEST_NAME=mender-helm-test
export MINIO_accessKey=AKIAIOSFODNN7EXAMPLE
export MINIO_secretKey=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export MENDER_HELM_CHART_VERSION=`cat ./mender/Chart.yaml | grep ^version: | awk '{print($NF);}' | sed -e 's/"//g'`

