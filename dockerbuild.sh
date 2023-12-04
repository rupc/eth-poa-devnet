#!/bin/bash
set -x
IMG_NAME="fgeth"
GETH_PATH="/home/jyr/go/bin/geth"

rm ./${IMG_NAME}
cp --dereference ${GETH_PATH} ./geth


docker build -t ${IMG_NAME} .
set +x