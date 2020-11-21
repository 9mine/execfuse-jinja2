#!/bin/bash

ls_templates() {
  find templates -type f -regextype posix-egrep -regex "^templates/(\
init
|unlink\
|truncate\
|getattr\
|chmod\
|mkdir\
|readdir\
|chown\
|destroy\
|open\
|create\
|mknod\
|check_args\
|rename\
|closed\
|read_file\
|mkfifo\
|symlink\
|link\
|utimens\
|write_file\
|rmdir\
|readlink\
)$"
} 

#TEMPLATE=`cat`
export TMP_FILE_ORIG=`mktemp execfuse_jinja2.yml.XXXXXX`
export TMP_FILE="${TMP_FILE_ORIG}_j2"
cat > ${TMP_FILE_ORIG}
jinja2 $TMP_FILE_ORIG > $TMP_FILE

export TEMPLATE_DIR="templates/"
export COMPILED_DIR="compiled"

test -d ${COMPILED_DIR} || mkdir -p ${COMPILED_DIR} 

ls_templates | xargs -P1 -I{} sh -xce '

  FILE_PATH={}
  export FILE_NAME=`basename ${FILE_PATH}`
  jinja2 -D FILE_NAME=${FILE_NAME} \
    -e jinja2.ext.loopcontrols \
    -e jinja2_ansible_filters.AnsibleCoreFiltersExtension ${FILE_PATH} < $TMP_FILE > ${COMPILED_DIR}/${FILE_NAME}
'

chmod +x ${COMPILED_DIR}/*
rm $TMP_FILE $TMP_FILE_ORIG
tar cvf - ${COMPILED_DIR}/*
