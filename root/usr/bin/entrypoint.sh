#!/bin/sh

set -x

check_is_func(){
	type $1
    type "$1" 2> /dev/null|grep "is a shell function" > /dev/null 2>&1
    RC=$?
    if [[ $RC -eq 0 ]]; then
        exit 0
    else 
        exit 1
    fi
}

if [[ -d /etc/docker.entrypoint.d ]]; then
    for FILE in "/etc/docker.entrypoint.d/*.sh"; do
        . ${FILE}
    done
fi

CMD=$1
if [[ ${#@} -gt 0 ]]; then
    shift
fi

case $CMD in
    "unifi_controller_start")
        unifictl start
        ;;
    *)
        exec $CMD $@
        ;;
esac