#!/bin/sh

unifictl(){
    OLD_DIR=$(pwd)
    cd /srv/unifi
    java -jar lib/ace.jar $*
}



if [[ "$ENTRYPOINT_FUNCS" == "" ]]; then
    ENTRYPOINT_FUNCS="unifictl:unifictl"
else
    ENTRYPOINT_FUNCS="${ENTRYPOINT_FUNCS} unifictl:unifictl"
fi

export ENTRYPOINT_FUNCS