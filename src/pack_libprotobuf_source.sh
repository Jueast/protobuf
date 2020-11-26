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

# ignore warnings 
echo '
// Disable some warning
#ifdef _MSC_VER
#pragma warning(disable:4065 4125 4800 4946 4582)
#endif //_MSC_VER

// Disable some warning
#if defined(_MSC_VER) && defined(_MM_PROTOBUF_LIBRARY_INTERNAL)
#pragma warning(disable:4127 4100 4276 4389 4018 4267 4457 4310 4506 4146 4996 4661)
#endif //_MSC_VER
' >> Public/google/protobuf/port_def.inc
# replace export tag

find . -type f | grep -v "port" | xargs -I {} sed -i "s/\<PROTOBUF_EXPORT\>/${MODULE_NAME^^}_API/g" {}
find . -type f | grep -v "port" | xargs -I {} sed -i "s/\<PROTOBUF_EXPORT_TEMPLATE_DEFINE\>/${MODULE_NAME^^}_API/g" {}
find . -type f | grep -v "port" | xargs -I {} sed -i "s/<windows.h>/\"Windows\/MinWindows.h\"/g" {}

cd ..
rm -rf ${TMP_DIR}
