#!/bin/bash

service supervisor start &&\
/bin/bash -l $*
tail -f /dev/null