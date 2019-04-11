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

if [ ! -f ${DATA}/profiles/${PROF}.xml ]; then
    echo "ERR: profile[${PROF}] file[${DATA}/profiles/${PROF}.xml] can't be found!"
    exit 1
fi

TWEAK=''
if [ -f ${DATA}/tweaks/${PROF}Tweak.xml ]; then
    TWEAK="${DATA}/tweaks/${PROF}Tweak.xml"
fi

echo 'USE `'${DB}'`;' > ${TMP}/p.sql
echo 'SET @prf = LOAD_FILE("'${DATA}'/profiles/'${PROF}'.xml");' >> ${TMP}/p.sql
if [ -z ${TWEAK} ]; then
    echo 'INSERT INTO `profiles` (`name`, `description`, `content`, `owner`, `created`, `language`) VALUES ('"'${PROF}', '${DESCR}', @prf, '`${WHOAMI}`', '`${DATE} -Idate`', 'en');" >> ${TMP}/p.sql
else
    echo 'SET @twk = LOAD_FILE("'${TWEAK}'");' >> ${TMP}/p.sql
    echo 'INSERT INTO `profiles` (`name`, `description`, `content`, `tweak`, `owner`, `created`, `language`) VALUES ('"'${PROF}', '${DESCR}', @prf, @twk, '`${WHOAMI}`', '`${DATE} -Idate`', 'en');" >> ${TMP}/p.sql
fi

mysql < ${TMP}/p.sql

if [ -z ${TWEAK} ]; then
    echo "INF: Added profile[${PROF}] to the CCF simple CMDI editor (without tweak)"
else
    echo "INF: Added profile[${PROF}] to the CCF simple CMDI editor (with tweak)"
fi