#!/bin/bash

DATE="date"
WHOAMI="whoami"

DATA='/var/www/html/ccf/data'
DB='cmdi_forms'
TMP='/tmp'

if [ ! "$#" -gt 0 ]; then
    echo "ERR: missing profile file name (without extension)!"
    exit 1
fi

PROF="${1}"

DESCR="${PROF}"
if [ "$#" -gt 1 ]; then
    DESCR="${2}"
fi

OWNER=`${WHOAMI}`
if [ "$#" -gt 2 ]; then
    WHOAMI="${3}"
fi


echo 'USE `'${DB}'`;' > ${TMP}/p.sql
echo 'SET @xml = LOAD_FILE("'${DATA}'/profiles/'${PROF}'.xml");' >> ${TMP}/p.sql
echo 'INSERT INTO `profiles` (`name`, `description`, `content`, `owner`, `created`, `language`) VALUES ('"'${PROF}', '${DESCR}', @xml, '`${WHOAMI}`', '`${DATE} -Idate`', 'en');" >> ${TMP}/p.sql

mysql < ${TMP}/p.sql

echo "INF: Added profile[${PROF}] to the CCF simple CMDI editor"