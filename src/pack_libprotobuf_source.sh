#!/bin/bash
TMP_DIR=".`date +%s`tmp"
FILE_LIST="libprotobuf-file-list.txt"
MODULE_NAME="ProtobufLibrary"
mkdir -p ${TMP_DIR}
cat ${FILE_LIST} | xargs -I {} cp --parents {} ${TMP_DIR}
rm -rf ${MODULE_NAME}
mkdir -p ${MODULE_NAME}/Public
mkdir -p ${MODULE_NAME}/Private
cd ${TMP_DIR}
find . -name "*.cc" | xargs -I {} cp --parents {} ../${MODULE_NAME}/Private
find . -name "*.cc" | xargs -I {} rm {}
find . -type f | xargs -I {} cp --parents {} ../${MODULE_NAME}/Public
cd ../${MODULE_NAME}
cd ..
rm -rf ${TMP_DIR}
