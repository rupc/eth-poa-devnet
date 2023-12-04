#!/bin/bash
set -x
IMG_NAME="fgeth"
GETH_PATH="/home/jyr/go/bin/geth"

rm ./${geth}
cp --dereference ${GETH_PATH} ./geth


docker build -t ${IMG_NAME} .
set +x