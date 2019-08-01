#!/bin/bash

sed -i 's/display_errors = Off/display_errors = On/g' /etc/php/7.2/apache2/php.ini
service supervisor start &&\
/bin/bash -l "$*"
tail -f /dev/null